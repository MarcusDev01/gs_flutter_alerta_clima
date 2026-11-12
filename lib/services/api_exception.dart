
class ApiException implements Exception {
  const ApiException(this.mensagem);

  final String mensagem;

  @override
  String toString() => mensagem;
}
