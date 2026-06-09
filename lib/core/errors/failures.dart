abstract class AppFailure implements Exception {
  final String message;
  const AppFailure(this.message);

  @override
  String toString() => message;
}

class NetworkFailure extends AppFailure {
  const NetworkFailure()
      : super('No internet connection. Please check your network and try again.');
}

class ServerFailure extends AppFailure {
  const ServerFailure() : super('Could not fetch tasks from the server.');
}

class CacheFailure extends AppFailure {
  const CacheFailure() : super('Could not read from local storage.');
}
