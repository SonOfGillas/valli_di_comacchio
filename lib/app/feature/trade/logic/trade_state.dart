import 'package:valli_di_comacchio/app/shared/core/error/failures/failures.dart';

enum TradeStatus { idle, loading, succeeded, failure }

class TradeState {
  final TradeStatus status;
  final ServerFailure? failure;

  const TradeState({
    this.status = TradeStatus.idle,
    this.failure,
  });

  TradeState copyWith({
    TradeStatus? status,
    ServerFailure? failure,
  }) {
    return TradeState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
