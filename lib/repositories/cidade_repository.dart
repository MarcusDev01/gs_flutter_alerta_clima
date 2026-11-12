import '../core/constants/app_constants.dart';
import '../models/cidade.dart';
import '../services/preferences_service.dart';


class CidadeRepository {
  CidadeRepository({PreferencesService? preferencesService})
      : _preferencesService = preferencesService ?? PreferencesService();

  final PreferencesService _preferencesService;

  Future<List<Cidade>> buscarCidades() async {
    final salvas = await _preferencesService.lerCidades();
    
    return salvas ?? List<Cidade>.of(AppConstants.cidadesPadrao);
  }

  
  Future<bool> adicionarCidade(Cidade cidade) async {
    final cidades = await buscarCidades();
    if (cidades.any((c) => c.id == cidade.id)) return false;
    cidades.add(cidade);
    await _preferencesService.salvarCidades(cidades);
    return true;
  }

  Future<void> removerCidade(Cidade cidade) async {
    final cidades = await buscarCidades();
    cidades.removeWhere((c) => c.id == cidade.id);
    await _preferencesService.salvarCidades(cidades);

    final favoritas = await buscarFavoritas();
    if (favoritas.remove(cidade.id)) {
      await _preferencesService.salvarFavoritas(favoritas);
    }
  }

  
  Future<void> restaurarCidade(Cidade cidade, int posicao) async {
    final cidades = await buscarCidades();
    if (cidades.any((c) => c.id == cidade.id)) return;
    final indice = posicao > cidades.length ? cidades.length : (posicao < 0 ? 0 : posicao);
    cidades.insert(indice, cidade);
    await _preferencesService.salvarCidades(cidades);
  }

  Future<Set<String>> buscarFavoritas() => _preferencesService.lerFavoritas();

  Future<bool> isFavorita(Cidade cidade) async {
    final favoritas = await buscarFavoritas();
    return favoritas.contains(cidade.id);
  }

  
  Future<bool> alternarFavorita(Cidade cidade) async {
    final favoritas = await buscarFavoritas();
    final agoraFavorita = !favoritas.contains(cidade.id);
    if (agoraFavorita) {
      favoritas.add(cidade.id);
    } else {
      favoritas.remove(cidade.id);
    }
    await _preferencesService.salvarFavoritas(favoritas);
    return agoraFavorita;
  }
}
