import 'dart:typed_data';

import 'package:valli_di_comacchio/app/shared/core/error/exceptions.dart';
import 'package:valli_di_comacchio/app/shared/l10n/app_translations.dart';
import 'package:http/http.dart';

Response checkResponseErrors(Response response) {
  final statusCode = response.statusCode;
  if (statusCode > 299 || statusCode < 200) {
    if (statusCode == 408) {
      throw ServerException(
        errorCode: '408',
        errorMessage: tr.commonErrorServerFailureMessage,
      );
    }
    throw ServerException();
  }
  return response;
}

Uint8List getResponseData(Response response) {
  checkResponseErrors(response);
  final bytes = response.bodyBytes;
  return bytes;
}
