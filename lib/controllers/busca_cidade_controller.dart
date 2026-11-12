import '../models/cidade.dart';
import '../models/view_state.dart';
import '../repositories/cidade_repository.dart';
import '../services/api_exception.dart';
import '../services/geocoding_service.dart';


class BuscaCidadeController {
  BuscaCidadeController({
    GeocodingService? geocodingService,
    CidadeRepository? cidadeRepository,
  })  : _geocodingService = geocodingService ?? GeocodingService(),
        _cidadeRepository = cidadeRepository ?? CidadeRepository();

  final GeocodingService _geocodingService;
  final CidadeRepository _cidadeRepository;

  ViewState estado = ViewState.inicial;
  List<Cidade> resultados = [];
  String? mensagemErro;
  String _ultimoTermo = '';

  bool termoValido(String termo) => termo.trim().length >= 3;

  
  void iniciarBusca(String termo) {
    _ultimoTermo = termo.trim();
    estado = ViewState.carregando;
    mensagemErro = null;
  }

  Future<void> buscar() async {
    try {
      resultados = await _geocodingService.buscarCidades(_ultimoTermo);
      estado = ViewState.sucesso;
    } on ApiException catch (erro) {
      mensagemErro = erro.mensagem;
      estado = ViewState.erro;
    } catch (_) {
      mensagemErro = 'Algo deu errado. Tente novamente.';
      estado = ViewState.erro;
    }
  }

  
  Future<bool> adicionar(Cidade cidade) => _cidadeRepository.adicionarCidade(cidade);
}
