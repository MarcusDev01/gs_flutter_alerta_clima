import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/utils/condicao_tempo.dart';
import '../core/utils/formatters.dart';
import '../models/cidade_monitorada.dart';
import 'nivel_badge.dart';


class CidadeCard extends StatelessWidget {
  const CidadeCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onFavoritar,
  });

  final CidadeMonitorada item;
  final VoidCallback onTap;
  final VoidCallback onFavoritar;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final atual = item.previsao.atual;
    final corBorda = item.nivelMaximo?.cor ?? Colors.grey.shade200;

    return Card(
      elevation: 0,
      color: AppColors.superficie,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: corBorda, width: item.nivelMaximo == null ? 1 : 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 4, 14),
          child: Row(
            children: [
              Icon(CondicaoTempo.icone(atual.codigoTempo), size: 40, color: tema.colorScheme.primary),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.cidade.nome,
                      style: tema.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      CondicaoTempo.descricao(atual.codigoTempo),
                      style: tema.textTheme.bodySmall?.copyWith(color: AppColors.textoSecundario),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        NivelBadge(nivel: item.nivelMaximo),
                        if (item.alertas.length > 1) ...[
                          const SizedBox(width: 6),
                          Text(
                            '+${item.alertas.length - 1}',
                            style: tema.textTheme.labelMedium,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                Formatters.temperatura(atual.temperatura),
                style: tema.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w300),
              ),
              IconButton(
                tooltip: item.favorita ? 'Desafixar cidade' : 'Fixar no topo',
                onPressed: onFavoritar,
                icon: Icon(
                  item.favorita ? Icons.star : Icons.star_border,
                  color: item.favorita ? AppColors.favorito : AppColors.textoSecundario,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
