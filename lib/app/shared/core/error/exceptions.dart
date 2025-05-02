class ApiException implements Exception {
  ApiException({required this.statusCode, this.errorMessage});

  final int? statusCode;
  final String? errorMessage;
}

class ServerException implements Exception {
  ServerException({
    this.errorCode,
    this.errorMessage,
    this.nextStep,
  });

  final String? errorCode;
  final String? errorMessage;
  final String? nextStep;
}

class BuisinessLogicException implements Exception {
  BuisinessLogicException({required this.errorMessage});

  final String errorMessage;
}

class UnknownException implements Exception {}
