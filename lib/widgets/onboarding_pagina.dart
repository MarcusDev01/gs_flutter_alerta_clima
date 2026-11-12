import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/onboarding_item.dart';


class OnboardingPagina extends StatelessWidget {
  const OnboardingPagina({super.key, required this.item});

  final OnboardingItem item;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: tema.colorScheme.primary.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icone, size: 96, color: tema.colorScheme.primary),
          ),
          const SizedBox(height: 40),
          Text(
            item.titulo,
            textAlign: TextAlign.center,
            style: tema.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.texto,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            item.descricao,
            textAlign: TextAlign.center,
            style: tema.textTheme.bodyLarge?.copyWith(
              color: AppColors.textoSecundario,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
