import 'package:flutter/material.dart';

import '../../controllers/busca_cidade_controller.dart';
import '../../models/cidade.dart';
import '../../models/view_state.dart';
import '../../widgets/estado_carregando.dart';
import '../../widgets/estado_mensagem.dart';


class BuscaCidadeScreen extends StatefulWidget {
  const BuscaCidadeScreen({super.key});

  @override
  State<BuscaCidadeScreen> createState() => _BuscaCidadeScreenState();
}

class _BuscaCidadeScreenState extends State<BuscaCidadeScreen> {
  final BuscaCidadeController _controller = BuscaCidadeController();
  final TextEditingController _textoController = TextEditingController();

  @override
  void dispose() {
    _textoController.dispose();
    super.dispose();
  }

  Future<void> _buscar() async {
    FocusScope.of(context).unfocus();
    final termo = _textoController.text;

    if (!_controller.termoValido(termo)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite pelo menos 3 letras do nome da cidade.')),
      );
      return;
    }

    setState(() => _controller.iniciarBusca(termo));
    await _controller.buscar();
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _adicionar(Cidade cidade) async {
    final adicionou = await _controller.adicionar(cidade);
    if (!mounted) return;

    if (!adicionou) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${cidade.nome} já está na sua lista.')),
      );
      return;
    }
    
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar cidade')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textoController,
                    autofocus: true,
                    textInputAction: TextInputAction.search,
                    textCapitalization: TextCapitalization.words,
                    onSubmitted: (_) => _buscar(),
                    decoration: InputDecoration(
                      labelText: 'Nome da cidade',
                      hintText: 'Ex.: Petrópolis',
                      prefixIcon: const Icon(Icons.location_city_outlined),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _controller.estado == ViewState.carregando ? null : _buscar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Icon(Icons.search),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _construirConteudo()),
        ],
      ),
    );
  }

  Widget _construirConteudo() {
    switch (_controller.estado) {
      case ViewState.inicial:
        return const EstadoMensagem(
          icone: Icons.travel_explore,
          titulo: 'Busque uma cidade brasileira',
          mensagem: 'Adicione onde você mora, trabalha ou onde vivem pessoas queridas.',
        );

      case ViewState.carregando:
        return const EstadoCarregando(mensagem: 'Procurando cidades...');

      case ViewState.erro:
        return EstadoMensagem.erro(
          mensagem: _controller.mensagemErro ?? 'Erro desconhecido.',
          onPressed: _buscar,
        );

      case ViewState.sucesso:
        if (_controller.resultados.isEmpty) {
          return const EstadoMensagem(
            icone: Icons.search_off,
            titulo: 'Nenhuma cidade encontrada',
            mensagem: 'Confira a grafia e tente novamente.',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          itemCount: _controller.resultados.length,
          itemBuilder: (context, indice) {
            final cidade = _controller.resultados[indice];
            return Card(
              elevation: 0,
              color: Colors.white,
              child: ListTile(
                leading: const Icon(Icons.place_outlined),
                title: Text(cidade.nome),
                subtitle: Text(cidade.estado.isEmpty ? 'Brasil' : cidade.estado),
                trailing: IconButton(
                  tooltip: 'Adicionar',
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => _adicionar(cidade),
                ),
                onTap: () => _adicionar(cidade),
              ),
            );
          },
        );
    }
  }
}
