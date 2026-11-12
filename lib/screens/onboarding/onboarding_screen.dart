import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../models/onboarding_item.dart';
import '../../services/preferences_service.dart';
import '../../widgets/botao_principal.dart';
import '../../widgets/indicador_pagina.dart';
import '../../widgets/onboarding_pagina.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const List<OnboardingItem> _paginas = [
    OnboardingItem(
      icone: Icons.warning_amber_rounded,
      titulo: 'Saiba antes do risco',
      descricao:
          'Chuva forte, calor extremo, ar seco e ventania afetam milhões de pessoas. '
          'O Alerta Clima avisa com até 3 dias de antecedência.',
    ),
    OnboardingItem(
      icone: Icons.location_city_outlined,
      titulo: 'Acompanhe suas cidades',
      descricao:
          'Monitore onde você mora, trabalha ou onde vivem sua família e amigos. '
          'Fixe as mais importantes no topo da lista.',
    ),
    OnboardingItem(
      icone: Icons.health_and_safety_outlined,
      titulo: 'Saiba o que fazer',
      descricao:
          'Cada alerta vem com orientações simples de prevenção e os telefones de '
          'emergência. A última previsão fica salva para consulta sem internet.',
    ),
  ];

  final PageController _pageController = PageController();
  final PreferencesService _preferencesService = PreferencesService();

  int _paginaAtual = 0;
  bool _naoMostrarNovamente = false;

  bool get _ehUltimaPagina => _paginaAtual == _paginas.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _avancar() {
    if (_ehUltimaPagina) {
      _finalizar();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _voltar() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finalizar() async {
    await _preferencesService.salvarPreferenciaOnboarding(
      naoMostrarNovamente: _naoMostrarNovamente,
    );
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _finalizar,
                child: const Text('Pular'),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _paginas.length,
                onPageChanged: (pagina) => setState(() => _paginaAtual = pagina),
                itemBuilder: (context, indice) => OnboardingPagina(item: _paginas[indice]),
              ),
            ),
            IndicadorPagina(total: _paginas.length, paginaAtual: _paginaAtual),
            const SizedBox(height: 8),
            CheckboxListTile(
              value: _naoMostrarNovamente,
              onChanged: (valor) => setState(() => _naoMostrarNovamente = valor ?? false),
              title: const Text('Não mostrar novamente'),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: _paginaAtual == 0 ? null : _voltar,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Voltar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: BotaoPrincipal(
                      texto: _ehUltimaPagina ? 'Começar' : 'Avançar',
                      icone: _ehUltimaPagina ? Icons.check : Icons.arrow_forward,
                      onPressed: _avancar,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
