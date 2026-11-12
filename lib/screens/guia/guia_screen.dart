import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../models/alerta.dart';
import '../../widgets/info_linha.dart';
import '../../widgets/lista_topicos.dart';
import '../../widgets/secao_titulo.dart';


class GuiaScreen extends StatelessWidget {
  const GuiaScreen({super.key});

  static const List<String> _kitEmergencia = [
    'Água potável e alimentos que não estragam',
    'Lanterna, pilhas e carregador portátil',
    'Documentos e receitas em saco plástico',
    'Remédios de uso contínuo',
    'Rádio a pilha para ouvir avisos se faltar internet',
  ];

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Guia de prevenção')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Card(
            elevation: 0,
            color: AppColors.nivelGrandePerigo.withAlpha(20),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  InfoLinha(icone: Icons.shield_outlined, rotulo: 'Defesa Civil', valor: '199'),
                  InfoLinha(icone: Icons.local_fire_department_outlined, rotulo: 'Corpo de Bombeiros', valor: '193'),
                  InfoLinha(icone: Icons.medical_services_outlined, rotulo: 'SAMU', valor: '192'),
                  InfoLinha(
                    icone: Icons.sms_outlined,
                    rotulo: 'Alertas da Defesa Civil por SMS',
                    valor: 'Envie seu CEP para 40199',
                  ),
                ],
              ),
            ),
          ),
          const SecaoTitulo(icone: Icons.backpack_outlined, titulo: 'Kit de emergência'),
          const ListaTopicos(itens: _kitEmergencia),
          const SecaoTitulo(icone: Icons.menu_book_outlined, titulo: 'O que fazer em cada risco'),
          for (final tipo in TipoAlerta.values)
            Card(
              elevation: 0,
              color: Colors.white,
              clipBehavior: Clip.antiAlias,
              child: ExpansionTile(
                leading: Icon(tipo.icone, color: tema.colorScheme.primary),
                title: Text(tipo.rotulo, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(tipo.descricao),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [ListaTopicos(itens: tipo.recomendacoes)],
              ),
            ),
          const SizedBox(height: 16),
          Text(
            'Níveis de alerta usados no app',
            style: tema.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          for (final nivel in NivelAlerta.values)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(color: nivel.cor, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Text(nivel.rotulo),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
