import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/cidade.dart';
import 'api_exception.dart';


class ClimaService {
  ClimaService({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';
  static const Duration _timeout = Duration(seconds: 12);

  static const String _variaveisAtuais =
      'temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m';
  static const String _variaveisDiarias =
      'weather_code,temperature_2m_max,temperature_2m_min,precipitation_sum,'
      'precipitation_probability_max,uv_index_max,wind_speed_10m_max';

  final http.Client _client;


  Future<List<Map<String, dynamic>>> buscarPrevisoes(List<Cidade> cidades) async {
    if (cidades.isEmpty) return [];

    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'latitude': cidades.map((c) => c.latitude.toStringAsFixed(4)).join(','),
      'longitude': cidades.map((c) => c.longitude.toStringAsFixed(4)).join(','),
      'current': _variaveisAtuais,
      'daily': _variaveisDiarias,
      'timezone': List.filled(cidades.length, 'auto').join(','),
      'forecast_days': '7',
    });

    try {
      final resposta = await _client.get(uri).timeout(_timeout);

      if (resposta.statusCode != 200) {
        throw ApiException(
          'O serviço de previsão está indisponível no momento (erro ${resposta.statusCode}).',
        );
      }

      final corpo = jsonDecode(utf8.decode(resposta.bodyBytes));

  
      if (corpo is List) {
        return corpo.map((item) => item as Map<String, dynamic>).toList();
      }
      if (corpo is Map<String, dynamic>) {
        return [corpo];
      }
      throw const FormatException();
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const ApiException(
        'A consulta demorou demais. Verifique sua internet e tente novamente.',
      );
    } on FormatException {
      throw const ApiException('Recebemos uma resposta inválida do servidor.');
    } catch (_) {
      throw const ApiException(
        'Não foi possível conectar. Verifique sua conexão com a internet.',
      );
    }
  }
}
