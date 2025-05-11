import 'package:bloc/bloc.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_event.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_state.dart';

class TradeBloc extends Bloc<TradeEvent, TradeState> {
  TradeBloc() : super(const TradeState()) {
    on<LoadTradeData>(_onLoadTradeData);
    on<SelectTradeResource>(_onSelectTradeResource);
    on<BuyTradeResource>(_onBuyTradeResource);
    on<SellTradeResource>(_onSellTradeResource);
    on<TradeResourceAcceptOffert>(_onTradeResourceAcceptOffert);
    on<TradeResourceSetPrice>(_onTradeResourceSetPrice);
  }

  void _onLoadTradeData(LoadTradeData event, Emitter<TradeState> emit) {}

  void _onSelectTradeResource(
      SelectTradeResource event, Emitter<TradeState> emit) {}

  void _onBuyTradeResource(BuyTradeResource event, Emitter<TradeState> emit) {}

  void _onSellTradeResource(
      SellTradeResource event, Emitter<TradeState> emit) {}

  void _onTradeResourceAcceptOffert(
      TradeResourceAcceptOffert event, Emitter<TradeState> emit) {}

  void _onTradeResourceSetPrice(
      TradeResourceSetPrice event, Emitter<TradeState> emit) {}
}
