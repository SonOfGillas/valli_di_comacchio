import 'package:dio/dio.dart';
import 'package:valli_di_comacchio/app/shared/core/error/exceptions.dart';

Response<T> checkServerResponseErrors<T>(Response<T> response) {
  final statusCode = response.statusCode;
  if (statusCode == null) {
    throw UnknownException();
  } else if (statusCode > 299 || statusCode < 200) {
    throw ServerException();
  }

  return response;
}

T getResponseData<T>(Response<T> response) {
  checkServerResponseErrors(response);
  final data = response.data;
  if (data == null) {
    throw ServerException();
  }
  return data;
}
