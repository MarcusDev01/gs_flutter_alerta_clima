import '../models/alerta.dart';
import '../models/cidade.dart';
import '../models/cidade_monitorada.dart';
import '../models/view_state.dart';
import '../repositories/cidade_repository.dart';
import '../repositories/clima_repository.dart';
import '../services/analise_risco_service.dart';
import '../services/api_exception.dart';


class AlertaDaCidade {
  const AlertaDaCidade({required this.cidade, required this.alerta});

  final CidadeMonitorada cidade;
  final Alerta alerta;
}


enum FiltroRisco {
  todas('Todas'),
  comAlerta('Com alerta'),
  perigo('Perigo ou mais'),
  semAlerta('Sem alerta');

  const FiltroRisco(this.rotulo);

  final String rotulo;
}




class CidadesController {
  CidadesController({
    CidadeRepository? cidadeRepository,
    ClimaRepository? climaRepository,
    AnaliseRiscoService? analiseRiscoService,
  })  : _cidadeRepository = cidadeRepository ?? CidadeRepository(),
        _climaRepository = climaRepository ?? ClimaRepository(),
        _analiseRisco = analiseRiscoService ?? const AnaliseRiscoService();

  final CidadeRepository _cidadeRepository;
  final ClimaRepository _climaRepository;
  final AnaliseRiscoService _analiseRisco;

  ViewState estado = ViewState.inicial;
  String? mensagemErro;
  bool dadosOffline = false;
  DateTime? atualizadoEm;

  List<CidadeMonitorada> _cidades = [];

  String termoBusca = '';
  FiltroRisco filtro = FiltroRisco.todas;

  List<CidadeMonitorada> get todasCidades => _cidades;

  
  List<CidadeMonitorada> get cidadesFiltradas {
    final busca = termoBusca.trim().toLowerCase();
    final lista = _cidades.where((item) {
      final nomeOk = busca.isEmpty || item.cidade.nomeCompleto.toLowerCase().contains(busca);
      return nomeOk && _passaNoFiltro(item);
    }).toList();

    return [
      ...lista.where((item) => item.favorita),
      ...lista.where((item) => !item.favorita),
    ];
  }

  bool _passaNoFiltro(CidadeMonitorada item) {
    switch (filtro) {
      case FiltroRisco.todas:
        return true;
      case FiltroRisco.comAlerta:
        return item.alertas.isNotEmpty;
      case FiltroRisco.perigo:
        final nivel = item.nivelMaximo;
        return nivel != null && nivel.peso >= NivelAlerta.perigo.peso;
      case FiltroRisco.semAlerta:
        return item.alertas.isEmpty;
    }
  }

  
  List<AlertaDaCidade> alertas({TipoAlerta? tipo}) {
    final lista = <AlertaDaCidade>[
      for (final cidade in _cidades)
        for (final alerta in cidade.alertas)
          if (tipo == null || alerta.tipo == tipo) AlertaDaCidade(cidade: cidade, alerta: alerta),
    ];
    lista.sort((a, b) => b.alerta.nivel.peso.compareTo(a.alerta.nivel.peso));
    return lista;
  }

  int get totalAlertas => alertas().length;

  Future<void> carregar() async {
    estado = ViewState.carregando;
    mensagemErro = null;
    try {
      final cidades = await _cidadeRepository.buscarCidades();
      final favoritas = await _cidadeRepository.buscarFavoritas();
      final resultado = await _climaRepository.buscarPrevisoes(cidades);

      _cidades = [
        for (final cidade in cidades)
          if (resultado.previsoesPorCidade[cidade.id] != null)
            CidadeMonitorada(
              cidade: cidade,
              previsao: resultado.previsoesPorCidade[cidade.id]!,
              alertas: _analiseRisco.analisar(resultado.previsoesPorCidade[cidade.id]!),
              favorita: favoritas.contains(cidade.id),
            ),
      ];
      dadosOffline = resultado.doCache;
      atualizadoEm = resultado.atualizadoEm;
      estado = ViewState.sucesso;
    } on ApiException catch (erro) {
      mensagemErro = erro.mensagem;
      estado = ViewState.erro;
    } catch (_) {
      mensagemErro = 'Algo deu errado ao carregar a previsão.';
      estado = ViewState.erro;
    }
  }

  
  Future<void> recarregarFavoritas() async {
    final favoritas = await _cidadeRepository.buscarFavoritas();
    _cidades = _cidades
        .map((item) => CidadeMonitorada(
              cidade: item.cidade,
              previsao: item.previsao,
              alertas: item.alertas,
              favorita: favoritas.contains(item.cidade.id),
            ))
        .toList();
  }

  Future<void> alternarFavorita(Cidade cidade) async {
    await _cidadeRepository.alternarFavorita(cidade);
    await recarregarFavoritas();
  }

  
  Future<int> removerCidade(Cidade cidade) async {
    final posicao = _cidades.indexWhere((item) => item.cidade.id == cidade.id);
    
    _cidades.removeWhere((item) => item.cidade.id == cidade.id);
    await _cidadeRepository.removerCidade(cidade);
    return posicao;
  }

  Future<void> desfazerRemocao(Cidade cidade, int posicao) async {
    await _cidadeRepository.restaurarCidade(cidade, posicao);
    await carregar();
  }

  void buscar(String termo) => termoBusca = termo;

  void selecionarFiltro(FiltroRisco novoFiltro) => filtro = novoFiltro;

  void limparFiltros() {
    termoBusca = '';
    filtro = FiltroRisco.todas;
  }
}
