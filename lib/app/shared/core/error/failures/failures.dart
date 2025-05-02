import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/shared/core/error/exceptions.dart';
import 'package:valli_di_comacchio/app/shared/core/error/failures/api_failures.dart';
import 'package:valli_di_comacchio/app/shared/l10n/app_translations.dart';
import 'package:dio/dio.dart';

abstract class Failure extends Equatable {
  const Failure();

  factory Failure.fromException(Exception exception) {
    if (exception is DioException) {
      return Failure.fromDioException(exception);
    } else if (exception is ApiException) {
      return ApiFailure(
        statusCode: exception.statusCode,
        errorMessage: exception.errorMessage,
      );
    } else if (exception is ServerException) {
      return ServerFailure(
        errorCode: exception.errorCode,
        errorMessage: exception.errorMessage,
        nextStep: exception.nextStep,
      );
    } else if (exception is BuisinessLogicException) {
      return BuisinessLogicFailure(errorMessage: exception.errorMessage);
    } else if (exception is SocketException) {
      return ServerFailure(
        errorCode: 'CONNECTION_ERROR',
        errorMessage: tr.commonErrorServerFailureMessage,
      );
    }
    return UnknownFailure();
  }
  factory Failure.fromDioException(DioException exception) {
    if (exception.type == DioExceptionType.receiveTimeout ||
        exception.type == DioExceptionType.connectionTimeout ||
        exception.type == DioExceptionType.sendTimeout) {
      return TimeoutFailure();
    }
    return UnknownFailure();
  }

  factory Failure.fromMessage(String message) {
    return BuisinessLogicFailure(errorMessage: message);
  }

  @override
  List<Object> get props => [];

  String message();
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure({this.errorCode, this.errorMessage, this.nextStep});
  final String? errorCode;
  final String? errorMessage;
  final String? nextStep;

  @override
  String message() => '${tr.commonError} $errorMessage';
}

class BuisinessLogicFailure extends Failure {
  const BuisinessLogicFailure({required this.errorMessage});
  final String errorMessage;

  @override
  String message() => errorMessage;
}

class TimeoutFailure extends Failure {
  @override
  String message() => tr.commonErrorTimeoutFailureMessage;
}

class UnknownFailure extends Failure {
  @override
  String message() => tr.commonErrorUnknownFailureMessage;
}
