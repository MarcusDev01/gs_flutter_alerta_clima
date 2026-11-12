import 'package:flutter/material.dart';


class OnboardingItem {
  const OnboardingItem({
    required this.icone,
    required this.titulo,
    required this.descricao,
  });

  final IconData icone;
  final String titulo;
  final String descricao;
}
