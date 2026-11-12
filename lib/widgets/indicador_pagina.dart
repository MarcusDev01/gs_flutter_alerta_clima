import 'package:flutter/material.dart';


class IndicadorPagina extends StatelessWidget {
  const IndicadorPagina({
    super.key,
    required this.total,
    required this.paginaAtual,
  });

  final int total;
  final int paginaAtual;

  @override
  Widget build(BuildContext context) {
    final cor = Theme.of(context).colorScheme.primary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (indice) {
        final ativo = indice == paginaAtual;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: ativo ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: ativo ? cor : cor.withAlpha(60),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
