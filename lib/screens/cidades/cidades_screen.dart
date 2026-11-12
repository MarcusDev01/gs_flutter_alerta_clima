import 'package:flutter/material.dart';

import '../../controllers/cidades_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/formatters.dart';
import '../../models/cidade_monitorada.dart';
import '../../models/view_state.dart';
import '../../widgets/cidade_card.dart';
import '../../widgets/estado_carregando.dart';
import '../../widgets/estado_mensagem.dart';


class CidadesScreen extends StatefulWidget {
  const CidadesScreen({
    super.key,
    required this.controller,
    required this.onDadosAtualizados,
  });

  final CidadesController controller;

  
  final VoidCallback onDadosAtualizados;

  @override
  State<CidadesScreen> createState() => _CidadesScreenState();
}

class _CidadesScreenState extends State<CidadesScreen> {
  late final TextEditingController _buscaController;

  CidadesController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _buscaController = TextEditingController(text: _controller.termoBusca);
    if (_controller.estado == ViewState.inicial) {
      _atualizar();
    }
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  
  Future<void> _carregar() async {
    setState(() => _controller.estado = ViewState.carregando);
    await _atualizar();
  }

  
  Future<void> _atualizar() async {
    await _controller.carregar();
    if (!mounted) return;
    setState(() {});
    widget.onDadosAtualizados();
  }

  Future<void> _abrirDetalhe(CidadeMonitorada item) async {
    
    await Navigator.of(context).pushNamed(AppRoutes.detalheCidade, arguments: item);
    
    await _controller.recarregarFavoritas();
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _adicionarCidade() async {
    
    final adicionou = await Navigator.of(context).pushNamed(AppRoutes.buscaCidade);
    if (adicionou == true) {
      await _carregar();
    }
  }

  Future<void> _alternarFavorita(CidadeMonitorada item) async {
    await _controller.alternarFavorita(item.cidade);
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _remover(CidadeMonitorada item) async {
    final posicao = await _controller.removerCidade(item.cidade);
    if (!mounted) return;
    setState(() {});
    widget.onDadosAtualizados();

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${item.cidade.nome} removida'),
          action: SnackBarAction(
            label: 'Desfazer',
            onPressed: () async {
              await _controller.desfazerRemocao(item.cidade, posicao);
              if (!mounted) return;
              setState(() {});
              widget.onDadosAtualizados();
            },
          ),
        ),
      );
  }

  void _limparFiltros() {
    _buscaController.clear();
    setState(_controller.limparFiltros);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas cidades'),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            icon: const Icon(Icons.refresh),
            onPressed: _controller.estado == ViewState.carregando ? null : _carregar,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _adicionarCidade,
        icon: const Icon(Icons.add_location_alt_outlined),
        label: const Text('Adicionar cidade'),
      ),
      body: Column(
        children: [
          _construirBusca(),
          if (_controller.estado == ViewState.sucesso) _construirFiltros(),
          if (_controller.estado == ViewState.sucesso) _construirAvisoAtualizacao(),
          Expanded(child: _construirConteudo()),
        ],
      ),
    );
  }

  Widget _construirBusca() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: TextField(
        controller: _buscaController,
        textInputAction: TextInputAction.search,
        onChanged: (texto) => setState(() => _controller.buscar(texto)),
        decoration: InputDecoration(
          hintText: 'Filtrar cidades',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _controller.termoBusca.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Limpar busca',
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _buscaController.clear();
                    setState(() => _controller.buscar(''));
                  },
                ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _construirFiltros() {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          for (final filtro in FiltroRisco.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(filtro.rotulo),
                selected: _controller.filtro == filtro,
                onSelected: (_) => setState(() => _controller.selecionarFiltro(filtro)),
              ),
            ),
        ],
      ),
    );
  }

  
  Widget _construirAvisoAtualizacao() {
    final data = _controller.atualizadoEm;
    if (data == null) return const SizedBox.shrink();
    final offline = _controller.dadosOffline;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: offline ? AppColors.nivelAtencao.withAlpha(40) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            offline ? Icons.cloud_off : Icons.update,
            size: 16,
            color: AppColors.textoSecundario,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              offline
                  ? 'Sem internet. Mostrando a previsão salva em '
                      '${Formatters.diaMes(data)} às ${Formatters.hora(data)}.'
                  : 'Atualizado às ${Formatters.hora(data)} · arraste para baixo para atualizar',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirConteudo() {
    switch (_controller.estado) {
      case ViewState.inicial:
      case ViewState.carregando:
        return const EstadoCarregando(mensagem: 'Buscando a previsão do tempo...');

      case ViewState.erro:
        return EstadoMensagem.erro(
          mensagem: _controller.mensagemErro ?? 'Erro desconhecido.',
          onPressed: _carregar,
        );

      case ViewState.sucesso:
        if (_controller.todasCidades.isEmpty) {
          return EstadoMensagem(
            icone: Icons.add_location_alt_outlined,
            titulo: 'Nenhuma cidade monitorada',
            mensagem: 'Adicione a cidade onde você mora para receber alertas.',
            textoBotao: 'Adicionar cidade',
            iconeBotao: Icons.add,
            onPressed: _adicionarCidade,
          );
        }

        final cidades = _controller.cidadesFiltradas;
        if (cidades.isEmpty) {
          return EstadoMensagem(
            icone: Icons.search_off,
            titulo: 'Nenhuma cidade encontrada',
            mensagem: 'Tente outro nome ou remova os filtros.',
            textoBotao: 'Limpar filtros',
            iconeBotao: Icons.clear_all,
            onPressed: _limparFiltros,
          );
        }

        return RefreshIndicator(
          onRefresh: _atualizar,
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 4, bottom: 96),
            itemCount: cidades.length,
            itemBuilder: (context, indice) {
              final item = cidades[indice];
              return Dismissible(
                key: ValueKey(item.cidade.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  color: AppColors.nivelGrandePerigo,
                  child: const Icon(Icons.delete_outline, color: Colors.white),
                ),
                onDismissed: (_) => _remover(item),
                child: CidadeCard(
                  item: item,
                  onTap: () => _abrirDetalhe(item),
                  onFavoritar: () => _alternarFavorita(item),
                ),
              );
            },
          ),
        );
    }
  }
}
