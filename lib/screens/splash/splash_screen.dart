import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/app_routes.dart';
import '../../services/preferences_service.dart';
import '../../widgets/app_logo.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PreferencesService _preferencesService = PreferencesService();

  @override
  void initState() {
    super.initState();
    _decidirProximaTela();
  }

  Future<void> _decidirProximaTela() async {
    
    final resultados = await Future.wait<dynamic>([
      Future<void>.delayed(AppConstants.duracaoSplash),
      _preferencesService.deveExibirOnboarding(),
    ]);
    final exibirOnboarding = resultados[1] as bool;

    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(
      exibirOnboarding ? AppRoutes.onboarding : AppRoutes.home,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaria,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppLogo(tamanho: 140),
            const SizedBox(height: 24),
            Text(
              AppConstants.nomeApp,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              AppConstants.slogan,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 40),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
            ),
          ],
        ),
      ),
    );
  }
}
