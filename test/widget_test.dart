import 'package:alerta_clima/core/utils/formatters.dart';
import 'package:alerta_clima/models/cidade.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formatadores', () {
    expect(Formatters.temperatura(27.6), '28°');
    expect(Formatters.milimetros(12.26), '12,3 mm');
    final hoje = DateTime(2026, 11, 12);
    expect(Formatters.diaRelativo(DateTime(2026, 11, 13), referencia: hoje), 'Amanhã');
  });

  test('Cidade converte o JSON de geocodificação', () {
    final cidade = Cidade.fromGeocodingJson({
      'name': 'Recife',
      'admin1': 'Pernambuco',
      'latitude': -8.05,
      'longitude': -34.88,
    });
    expect(cidade.nomeCompleto, 'Recife, Pernambuco');
  });
}
