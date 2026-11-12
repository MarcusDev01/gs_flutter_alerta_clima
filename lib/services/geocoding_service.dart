import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/cidade.dart';
import 'api_exception.dart';


class GeocodingService {
  GeocodingService({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl = 'https://geocoding-api.open-meteo.com/v1/search';
  static const Duration _timeout = Duration(seconds: 10);

  final http.Client _client;

  Future<List<Cidade>> buscarCidades(String nome) async {
    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'name': nome.trim(),
      'count': '15',
      'language': 'pt',
      'countryCode': 'BR',
      'format': 'json',
    });

    try {
      final resposta = await _client.get(uri).timeout(_timeout);

      if (resposta.statusCode != 200) {
        throw ApiException('Não foi possível buscar cidades agora (erro ${resposta.statusCode}).');
      }

      final json = jsonDecode(utf8.decode(resposta.bodyBytes)) as Map<String, dynamic>;
      
      final resultados = json['results'] as List<dynamic>? ?? <dynamic>[];
      return resultados
          .map((item) => Cidade.fromGeocodingJson(item as Map<String, dynamic>))
          .toList();
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const ApiException('A busca demorou demais. Tente novamente.');
    } catch (_) {
      throw const ApiException(
        'Não foi possível conectar. Verifique sua conexão com a internet.',
      );
    }
  }
}
