
class Formatters {
  Formatters._();

  static const List<String> _diasSemana = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

  static String _doisDigitos(int valor) => valor.toString().padLeft(2, '0');

  
  static String diaMes(DateTime data) => '${_doisDigitos(data.day)}/${_doisDigitos(data.month)}';

  
  static String hora(DateTime data) => '${_doisDigitos(data.hour)}:${_doisDigitos(data.minute)}';

  
  static String diaRelativo(DateTime data, {DateTime? referencia}) {
    final hoje = referencia ?? DateTime.now();
    final inicioHoje = DateTime(hoje.year, hoje.month, hoje.day);
    final inicioData = DateTime(data.year, data.month, data.day);
    final diferenca = inicioData.difference(inicioHoje).inDays;
    if (diferenca == 0) return 'Hoje';
    if (diferenca == 1) return 'Amanhã';
    return _diasSemana[data.weekday - 1];
  }

  static String temperatura(double valor) => '${valor.round()}°';

  static String milimetros(double valor) => '${valor.toStringAsFixed(1).replaceAll('.', ',')} mm';
}
