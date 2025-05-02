import 'package:valli_di_comacchio/app/shared/core/error/failures/failures.dart';
import 'package:valli_di_comacchio/app/shared/l10n/app_translations.dart';

class ApiFailure extends Failure {
  const ApiFailure({this.statusCode, this.errorMessage});

  final int? statusCode;
  final String? errorMessage;

  @override
  String message() => errorMessage ?? tr.commonErrorUnknownFailureMessage;
}
