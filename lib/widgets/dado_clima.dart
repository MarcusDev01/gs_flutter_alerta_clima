import 'package:flutter/material.dart';


class DadoClima extends StatelessWidget {
  const DadoClima({
    super.key,
    required this.icone,
    required this.valor,
    required this.rotulo,
  });

  final IconData icone;
  final String valor;
  final String rotulo;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Column(
      children: [
        Icon(icone, color: Colors.white70, size: 22),
        const SizedBox(height: 4),
        Text(
          valor,
          style: tema.textTheme.titleSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Text(rotulo, style: tema.textTheme.bodySmall?.copyWith(color: Colors.white70)),
      ],
    );
  }
}
