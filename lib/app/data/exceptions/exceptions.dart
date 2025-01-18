class ServerException implements Exception {
  final String message;
  ServerException({this.message = 'Server error occurred'});
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException({this.message = 'Authentication required'});
}

class ForbiddenException implements Exception {
  final String message;
  ForbiddenException({this.message = 'Access denied'});
}

class NetworkException implements Exception {
  final String message;
  NetworkException({this.message = 'Network error occurred'});
}

class CacheException implements Exception {
  final String message;
  CacheException({this.message = 'Cache error occurred'});
}

class ValidationException implements Exception {
  final String message;
  ValidationException({this.message = 'Validation error occurred'});
}

class LocationException implements Exception {
  final String message;
  LocationException({this.message = 'Location error occurred'});
}

class DatabaseException implements Exception {
  final String message;
  DatabaseException({this.message = 'Database error occurred'});
}
