import 'package:flutter/material.dart';


class SecaoTitulo extends StatelessWidget {
  const SecaoTitulo({super.key, required this.icone, required this.titulo});

  final IconData icone;
  final String titulo;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Row(
        children: [
          Icon(icone, size: 22, color: tema.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              titulo,
              style: tema.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
