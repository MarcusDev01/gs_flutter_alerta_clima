import 'package:flutter/material.dart';


class CondicaoTempo {
  CondicaoTempo._();

  static String descricao(int codigo) {
    if (codigo == 0) return 'Céu limpo';
    if (codigo <= 2) return 'Parcialmente nublado';
    if (codigo == 3) return 'Nublado';
    if (codigo == 45 || codigo == 48) return 'Nevoeiro';
    if (codigo >= 51 && codigo <= 57) return 'Garoa';
    if (codigo >= 61 && codigo <= 67) return 'Chuva';
    if (codigo >= 71 && codigo <= 77) return 'Neve';
    if (codigo >= 80 && codigo <= 82) return 'Pancadas de chuva';
    if (codigo >= 85 && codigo <= 86) return 'Pancadas de neve';
    if (codigo >= 95) return 'Tempestade com raios';
    return 'Indefinido';
  }

  static IconData icone(int codigo) {
    if (codigo == 0) return Icons.wb_sunny_outlined;
    if (codigo <= 2) return Icons.wb_cloudy_outlined;
    if (codigo == 3) return Icons.cloud_outlined;
    if (codigo == 45 || codigo == 48) return Icons.blur_on;
    if (codigo >= 51 && codigo <= 67) return Icons.grain;
    if (codigo >= 71 && codigo <= 77) return Icons.ac_unit;
    if (codigo >= 80 && codigo <= 86) return Icons.water_drop_outlined;
    if (codigo >= 95) return Icons.flash_on;
    return Icons.help_outline;
  }
}
