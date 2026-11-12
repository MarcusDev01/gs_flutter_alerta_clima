import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/alerta.dart';


class NivelBadge extends StatelessWidget {
  const NivelBadge({super.key, required this.nivel});

  final NivelAlerta? nivel;

  @override
  Widget build(BuildContext context) {
    final cor = nivel?.cor ?? AppColors.sucesso;
    final texto = nivel?.rotulo ?? 'Sem alerta';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cor.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            nivel == null ? Icons.check_circle_outline : Icons.warning_amber_rounded,
            size: 14,
            color: cor,
          ),
          const SizedBox(width: 4),
          Text(
            texto,
            style: TextStyle(color: cor, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
