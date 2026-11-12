import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/utils/condicao_tempo.dart';
import '../core/utils/formatters.dart';
import '../models/previsao_clima.dart';


class PrevisaoDiaTile extends StatelessWidget {
  const PrevisaoDiaTile({super.key, required this.dia});

  final PrevisaoDiaria dia;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Formatters.diaRelativo(dia.data),
                  style: tema.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(Formatters.diaMes(dia.data), style: tema.textTheme.bodySmall),
              ],
            ),
          ),
          Icon(CondicaoTempo.icone(dia.codigoTempo), color: tema.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.water_drop_outlined, size: 16, color: AppColors.primaria),
                const SizedBox(width: 2),
                Flexible(
                  child: Text(
                    '${dia.probabilidadeChuva}% · ${Formatters.milimetros(dia.chuvaMilimetros)}',
                    style: tema.textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Text(
            Formatters.temperatura(dia.temperaturaMinima),
            style: tema.textTheme.bodyLarge?.copyWith(color: AppColors.textoSecundario),
          ),
          const SizedBox(width: 8),
          Text(
            Formatters.temperatura(dia.temperaturaMaxima),
            style: tema.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
