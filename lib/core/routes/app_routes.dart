import 'package:flutter/material.dart';

import '../../models/cidade_monitorada.dart';
import '../../screens/busca_cidade/busca_cidade_screen.dart';
import '../../screens/cidade_detalhe/cidade_detalhe_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/splash/splash_screen.dart';


class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String detalheCidade = '/detalhe-cidade';
  static const String buscaCidade = '/busca-cidade';

  static Route<dynamic> gerarRota(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _rota(const SplashScreen(), settings);

      case onboarding:
        return _rota(const OnboardingScreen(), settings);

      case home:
        return _rota(const HomeScreen(), settings);

      case detalheCidade:
        
        final item = settings.arguments as CidadeMonitorada;
        return _rota(CidadeDetalheScreen(item: item), settings);

      case buscaCidade:
        return _rota(const BuscaCidadeScreen(), settings);

      default:
        return _rota(
          Scaffold(
            appBar: AppBar(title: const Text('Página não encontrada')),
            body: const Center(child: Text('Esta página não existe.')),
          ),
          settings,
        );
    }
  }

  static MaterialPageRoute<dynamic> _rota(Widget tela, RouteSettings settings) {
    return MaterialPageRoute<dynamic>(builder: (_) => tela, settings: settings);
  }
}
