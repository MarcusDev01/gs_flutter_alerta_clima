import 'package:flutter/material.dart';


class ListaTopicos extends StatelessWidget {
  const ListaTopicos({super.key, required this.itens, this.numerada = false});

  final List<String> itens;
  final bool numerada;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < itens.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 28,
                  child: numerada
                      ? Text(
                          '${i + 1}.',
                          style: tema.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: tema.colorScheme.primary,
                          ),
                        )
                      : Icon(Icons.circle, size: 8, color: tema.colorScheme.primary),
                ),
                Expanded(child: Text(itens[i], style: tema.textTheme.bodyLarge)),
              ],
            ),
          ),
      ],
    );
  }
}
