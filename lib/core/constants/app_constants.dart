import '../../models/cidade.dart';


class AppConstants {
  AppConstants._();

  static const String nomeApp = 'Alerta Clima';
  static const String slogan = 'Antecipe o risco. Proteja quem você ama.';

  static const String logoPath = 'assets/images/logo.png';
  static const Duration duracaoSplash = Duration(seconds: 2);


  static const int diasAnalisados = 3;

  static const List<Map<String, String>> desenvolvedores = [
    {'nome': 'Marcus Vinicius Martinho Lucas', 'rm': 'RM554616'},
    {'nome': 'Henry Titotto ', 'rm': 'RM555421'},
  ];


  static const List<Cidade> cidadesPadrao = [
    Cidade(nome: 'São Paulo', estado: 'São Paulo', latitude: -23.5505, longitude: -46.6333),
    Cidade(nome: 'Rio de Janeiro', estado: 'Rio de Janeiro', latitude: -22.9068, longitude: -43.1729),
    Cidade(nome: 'Porto Alegre', estado: 'Rio Grande do Sul', latitude: -30.0346, longitude: -51.2177),
    Cidade(nome: 'Recife', estado: 'Pernambuco', latitude: -8.0476, longitude: -34.8770),
    Cidade(nome: 'Cuiabá', estado: 'Mato Grosso', latitude: -15.6010, longitude: -56.0974),
    Cidade(nome: 'Manaus', estado: 'Amazonas', latitude: -3.1190, longitude: -60.0217),
  ];
}
