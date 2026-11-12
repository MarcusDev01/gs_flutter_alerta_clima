import 'package:flutter/material.dart';


class EstadoMensagem extends StatelessWidget {
  const EstadoMensagem({
    super.key,
    required this.icone,
    required this.titulo,
    required this.mensagem,
    this.textoBotao,
    this.onPressed,
    this.corIcone,
    this.iconeBotao = Icons.arrow_forward,
  });

  
  const EstadoMensagem.erro({
    super.key,
    required this.mensagem,
    required this.onPressed,
    this.titulo = 'Ops, algo deu errado',
  })  : icone = Icons.wifi_off_rounded,
        textoBotao = 'Tentar novamente',
        corIcone = Colors.redAccent,
        iconeBotao = Icons.refresh;

  final IconData icone;
  final String titulo;
  final String mensagem;
  final String? textoBotao;
  final VoidCallback? onPressed;
  final Color? corIcone;
  final IconData iconeBotao;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, size: 72, color: corIcone ?? tema.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: tema.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: tema.textTheme.bodyMedium,
            ),
            if (textoBotao != null && onPressed != null) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: onPressed,
                icon: Icon(iconeBotao),
                label: Text(textoBotao!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
