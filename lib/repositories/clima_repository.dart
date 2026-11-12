import '../models/cidade.dart';
import '../models/previsao_clima.dart';
import '../models/resultado_previsoes.dart';
import '../services/api_exception.dart';
import '../services/clima_service.dart';
import '../services/preferences_service.dart';


class ClimaRepository {
  ClimaRepository({
    ClimaService? climaService,
    PreferencesService? preferencesService,
  })  : _climaService = climaService ?? ClimaService(),
        _preferencesService = preferencesService ?? PreferencesService();

  final ClimaService _climaService;
  final PreferencesService _preferencesService;

  Future<ResultadoPrevisoes> buscarPrevisoes(List<Cidade> cidades) async {
    try {
      final jsons = await _climaService.buscarPrevisoes(cidades);
      final previsoes = <String, PrevisaoClima>{};

      for (var i = 0; i < cidades.length && i < jsons.length; i++) {
        final cidade = cidades[i];
        
        previsoes[cidade.id] = PrevisaoClima.fromJson(jsons[i]);
        await _preferencesService.salvarCachePrevisao(cidade.id, jsons[i]);
      }

      final agora = DateTime.now();
      await _preferencesService.salvarDataCache(agora);
      return ResultadoPrevisoes(previsoesPorCidade: previsoes, atualizadoEm: agora);
    } on ApiException {
      
      final doCache = await _buscarDoCache(cidades);
      if (doCache != null) return doCache;
      rethrow;
    }
  }

  Future<ResultadoPrevisoes?> _buscarDoCache(List<Cidade> cidades) async {
    final previsoes = <String, PrevisaoClima>{};
    for (final cidade in cidades) {
      final json = await _preferencesService.lerCachePrevisao(cidade.id);
      if (json != null) previsoes[cidade.id] = PrevisaoClima.fromJson(json);
    }
    final data = await _preferencesService.lerDataCache();
    if (previsoes.isEmpty || data == null) return null;

    return ResultadoPrevisoes(
      previsoesPorCidade: previsoes,
      atualizadoEm: data,
      doCache: true,
    );
  }
}
