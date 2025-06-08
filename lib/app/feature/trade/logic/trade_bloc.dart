import 'package:bloc/bloc.dart';
import 'package:valli_di_comacchio/app/feature/trade/domain/entities/trade_resource_offer.dart';
import 'package:valli_di_comacchio/app/feature/trade/domain/utils/change_resource_amount.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_event.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_state.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/trade_page.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_cubit.dart';
import 'package:valli_di_comacchio/app/shared/core/error/failures/failures.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/npc_repository.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/user_repository.dart';

import '../../../shared/domain/entities/user.dart';

class TradeBloc extends Bloc<TradeEvent, TradeState> {
  TradeBloc({
    required this.appCubit,
    required this.userRepository,
    required this.npcRepository,
    required this.tradePageParameters,
  }) : super(const TradeState()) {
    on<LoadData>(_onLoadData);
    on<SelectTradeResource>(_onSelectTradeResource);
    on<SelectOfferType>(_onSelectOfferType);
    on<GoBack>(_onGoBack);
    on<AcceptOffer>(_onAcceptOffert);
    on<SetCounterOffertPrice>(_onSetCounterOffertPrice);
    on<SetCounterOfferAmount>(_onSetCounterOfferAmount);
    on<SetCounterOfferMotivation>(_onSetCounterOfferMotivation);
    on<SendCounterOffer>(_onSendCounterOffer);

    add(LoadData(npcId: tradePageParameters.npcId));
  }

  final AppCubit appCubit;
  final UserRepository userRepository;
  final NpcRepository npcRepository;
  final TradePageParameters tradePageParameters;

  User? get user => appCubit.state.user;

  void _onLoadData(LoadData event, Emitter<TradeState> emit) async {
    _getNpcMessage(emit);
    await appCubit.loadUserData();
    if (appCubit.state.user == null) {
      emit(state.copyWith(
        status: TradeStatus.failure,
        failure: Failure.fromMessage('User not found'),
      ));
      return;
    }
    final npcResponse = await npcRepository.getNpcById(event.npcId);

    npcResponse.fold(
      onSuccess: (npc) {
        emit(state.copyWith(
          status: TradeStatus.idle,
          npc: npc,
          step: TradingStep.selectResource,
        ));
      },
      onFailure: (error) {
        emit(state.copyWith(
          status: TradeStatus.failure,
          failure: error,
        ));
      },
    );
  }

  void _onSelectTradeResource(
      SelectTradeResource event, Emitter<TradeState> emit) {
    emit(state.copyWith(
      selectedResource: event.resource,
      step: TradingStep.selectOfferType,
    ));
    _getNpcMessage(emit);
  }

  void _onSelectOfferType(SelectOfferType event, Emitter<TradeState> emit) {
    emit(state.copyWith(
      step: TradingStep.setPrice,
      userCounterOffert: TradeResourceOffer(
        offerType: event.offerType,
        tradeResourceInventory: state.selectedResource!,
      ),
      npcOffert: TradeResourceOffer(
        offerType: event.offerType,
        tradeResourceInventory: state.selectedResource!,
      ),
    ));
    _getNpcMessage(emit);
  }

  void _onGoBack(GoBack event, Emitter<TradeState> emit) {
    if (state.step == TradingStep.setPrice) {
      emit(state.copyWith(
        step: TradingStep.selectOfferType,
        userCounterOffert: null,
      ));
    } else if (state.step == TradingStep.selectOfferType) {
      emit(state.copyWith(
        step: TradingStep.selectResource,
        userCounterOffert: null,
      ));
    }
    _getNpcMessage(emit);
  }

  void _onAcceptOffert(AcceptOffer event, Emitter<TradeState> emit) async {
    if (state.npcOffert != null && user != null) {
      final updatedUser =
          applyOfferToUser(offer: state.npcOffert!, user: user!);
      final updatedNpc = applyOfferToNpc(
        offer: state.userCounterOffert!,
        npc: state.npc!,
      );
      final userUpdateReponse =
          await userRepository.updateUserData(updatedUser);
      userUpdateReponse.fold(
        onSuccess: (_) async {
          final npcUpdateResponse =
              await npcRepository.updateNpcData(updatedNpc);
          npcUpdateResponse.fold(
            onSuccess: (_) {
              appCubit.updateUser(updatedUser);
              emit(state.copyWith(
                status: TradeStatus.idle,
                npc: updatedNpc,
                step: TradingStep.selectResource,
                selectedResource: null,
                npcOffert: null,
                userCounterOffert: null,
              ));
            },
            onFailure: (error) {
              emit(state.copyWith(
                status: TradeStatus.failure,
                failure: error,
              ));
            },
          );
        },
        onFailure: (error) {
          emit(state.copyWith(
            status: TradeStatus.failure,
            failure: error,
          ));
        },
      );
    }
  }

  void _onSetCounterOffertPrice(
      SetCounterOffertPrice event, Emitter<TradeState> emit) {
    if (state.userCounterOffert == null) {
      emit(state.copyWith(
          status: TradeStatus.failure,
          failure: Failure.fromMessage('No counter offer available'),
          step: TradingStep.selectOfferType));
    } else {
      final newOffert =
          state.userCounterOffert?.copyWith(manualOfferPrice: event.price);
      emit(state.copyWith(userCounterOffert: newOffert));
    }
  }

  void _onSetCounterOfferAmount(
      SetCounterOfferAmount event, Emitter<TradeState> emit) {
    if (state.userCounterOffert == null) {
      emit(state.copyWith(
          status: TradeStatus.failure,
          failure: Failure.fromMessage('No counter offer available'),
          step: TradingStep.selectOfferType));
    } else {
      final newOffert =
          state.userCounterOffert?.copyWith(offerQuantity: event.amount);
      emit(state.copyWith(userCounterOffert: newOffert));
    }
  }

  void _onSetCounterOfferMotivation(
      SetCounterOfferMotivation event, Emitter<TradeState> emit) {
    emit(state.copyWith(motivation: event.motivation));
  }

  void _onSendCounterOffer(SendCounterOffer event, Emitter<TradeState> emit) {
    //TODO implement send counter offer logic
  }

  void _getNpcMessage(Emitter<TradeState> emit) {
    if (state.step == TradingStep.selectResource) {
      emit(state.copyWith(
          npcMessage:
              'Sarebbe comodo se potessi vendermi le risorse segnate in rosso. Scegli una risorsa che vuoi scambiare con me.'));
    } else if (state.step == TradingStep.selectOfferType) {
      emit(state.copyWith(
          npcMessage:
              'Dunque sei interessato a scambiare ${state.selectedResource?.tradeResource.name} con me?. bene, allora scegli se vuoi comprare o vendere'));
    } else if (state.step == TradingStep.setPrice) {
      emit(state.copyWith(
          npcMessage:
              'Ecco la mia offerta per ${state.selectedResource?.tradeResource.name}. Se ti va bene, accetta l\'offerta. Altrimenti, puoi fare una controfferta.'));
    } else {
      emit(state.copyWith(npcMessage: ''));
    }
  }
}
