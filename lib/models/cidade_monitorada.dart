import 'alerta.dart';
import 'cidade.dart';
import 'previsao_clima.dart';


class CidadeMonitorada {
  const CidadeMonitorada({
    required this.cidade,
    required this.previsao,
    required this.alertas,
    this.favorita = false,
  });

  final Cidade cidade;
  final PrevisaoClima previsao;
  final List<Alerta> alertas;
  final bool favorita;

  
  NivelAlerta? get nivelMaximo => alertas.isEmpty ? null : alertas.first.nivel;
}
