class ServerException implements Exception {
  ServerException([this.message = 'Server error occurred']);

  final String message;

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  NetworkException([this.message = 'Network error occurred']);

  final String message;

  @override
  String toString() => message;
}

class NotFoundException implements Exception {
  NotFoundException([this.message = 'Resource not found']);

  final String message;

  @override
  String toString() => message;
}

class CacheException implements Exception {
  CacheException([this.message = 'Cache error occurred']);

  final String message;

  @override
  String toString() => message;
}
