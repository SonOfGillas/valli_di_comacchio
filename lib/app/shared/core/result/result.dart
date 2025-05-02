import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/shared/core/error/failures/failures.dart';

abstract class BaseResult<ReturnType, ErrorType extends Failure> {}

class Result<ReturnType, ErrorType extends Failure> extends Equatable {
  Result._success(ReturnType success) : _either = Right(success);
  Result._error(ErrorType failure) : _either = Left(failure);

  final Either<ErrorType, ReturnType> _either;

  void fold({
    required void Function(ReturnType) onSuccess,
    void Function(Failure)? onFailure,
  }) =>
      _either.fold(onFailure ?? (_) {}, onSuccess);

  @override
  List<Object?> get props => [_either];
}

class Error<ReturnType, ErrorType extends Failure>
    extends Result<ReturnType, ErrorType> {
  Error(super.failure) : super._error();
}

class Success<ReturnType, ErrorType extends Failure>
    extends Result<ReturnType, ErrorType> {
  Success(super.success) : super._success();
  static Result<void, Failure> empty = Success(null);
}

typedef AsyncResult<ReturnType> = Future<Result<ReturnType, Failure>>;
