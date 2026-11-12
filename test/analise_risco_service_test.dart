import 'package:alerta_clima/models/alerta.dart';
import 'package:alerta_clima/models/previsao_clima.dart';
import 'package:alerta_clima/services/analise_risco_service.dart';
import 'package:flutter_test/flutter_test.dart';

/// Monta um JSON no formato da Open-Meteo com 3 dias de previsão.
Map<String, dynamic> _json({
  List<num> chuva = const [0, 0, 0],
  List<num> maxima = const [28, 28, 28],
  num umidade = 60,
}) {
  return {
    'current': {
      'time': '2026-11-12T15:00',
      'temperature_2m': 27.5,
      'relative_humidity_2m': umidade,
      'apparent_temperature': 29,
      'precipitation': 0,
      'weather_code': 3,
      'wind_speed_10m': 12,
    },
    'daily': {
      'time': ['2026-11-12', '2026-11-13', '2026-11-14'],
      'weather_code': [3, 61, 95],
      'temperature_2m_max': maxima,
      'temperature_2m_min': [18, 18, 18],
      'precipitation_sum': chuva,
      'precipitation_probability_max': [10, 80, 90],
      'uv_index_max': [5, 5, 5],
      'wind_speed_10m_max': [15, 15, 15],
    },
  };
}

void main() {
  const service = AnaliseRiscoService();

  test('converte o JSON da Open-Meteo no model', () {
    final previsao = PrevisaoClima.fromJson(_json());
    expect(previsao.dias.length, 3);
    expect(previsao.atual.temperatura, 27.5);
    expect(previsao.dias[1].probabilidadeChuva, 80);
  });

  test('tempo tranquilo não gera alertas', () {
    final alertas = service.analisar(PrevisaoClima.fromJson(_json()));
    expect(alertas, isEmpty);
  });

  test('chuva de 120 mm gera alerta de grande perigo', () {
    final alertas = service.analisar(PrevisaoClima.fromJson(_json(chuva: [0, 120, 10])));
    expect(alertas.first.tipo, TipoAlerta.chuvaForte);
    expect(alertas.first.nivel, NivelAlerta.grandePerigo);
  });

  test('mantém só o dia mais crítico de cada tipo e ordena por gravidade', () {
    final alertas = service.analisar(
      PrevisaoClima.fromJson(_json(chuva: [35, 55, 0], maxima: [41, 30, 30], umidade: 25)),
    );
    final tipos = alertas.map((a) => a.tipo).toList();
    expect(tipos.where((t) => t == TipoAlerta.chuvaForte).length, 1);
    expect(alertas.first.nivel, NivelAlerta.grandePerigo); // calor de 41°
    expect(alertas.last.nivel, NivelAlerta.atencao); // umidade de 25%
  });
}
