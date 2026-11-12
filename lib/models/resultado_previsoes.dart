import 'previsao_clima.dart';


class ResultadoPrevisoes {
  const ResultadoPrevisoes({
    required this.previsoesPorCidade,
    required this.atualizadoEm,
    this.doCache = false,
  });

  
  final Map<String, PrevisaoClima> previsoesPorCidade;
  final DateTime atualizadoEm;
  final bool doCache;
}
