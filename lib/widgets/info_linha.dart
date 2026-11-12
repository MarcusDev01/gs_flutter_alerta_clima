import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';


class InfoLinha extends StatelessWidget {
  const InfoLinha({
    super.key,
    required this.icone,
    required this.rotulo,
    required this.valor,
  });

  final IconData icone;
  final String rotulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, size: 20, color: tema.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rotulo,
                  style: tema.textTheme.labelMedium?.copyWith(color: AppColors.textoSecundario),
                ),
                const SizedBox(height: 2),
                Text(valor.isEmpty ? '—' : valor, style: tema.textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
