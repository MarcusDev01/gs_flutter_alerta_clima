import 'package:flutter/material.dart';

import 'core/constants/app_colors.dart';
import 'core/constants/app_constants.dart';
import 'core/routes/app_routes.dart';

class AlertaClimaApp extends StatelessWidget {
  const AlertaClimaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.nomeApp,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaria,
          primary: AppColors.primaria,
          secondary: AppColors.destaque,
        ),
        scaffoldBackgroundColor: AppColors.fundo,
      ),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.gerarRota,
    );
  }
}
