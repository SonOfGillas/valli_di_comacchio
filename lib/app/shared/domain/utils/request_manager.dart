import 'package:dio/dio.dart';
import 'package:valli_di_comacchio/app/shared/core/error/exceptions.dart';
import 'package:valli_di_comacchio/app/shared/core/error/failures/failures.dart';
import 'package:valli_di_comacchio/app/shared/core/result/result.dart';

typedef ApiRequest<T> = Future<T> Function();

Future<Result<T, Failure>> manageRequest<T>(Future<T> future) async {
  try {
    final result = await future;
    return Success(result);
  } on DioException catch (e) {
    final exception = ApiException(
      statusCode: e.response!.statusCode,
      errorMessage: e.message,
    );
    return Error(Failure.fromException(exception));
  } on Exception catch (e) {
    return Error(Failure.fromException(e));
  } catch (e) {
    return Error(UnknownFailure());
  }
}
