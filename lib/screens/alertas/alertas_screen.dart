import 'package:flutter/material.dart';

import '../../controllers/cidades_controller.dart';
import '../../core/routes/app_routes.dart';
import '../../models/alerta.dart';
import '../../models/view_state.dart';
import '../../widgets/alerta_card.dart';
import '../../widgets/estado_carregando.dart';
import '../../widgets/estado_mensagem.dart';


class AlertasScreen extends StatefulWidget {
  const AlertasScreen({
    super.key,
    required this.controller,
    required this.onVerCidades,
  });

  final CidadesController controller;
  final VoidCallback onVerCidades;

  @override
  State<AlertasScreen> createState() => _AlertasScreenState();
}

class _AlertasScreenState extends State<AlertasScreen> {
  TipoAlerta? _tipoSelecionado;

  CidadesController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    if (_controller.estado != ViewState.sucesso) {
      _carregar();
    }
  }

  Future<void> _carregar() async {
    await _controller.carregar();
    if (!mounted) return;
    setState(() {});
  }

  void _selecionarTipo(TipoAlerta tipo) {
    setState(() => _tipoSelecionado = _tipoSelecionado == tipo ? null : tipo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alertas ativos')),
      body: switch (_controller.estado) {
        ViewState.inicial || ViewState.carregando => const EstadoCarregando(),
        ViewState.erro => EstadoMensagem.erro(
            mensagem: _controller.mensagemErro ?? 'Erro desconhecido.',
            onPressed: () {
              setState(() => _controller.estado = ViewState.carregando);
              _carregar();
            },
          ),
        ViewState.sucesso => _construirLista(),
      },
    );
  }

  Widget _construirLista() {
    final alertas = _controller.alertas(tipo: _tipoSelecionado);

    return Column(
      children: [
        SizedBox(
          height: 52,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            children: [
              for (final tipo in TipoAlerta.values)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    avatar: Icon(tipo.icone, size: 18),
                    label: Text(tipo.rotulo),
                    selected: _tipoSelecionado == tipo,
                    onSelected: (_) => _selecionarTipo(tipo),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: alertas.isEmpty
              ? EstadoMensagem(
                  icone: Icons.verified_user_outlined,
                  corIcone: Colors.green,
                  titulo: 'Nenhum alerta ativo',
                  mensagem: _tipoSelecionado == null
                      ? 'Não há riscos previstos para os próximos dias nas suas cidades.'
                      : 'Nenhum alerta de "${_tipoSelecionado!.rotulo}" no momento.',
                  textoBotao: 'Ver cidades',
                  onPressed: widget.onVerCidades,
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  itemCount: alertas.length,
                  itemBuilder: (context, indice) {
                    final item = alertas[indice];
                    return AlertaCard(
                      key: ValueKey('${item.cidade.cidade.id}-${item.alerta.tipo.name}'),
                      alerta: item.alerta,
                      nomeCidade: item.cidade.cidade.nomeCompleto,
                      onTapCidade: () => Navigator.of(context).pushNamed(
                        AppRoutes.detalheCidade,
                        arguments: item.cidade,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
