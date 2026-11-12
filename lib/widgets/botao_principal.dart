import 'package:flutter/material.dart';


class BotaoPrincipal extends StatelessWidget {
  const BotaoPrincipal({
    super.key,
    required this.texto,
    required this.onPressed,
    this.icone,
  });

  final String texto;
  final VoidCallback? onPressed;
  final IconData? icone;

  @override
  Widget build(BuildContext context) {
    final estilo = ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(52),
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    );

    if (icone == null) {
      return ElevatedButton(onPressed: onPressed, style: estilo, child: Text(texto));
    }
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: estilo,
      icon: Icon(icone),
      label: Text(texto),
    );
  }
}
