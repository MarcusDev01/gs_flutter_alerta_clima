import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/condicao_tempo.dart';
import '../../core/utils/formatters.dart';
import '../../models/cidade_monitorada.dart';
import '../../repositories/cidade_repository.dart';
import '../../widgets/alerta_card.dart';
import '../../widgets/dado_clima.dart';
import '../../widgets/previsao_dia_tile.dart';
import '../../widgets/secao_titulo.dart';


class CidadeDetalheScreen extends StatefulWidget {
  const CidadeDetalheScreen({super.key, required this.item});

  final CidadeMonitorada item;

  @override
  State<CidadeDetalheScreen> createState() => _CidadeDetalheScreenState();
}

class _CidadeDetalheScreenState extends State<CidadeDetalheScreen> {
  final CidadeRepository _repository = CidadeRepository();
  late bool _favorita = widget.item.favorita;

  Future<void> _alternarFavorita() async {
    final favorita = await _repository.alternarFavorita(widget.item.cidade);
    if (!mounted) return;
    setState(() => _favorita = favorita);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(favorita ? 'Cidade fixada no topo da lista' : 'Cidade desafixada'),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(item.cidade.nome),
        actions: [
          IconButton(
            tooltip: _favorita ? 'Desafixar cidade' : 'Fixar no topo',
            onPressed: _alternarFavorita,
            icon: Icon(
              _favorita ? Icons.star : Icons.star_border,
              color: _favorita ? AppColors.favorito : null,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          _construirCabecalho(tema),
          SecaoTitulo(
            icone: Icons.warning_amber_rounded,
            titulo: item.alertas.isEmpty
                ? 'Alertas'
                : 'Alertas (${item.alertas.length}) · toque para ver o que fazer',
          ),
          if (item.alertas.isEmpty)
            Card(
              elevation: 0,
              color: AppColors.sucesso.withAlpha(25),
              child: const ListTile(
                leading: Icon(Icons.verified_user_outlined, color: AppColors.sucesso),
                title: Text('Nenhum risco previsto para os próximos 3 dias'),
              ),
            )
          else
            for (var i = 0; i < item.alertas.length; i++)
              AlertaCard(alerta: item.alertas[i], iniciarAberto: i == 0),
          const SecaoTitulo(icone: Icons.calendar_month_outlined, titulo: 'Próximos 7 dias'),
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  for (var i = 0; i < item.previsao.dias.length; i++) ...[
                    PrevisaoDiaTile(dia: item.previsao.dias[i]),
                    if (i < item.previsao.dias.length - 1) const Divider(height: 1),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Dados: Open-Meteo. Em emergências, ligue para a Defesa Civil (199) ou Bombeiros (193).',
            textAlign: TextAlign.center,
            style: tema.textTheme.bodySmall?.copyWith(color: AppColors.textoSecundario),
          ),
        ],
      ),
    );
  }

  Widget _construirCabecalho(ThemeData tema) {
    final item = widget.item;
    final atual = item.previsao.atual;
    final corFundo = item.nivelMaximo?.cor ?? AppColors.primaria;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primariaEscura, corFundo],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.cidade.nomeCompleto,
            style: tema.textTheme.titleMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(CondicaoTempo.icone(atual.codigoTempo), size: 56, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                Formatters.temperatura(atual.temperatura),
                style: tema.textTheme.displayMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  CondicaoTempo.descricao(atual.codigoTempo),
                  style: tema.textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DadoClima(
                icone: Icons.thermostat,
                valor: Formatters.temperatura(atual.sensacaoTermica),
                rotulo: 'Sensação',
              ),
              DadoClima(
                icone: Icons.opacity,
                valor: '${atual.umidade.round()}%',
                rotulo: 'Umidade',
              ),
              DadoClima(
                icone: Icons.air,
                valor: '${atual.velocidadeVento.round()} km/h',
                rotulo: 'Vento',
              ),
              DadoClima(
                icone: Icons.water_drop_outlined,
                valor: Formatters.milimetros(atual.precipitacao),
                rotulo: 'Chuva agora',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
