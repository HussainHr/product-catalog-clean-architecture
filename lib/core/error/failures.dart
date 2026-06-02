sealed class Failure {
  const Failure(this.message);

  final String message;
}

final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong. Please try again.']);
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection. Check your network.']);
}

final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Unable to read saved data.']);
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Product not found.']);
}
