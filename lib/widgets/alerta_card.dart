import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/utils/formatters.dart';
import '../models/alerta.dart';
import 'lista_topicos.dart';


class AlertaCard extends StatefulWidget {
  const AlertaCard({
    super.key,
    required this.alerta,
    this.nomeCidade,
    this.onTapCidade,
    this.iniciarAberto = false,
  });

  final Alerta alerta;

  
  final String? nomeCidade;
  final VoidCallback? onTapCidade;
  final bool iniciarAberto;

  @override
  State<AlertaCard> createState() => _AlertaCardState();
}

class _AlertaCardState extends State<AlertaCard> {
  late bool _aberto = widget.iniciarAberto;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final alerta = widget.alerta;
    final cor = alerta.nivel.cor;

    return Card(
      elevation: 0,
      color: AppColors.superficie,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: cor, width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => setState(() => _aberto = !_aberto),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: cor.withAlpha(30),
              padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
              child: Row(
                children: [
                  Icon(alerta.tipo.icone, color: cor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${alerta.nivel.rotulo}: ${alerta.tipo.rotulo}',
                          style: tema.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.texto,
                          ),
                        ),
                        Text(
                          '${Formatters.diaRelativo(alerta.data)} (${Formatters.diaMes(alerta.data)}) · ${alerta.detalhe}',
                          style: tema.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Icon(_aberto ? Icons.expand_less : Icons.expand_more),
                ],
              ),
            ),
            if (widget.nomeCidade != null)
              ListTile(
                dense: true,
                leading: const Icon(Icons.location_city_outlined),
                title: Text(widget.nomeCidade!),
                trailing: widget.onTapCidade == null ? null : const Icon(Icons.chevron_right),
                onTap: widget.onTapCidade,
              ),
            if (_aberto)
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(alerta.tipo.descricao, style: tema.textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    Text(
                      'O que fazer:',
                      style: tema.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    ListaTopicos(itens: alerta.tipo.recomendacoes),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
