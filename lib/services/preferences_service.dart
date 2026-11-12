import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/cidade.dart';


class PreferencesService {
  static const String _chaveOnboardingConcluido = 'onboarding_concluido';
  static const String _chaveCidades = 'cidades_monitoradas';
  static const String _chaveFavoritas = 'cidades_favoritas';
  static const String _prefixoCachePrevisao = 'cache_previsao_';
  static const String _chaveCacheData = 'cache_previsao_data';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  

  
  Future<bool> deveExibirOnboarding() async {
    final prefs = await _prefs;
    return !(prefs.getBool(_chaveOnboardingConcluido) ?? false);
  }

  
  Future<void> salvarPreferenciaOnboarding({required bool naoMostrarNovamente}) async {
    final prefs = await _prefs;
    await prefs.setBool(_chaveOnboardingConcluido, naoMostrarNovamente);
  }

  

  
  Future<List<Cidade>?> lerCidades() async {
    final prefs = await _prefs;
    final itens = prefs.getStringList(_chaveCidades);
    if (itens == null) return null;
    return itens
        .map((texto) => Cidade.fromJson(jsonDecode(texto) as Map<String, dynamic>))
        .toList();
  }

  Future<void> salvarCidades(List<Cidade> cidades) async {
    final prefs = await _prefs;
    await prefs.setStringList(
      _chaveCidades,
      cidades.map((cidade) => jsonEncode(cidade.toJson())).toList(),
    );
  }

  

  Future<Set<String>> lerFavoritas() async {
    final prefs = await _prefs;
    return (prefs.getStringList(_chaveFavoritas) ?? <String>[]).toSet();
  }

  Future<void> salvarFavoritas(Set<String> ids) async {
    final prefs = await _prefs;
    await prefs.setStringList(_chaveFavoritas, ids.toList());
  }

  

  Future<void> salvarCachePrevisao(String cidadeId, Map<String, dynamic> json) async {
    final prefs = await _prefs;
    await prefs.setString('$_prefixoCachePrevisao$cidadeId', jsonEncode(json));
  }

  Future<Map<String, dynamic>?> lerCachePrevisao(String cidadeId) async {
    final prefs = await _prefs;
    final texto = prefs.getString('$_prefixoCachePrevisao$cidadeId');
    if (texto == null) return null;
    return jsonDecode(texto) as Map<String, dynamic>;
  }

  Future<void> salvarDataCache(DateTime data) async {
    final prefs = await _prefs;
    await prefs.setString(_chaveCacheData, data.toIso8601String());
  }

  Future<DateTime?> lerDataCache() async {
    final prefs = await _prefs;
    final texto = prefs.getString(_chaveCacheData);
    return texto == null ? null : DateTime.tryParse(texto);
  }
}
