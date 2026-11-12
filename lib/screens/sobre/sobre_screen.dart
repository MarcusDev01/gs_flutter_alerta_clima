import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/app_routes.dart';
import '../../services/preferences_service.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/info_linha.dart';
import '../../widgets/secao_titulo.dart';


class SobreScreen extends StatelessWidget {
  const SobreScreen({super.key});

  static const List<_Ods> _ods = [
    _Ods(numero: 3, titulo: 'Saúde e bem-estar', cor: Color(0xFF4C9F38)),
    _Ods(numero: 11, titulo: 'Cidades e comunidades sustentáveis', cor: Color(0xFFFD9D24)),
    _Ods(numero: 13, titulo: 'Ação contra a mudança global do clima', cor: Color(0xFF3F7E44)),
  ];

  Future<void> _reverIntroducao(BuildContext context) async {
    await PreferencesService().salvarPreferenciaOnboarding(naoMostrarNovamente: false);
    if (!context.mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.onboarding, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre o projeto')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          const Center(child: AppLogo(tamanho: 96)),
          const SizedBox(height: 12),
          Text(
            AppConstants.nomeApp,
            textAlign: TextAlign.center,
            style: tema.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            AppConstants.slogan,
            textAlign: TextAlign.center,
            style: tema.textTheme.bodyMedium?.copyWith(color: AppColors.textoSecundario),
          ),
          const SecaoTitulo(icone: Icons.lightbulb_outline, titulo: 'O problema'),
          Text(
            'Enchentes, deslizamentos e ondas de calor estão cada vez mais frequentes. '
            'Quem mora em área de risco, idosos e trabalhadores ao ar livre muitas vezes '
            'só descobrem o perigo quando ele já chegou. O Alerta Clima transforma a '
            'previsão do tempo em avisos claros, com antecedência e com orientações do que fazer.',
            style: tema.textTheme.bodyLarge?.copyWith(height: 1.4),
          ),
          const SecaoTitulo(icone: Icons.public, titulo: 'ODS da ONU relacionados'),
          ..._ods.map((ods) => _OdsTile(ods: ods)),
          const SecaoTitulo(icone: Icons.code, titulo: 'Desenvolvedores'),
          Card(
            elevation: 0,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  for (final dev in AppConstants.desenvolvedores)
                    InfoLinha(
                      icone: Icons.person_outline,
                      rotulo: dev['rm'] ?? '',
                      valor: dev['nome'] ?? '',
                    ),
                ],
              ),
            ),
          ),
          const SecaoTitulo(icone: Icons.settings_outlined, titulo: 'Configurações'),
          OutlinedButton.icon(
            onPressed: () => _reverIntroducao(context),
            icon: const Icon(Icons.replay),
            label: const Text('Rever a introdução'),
          ),
          const SizedBox(height: 16),
          Text(
            'Previsões: Open-Meteo (open-meteo.com). Os alertas são uma orientação e não '
            'substituem os avisos oficiais da Defesa Civil.',
            textAlign: TextAlign.center,
            style: tema.textTheme.bodySmall?.copyWith(color: AppColors.textoSecundario),
          ),
        ],
      ),
    );
  }
}

class _Ods {
  const _Ods({required this.numero, required this.titulo, required this.cor});

  final int numero;
  final String titulo;
  final Color cor;
}

class _OdsTile extends StatelessWidget {
  const _OdsTile({required this.ods});

  final _Ods ods;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: ods.cor,
          foregroundColor: Colors.white,
          child: Text('${ods.numero}', style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        title: Text(ods.titulo),
      ),
    );
  }
}
