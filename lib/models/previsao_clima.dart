
class CondicaoAtual {
  const CondicaoAtual({
    required this.horario,
    required this.temperatura,
    required this.sensacaoTermica,
    required this.umidade,
    required this.precipitacao,
    required this.codigoTempo,
    required this.velocidadeVento,
  });

  final DateTime horario;
  final double temperatura;
  final double sensacaoTermica;
  final double umidade;
  final double precipitacao;
  final int codigoTempo;
  final double velocidadeVento;

  factory CondicaoAtual.fromJson(Map<String, dynamic> json) {
    return CondicaoAtual(
      horario: DateTime.tryParse(json['time']?.toString() ?? '') ?? DateTime.now(),
      temperatura: _paraDouble(json['temperature_2m']),
      sensacaoTermica: _paraDouble(json['apparent_temperature']),
      umidade: _paraDouble(json['relative_humidity_2m']),
      precipitacao: _paraDouble(json['precipitation']),
      codigoTempo: _paraDouble(json['weather_code']).toInt(),
      velocidadeVento: _paraDouble(json['wind_speed_10m']),
    );
  }
}


class PrevisaoDiaria {
  const PrevisaoDiaria({
    required this.data,
    required this.codigoTempo,
    required this.temperaturaMaxima,
    required this.temperaturaMinima,
    required this.chuvaMilimetros,
    required this.probabilidadeChuva,
    required this.indiceUv,
    required this.ventoMaximo,
  });

  final DateTime data;
  final int codigoTempo;
  final double temperaturaMaxima;
  final double temperaturaMinima;
  final double chuvaMilimetros;
  final int probabilidadeChuva;
  final double indiceUv;
  final double ventoMaximo;
}


class PrevisaoClima {
  const PrevisaoClima({required this.atual, required this.dias});

  final CondicaoAtual atual;
  final List<PrevisaoDiaria> dias;

  
  
  
  
  
  factory PrevisaoClima.fromJson(Map<String, dynamic> json) {
    final daily = json['daily'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final datas = (daily['time'] as List<dynamic>?) ?? <dynamic>[];

    final dias = <PrevisaoDiaria>[];
    for (var i = 0; i < datas.length; i++) {
      dias.add(
        PrevisaoDiaria(
          data: DateTime.parse(datas[i].toString()),
          codigoTempo: _valorDoDia(daily, 'weather_code', i).toInt(),
          temperaturaMaxima: _valorDoDia(daily, 'temperature_2m_max', i),
          temperaturaMinima: _valorDoDia(daily, 'temperature_2m_min', i),
          chuvaMilimetros: _valorDoDia(daily, 'precipitation_sum', i),
          probabilidadeChuva: _valorDoDia(daily, 'precipitation_probability_max', i).round(),
          indiceUv: _valorDoDia(daily, 'uv_index_max', i),
          ventoMaximo: _valorDoDia(daily, 'wind_speed_10m_max', i),
        ),
      );
    }

    return PrevisaoClima(
      atual: CondicaoAtual.fromJson(json['current'] as Map<String, dynamic>? ?? <String, dynamic>{}),
      dias: dias,
    );
  }

  static double _valorDoDia(Map<String, dynamic> daily, String chave, int indice) {
    final lista = daily[chave];
    if (lista is List && indice < lista.length) {
      return _paraDouble(lista[indice]);
    }
    return 0;
  }
}


double _paraDouble(dynamic valor) {
  if (valor is num) return valor.toDouble();
  return 0;
}
