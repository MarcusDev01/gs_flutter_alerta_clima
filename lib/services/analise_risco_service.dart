import '../core/constants/app_constants.dart';
import '../core/utils/formatters.dart';
import '../models/alerta.dart';
import '../models/previsao_clima.dart';





class AnaliseRiscoService {
  const AnaliseRiscoService();

  
  
  List<Alerta> analisar(PrevisaoClima previsao) {
    final porTipo = <TipoAlerta, Alerta>{};

    void registrar(Alerta? alerta) {
      if (alerta == null) return;
      final atual = porTipo[alerta.tipo];
      if (atual == null || alerta.nivel.peso > atual.nivel.peso) {
        porTipo[alerta.tipo] = alerta;
      }
    }

    registrar(_avaliarUmidade(previsao.atual));

    final dias = previsao.dias.take(AppConstants.diasAnalisados);
    for (final dia in dias) {
      registrar(_avaliarChuva(dia));
      registrar(_avaliarCalor(dia));
      registrar(_avaliarVento(dia));
      registrar(_avaliarUv(dia));
      registrar(_avaliarFrio(dia));
    }

    final alertas = porTipo.values.toList()
      ..sort((a, b) => b.nivel.peso.compareTo(a.nivel.peso));
    return alertas;
  }

  
  
  NivelAlerta? classificar(
    double valor, {
    required double atencao,
    required double perigo,
    required double grandePerigo,
    bool maiorEhPior = true,
  }) {
    bool atingiu(double limite) => maiorEhPior ? valor >= limite : valor <= limite;

    if (atingiu(grandePerigo)) return NivelAlerta.grandePerigo;
    if (atingiu(perigo)) return NivelAlerta.perigo;
    if (atingiu(atencao)) return NivelAlerta.atencao;
    return null;
  }

  Alerta? _criar(TipoAlerta tipo, NivelAlerta? nivel, DateTime data, String detalhe) {
    if (nivel == null) return null;
    return Alerta(tipo: tipo, nivel: nivel, data: data, detalhe: detalhe);
  }

  Alerta? _avaliarChuva(PrevisaoDiaria dia) {
    final nivel = classificar(dia.chuvaMilimetros, atencao: 30, perigo: 50, grandePerigo: 100);
    return _criar(
      TipoAlerta.chuvaForte,
      nivel,
      dia.data,
      '${Formatters.milimetros(dia.chuvaMilimetros)} de chuva previstos '
      '(${dia.probabilidadeChuva}% de chance)',
    );
  }

  Alerta? _avaliarCalor(PrevisaoDiaria dia) {
    final nivel = classificar(dia.temperaturaMaxima, atencao: 35, perigo: 37, grandePerigo: 40);
    return _criar(
      TipoAlerta.calorExtremo,
      nivel,
      dia.data,
      'Máxima de ${Formatters.temperatura(dia.temperaturaMaxima)}C',
    );
  }

  Alerta? _avaliarVento(PrevisaoDiaria dia) {
    final nivel = classificar(dia.ventoMaximo, atencao: 40, perigo: 60, grandePerigo: 90);
    return _criar(
      TipoAlerta.ventoForte,
      nivel,
      dia.data,
      'Ventos de até ${dia.ventoMaximo.round()} km/h',
    );
  }

  Alerta? _avaliarUv(PrevisaoDiaria dia) {
    final nivel = classificar(dia.indiceUv, atencao: 8, perigo: 11, grandePerigo: 14);
    return _criar(
      TipoAlerta.radiacaoUv,
      nivel,
      dia.data,
      'Índice UV ${dia.indiceUv.toStringAsFixed(0)}',
    );
  }

  Alerta? _avaliarFrio(PrevisaoDiaria dia) {
    final nivel = classificar(
      dia.temperaturaMinima,
      atencao: 8,
      perigo: 3,
      grandePerigo: 0,
      maiorEhPior: false,
    );
    return _criar(
      TipoAlerta.frioIntenso,
      nivel,
      dia.data,
      'Mínima de ${Formatters.temperatura(dia.temperaturaMinima)}C',
    );
  }

  Alerta? _avaliarUmidade(CondicaoAtual atual) {
    
    if (atual.umidade <= 0) return null;
    final nivel = classificar(
      atual.umidade,
      atencao: 30,
      perigo: 20,
      grandePerigo: 12,
      maiorEhPior: false,
    );
    return _criar(
      TipoAlerta.baixaUmidade,
      nivel,
      atual.horario,
      'Umidade do ar em ${atual.umidade.round()}% agora',
    );
  }
}
