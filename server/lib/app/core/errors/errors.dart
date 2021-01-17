abstract class BibliaHinarioError implements Exception {
  final String message;

  BibliaHinarioError(this.message);

  @override
  String toString() {
    return '${runtimeType.toString()}: $message';
  }
}

class ServerError extends BibliaHinarioError {
  ServerError(String message) : super(message);
}
