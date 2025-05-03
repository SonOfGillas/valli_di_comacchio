import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resources.dart';

class TradeResourceInventory extends Equatable {
  const TradeResourceInventory({
    required this.tradeResource,
    required this.defultPrice,
    required this.totalQuantity,
  });

  final TradeResource tradeResource;
  final int defultPrice;
  final int totalQuantity;

  @override
  List<Object?> get props => [tradeResource, defultPrice, totalQuantity];

  TradeResourceInventory copyWith({
    int? defultPrice,
    int? totalQuantity,
  }) {
    return TradeResourceInventory(
      tradeResource: tradeResource,
      defultPrice: defultPrice ?? this.defultPrice,
      totalQuantity: totalQuantity ?? this.totalQuantity,
    );
  }
}
