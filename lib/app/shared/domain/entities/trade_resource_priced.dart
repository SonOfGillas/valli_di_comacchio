import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resources.dart';

class TradeResourceOffert extends Equatable {
  const TradeResourceOffert({
    required this.tradeResource,
    required this.price,
    required this.offertQuantity,
    required this.totalQuantity,
  });

  final TradeResource tradeResource;
  final int price;
  final int offertQuantity;
  final int totalQuantity;

  int get totalPrice => price * offertQuantity;

  @override
  List<Object?> get props =>
      [tradeResource, price, offertQuantity, totalQuantity];

  TradeResourceOffert copyWith({
    int? price,
    int? offertQuantity,
    int? totalQuantity,
  }) {
    return TradeResourceOffert(
      tradeResource: tradeResource,
      price: price ?? this.price,
      offertQuantity: offertQuantity ?? this.offertQuantity,
      totalQuantity: totalQuantity ?? this.totalQuantity,
    );
  }
}
