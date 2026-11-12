import 'package:flutter/material.dart';

import '../../controllers/cidades_controller.dart';
import '../../models/view_state.dart';
import '../alertas/alertas_screen.dart';
import '../cidades/cidades_screen.dart';
import '../guia/guia_screen.dart';
import '../sobre/sobre_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  final CidadesController _cidadesController = CidadesController();

  int _abaAtual = 0;

  void _irParaAba(int indice) => setState(() => _abaAtual = indice);

  Widget _construirAba() {
    switch (_abaAtual) {
      case 1:
        return AlertasScreen(
          controller: _cidadesController,
          onVerCidades: () => _irParaAba(0),
        );
      case 2:
        return const GuiaScreen();
      case 3:
        return const SobreScreen();
      case 0:
      default:
        return CidadesScreen(
          controller: _cidadesController,
          onDadosAtualizados: () => setState(() {}),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalAlertas =
        _cidadesController.estado == ViewState.sucesso ? _cidadesController.totalAlertas : 0;

    return Scaffold(
      body: _construirAba(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _abaAtual,
        onDestinationSelected: _irParaAba,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.location_city_outlined),
            selectedIcon: Icon(Icons.location_city),
            label: 'Cidades',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: totalAlertas > 0,
              label: Text('$totalAlertas'),
              child: const Icon(Icons.notifications_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: totalAlertas > 0,
              label: Text('$totalAlertas'),
              child: const Icon(Icons.notifications),
            ),
            label: 'Alertas',
          ),
          const NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Guia',
          ),
          const NavigationDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info),
            label: 'Sobre',
          ),
        ],
      ),
    );
  }
}
