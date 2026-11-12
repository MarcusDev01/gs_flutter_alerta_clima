
class Cidade {
  const Cidade({
    required this.nome,
    required this.estado,
    required this.latitude,
    required this.longitude,
  });

  final String nome;
  final String estado;
  final double latitude;
  final double longitude;

  
  String get id => '${latitude.toStringAsFixed(2)},${longitude.toStringAsFixed(2)}';

  String get nomeCompleto => estado.isEmpty ? nome : '$nome, $estado';

  
  
  factory Cidade.fromGeocodingJson(Map<String, dynamic> json) {
    return Cidade(
      nome: json['name']?.toString() ?? '',
      estado: json['admin1']?.toString() ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  
  factory Cidade.fromJson(Map<String, dynamic> json) {
    return Cidade(
      nome: json['nome'] as String,
      estado: json['estado'] as String? ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'estado': estado,
        'latitude': latitude,
        'longitude': longitude,
      };
}
