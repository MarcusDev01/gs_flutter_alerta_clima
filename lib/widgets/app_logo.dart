import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';


class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.tamanho = 120});

  final double tamanho;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppConstants.logoPath,
      width: tamanho,
      height: tamanho,
      semanticLabel: 'Logo do ${AppConstants.nomeApp}',
    );
  }
}
