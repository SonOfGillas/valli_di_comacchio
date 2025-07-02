import 'package:bloc/bloc.dart';
import 'package:valli_di_comacchio/app/feature/trade/domain/entities/trade_resource_offer.dart';
import 'package:valli_di_comacchio/app/feature/trade/domain/utils/change_resource_amount.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_event.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_state.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/trade_page.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_cubit.dart';
import 'package:valli_di_comacchio/app/shared/core/error/failures/failures.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/counter_offer_request.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/offer_type.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/past_conversation_entry.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/npc_repository.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/user_repository.dart';

import '../../../shared/domain/entities/app_user.dart';

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
    on<SetCounterOfferPrice>(_onSetCounterOffertPrice);
    on<SetCounterOfferQuantity>(_onSetCounterOfferQuantity);
    on<SetCounterOfferMessage>(_onSetCounterOfferMessage);
    on<SendCounterOffer>(_onSendCounterOffer);
    on<CloseError>(_onCloseError);
    on<SuccessResolve>(_onSuccessResolve);

    add(LoadData(npcId: tradePageParameters.npcId));
  }

  final AppCubit appCubit;
  final UserRepository userRepository;
  final NpcRepository npcRepository;
  final TradePageParameters tradePageParameters;

  AppUser? get user => appCubit.state.user;
  String? aiGeneratedNpcMessage;

  get tradeResourceUserInventory => user?.inventory.firstWhere(
        (element) =>
            element.tradeResource.id ==
            state.selectedResource!.tradeResource.id,
      );

  get npcOfferIsNotAcceptable {
    if (state.npcOffert == null || state.npc == null) return false;
    if (state.npcOffert!.offerType == OfferType.buy) {
      return state.npcOffert!.offerQuantity == 0 ||
          (state.npcOffert!.totalCost > user!.wealth) ||
          (state.npcOffert!.offerQuantity > state.selectedResource!.storage);
    } else if (state.npcOffert!.offerType == OfferType.sell) {
      return state.npcOffert!.offerQuantity == 0 ||
          (state.npcOffert!.totalCost > state.npc!.wealth) ||
          (state.npcOffert!.offerQuantity > tradeResourceUserInventory.storage);
    }
    return false;
  }

  void _onLoadData(LoadData event, Emitter<TradeState> emit) async {
    final npcFromState = appCubit.state.npcs
        .firstWhere((n) => n.id == tradePageParameters.npcId);
    emit(state.copyWith(status: TradeStatus.loading, npc: npcFromState));
    _getNpcMessage(emit);
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
    if (event.offerType == OfferType.buy &&
        (state.selectedResource?.storage ?? 0) <= 0) {
      emit(state.copyWith(
        status: TradeStatus.failure,
        failure: Failure.fromMessage(
            'You cannot buy this resource because NPC have no storage left.'),
      ));
    } else if (event.offerType == OfferType.sell &&
        (user?.inventory
                    .firstWhere(
                      (element) =>
                          element.tradeResource.id ==
                          state.selectedResource?.tradeResource.id,
                    )
                    .storage ??
                0) <=
            0) {
      emit(state.copyWith(
        status: TradeStatus.failure,
        failure: Failure.fromMessage(
            'You cannot sell this resource because you have no storage left.'),
      ));
    } else {
      var npcOffer = TradeResourceOffer(
        isUserOffer: false,
        offerType: event.offerType,
        tradeResourceInventory: state.selectedResource!,
      );
      while (!npcOffer.isOfferValid(user!, state.npc!)) {
        npcOffer = npcOffer.copyWith(
          manualOfferQuantity: npcOffer.offerQuantity - 1,
        );
      }
      _resetAllPastConversationAndErrors(emit);
      emit(state.copyWith(
        step: TradingStep.setPrice,
        npcOffert: npcOffer,
        userCounterOffert: npcOffer.copyWith(isUserOffer: true),
      ));
      _getNpcMessage(emit);
    }
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
        offer: state.npcOffert!,
        npc: state.npc!,
      );

      final npcUpdateResponse = await npcRepository.updateNpcData(updatedNpc);
      late final bool npcUpdatedCorrectly;

      npcUpdateResponse.fold(
        onSuccess: (_) {
          npcUpdatedCorrectly = true;
        },
        onFailure: (error) async {
          npcUpdatedCorrectly = false;
          emit(state.copyWith(
            status: TradeStatus.failure,
            failure: error,
          ));
        },
      );

      if (!npcUpdatedCorrectly) {
        return;
      }

      final updateUserResult = await appCubit.updateUser(updatedUser);

      if (updateUserResult) {
        emit(state.copyWith(
          status: TradeStatus.success,
          npc: updatedNpc,
        ));
      } else {
        emit(state.copyWith(
          status: TradeStatus.failure,
          failure: Failure.fromMessage('aggiornamento utente fallito'),
        ));
        return;
      }
    }
  }

  void _onSuccessResolve(SuccessResolve event, Emitter<TradeState> emit) {
    _resetAllPastConversationAndErrors(emit);
    emit(state.copyWith(
      status: TradeStatus.idle,
      step: TradingStep.selectResource,
      selectedResource: null,
      npcOffert: null,
      userCounterOffert: null,
    ));
    _getNpcMessage(emit);
  }

  void _onSetCounterOffertPrice(
      SetCounterOfferPrice event, Emitter<TradeState> emit) {
    if (state.userCounterOffert == null) {
      emit(state.copyWith(
          status: TradeStatus.failure,
          failure: Failure.fromMessage('No counter offer available'),
          step: TradingStep.selectOfferType));
    } else {
      final newOffert =
          state.userCounterOffert?.copyWith(manualOfferPrice: event.price);

      final isOffertValid = newOffert!.isOfferValid(user!, state.npc!);

      emit(state.copyWith(
        status: isOffertValid ? null : TradeStatus.failure,
        isCounterOfferValid: isOffertValid,
        userCounterOffert: newOffert,
      ));

      if (!isOffertValid) {
        getErrorMessage(emit);
      }
    }
  }

  void _onSetCounterOfferQuantity(
      SetCounterOfferQuantity event, Emitter<TradeState> emit) {
    if (state.userCounterOffert == null) {
      emit(state.copyWith(
          status: TradeStatus.failure,
          failure: Failure.fromMessage('No counter offer available'),
          step: TradingStep.selectOfferType));
    } else {
      final newOffert = state.userCounterOffert
          ?.copyWith(manualOfferQuantity: event.quantity);

      final isOffertValid = newOffert!.isOfferValid(user!, state.npc!);

      emit(state.copyWith(
        status: isOffertValid ? null : TradeStatus.failure,
        isCounterOfferValid: isOffertValid,
        userCounterOffert: newOffert,
      ));
      if (!isOffertValid) {
        getErrorMessage(emit);
      }
    }
  }

  void _onSetCounterOfferMessage(
      SetCounterOfferMessage event, Emitter<TradeState> emit) {
    emit(state.copyWith(messageToTheNpc: event.message));
  }

  List<PastConversationEntry> _getDefaultOfferConversation() {
    return [
      PastConversationEntry(
        order: 0,
        entity: ConversationEntity.merchant,
        message: state.npcMessage,
        quantity: state.npcOffert?.offerQuantity ?? 1,
        price: state.npcOffert?.offerPrice ?? 0,
      )
    ];
  }

  void _onSendCounterOffer(
      SendCounterOffer event, Emitter<TradeState> emit) async {
    final pastConversation = state.pastConversation.isEmpty
        ? _getDefaultOfferConversation()
        : state.pastConversation;

    final userCounterOffert = CounterOfferRequest(
      name: state.npc?.name ?? '',
      resource: state.selectedResource?.tradeResource.name ?? '',
      intent: state.userCounterOffert?.offerType ?? OfferType.buy,
      minPrice: state.npcOffert?.tradeData.minPrice ?? 0,
      maxPrice: state.npcOffert?.tradeData.maxPrice ?? 0,
      targetQuantity: state.npcOffert?.tradeData.idealExchangebleQuantity ?? 0,
      maxQuantity: state.npcOffert?.tradeData.maxExchangebleQuantity ?? 0,
      userOfferPrice: state.userCounterOffert?.offerPrice ?? 0,
      userOfferQuantity: state.userCounterOffert?.offerQuantity ?? 0,
      userMessage: state.messageToTheNpc,
      pastConversation: pastConversation,
    );
    emit(state.copyWith(status: TradeStatus.loading));
    final response =
        await npcRepository.getNpcReponseToCounterOffer(userCounterOffert);
    emit(state.copyWith(status: TradeStatus.idle));

    response.fold(
      onSuccess: (npcResponse) {
        final lastMessageIndex = state.pastConversation.length - 1;
        final newPastConversation = state.pastConversation
          ..add(PastConversationEntry(
            order: lastMessageIndex + 1,
            entity: ConversationEntity.user,
            message: state.messageToTheNpc,
            quantity: state.userCounterOffert?.offerQuantity ?? 0,
            price: state.userCounterOffert?.offerPrice ?? 0,
          ))
          ..add(PastConversationEntry(
            order: lastMessageIndex + 2,
            entity: ConversationEntity.merchant,
            message: npcResponse.npcMessage,
            quantity: npcResponse.npcOfferQuantity,
            price: npcResponse.npcOfferPrice,
          ));
        aiGeneratedNpcMessage = npcResponse.npcMessage;
        final newNpcOffer = state.npcOffert?.copyWith(
            manualOfferPrice: npcResponse.npcOfferPrice,
            manualOfferQuantity: npcResponse.npcOfferQuantity);
        emit(state.copyWith(
          npcOffert: newNpcOffer,
          messageToTheNpc: '',
          pastConversation: newPastConversation,
          tradeFailed: npcResponse.stopTheTrade,
        ));
        _getNpcMessage(emit);
      },
      onFailure: (error) {
        emit(state.copyWith(
          status: TradeStatus.failure,
          failure: error,
        ));
      },
    );
  }

  void _onCloseError(CloseError event, Emitter<TradeState> emit) {
    emit(state.copyWith(status: TradeStatus.idle, failure: null));
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
      if (aiGeneratedNpcMessage != null) {
        emit(state.copyWith(npcMessage: aiGeneratedNpcMessage!));
        return;
      }
      if (state.npcOffert?.offerQuantity == 0) {
        emit(state.copyWith(
            npcMessage: state.npcOffert?.offerType == OfferType.buy
                ? 'Non posso fare un\'offerta per ${state.selectedResource?.tradeResource.name} perché non hai abbastanza monete.'
                : 'Non posso fare un\'offerta per ${state.selectedResource?.tradeResource.name} perché non ho abbastanza monete.'));
        return;
      }
      emit(state.copyWith(
          npcMessage:
              'Ecco la mia offerta per ${state.selectedResource?.tradeResource.name}. Se ti va bene, accetta l\'offerta. Altrimenti, puoi fare una controfferta.'));
    } else {
      emit(state.copyWith(npcMessage: ''));
    }
  }

  void _resetAllPastConversationAndErrors(Emitter<TradeState> emit) {
    aiGeneratedNpcMessage = null;
    emit(state.copyWith(
      pastConversation: [],
      failure: null,
      isCounterOfferValid: true,
      tradeFailed: false,
    ));
  }

  void getErrorMessage(Emitter<TradeState> emit) {
    late String errorMessage;

    final offer = state.userCounterOffert;
    if (offer == null) {
      emit(state.copyWith(
        status: TradeStatus.failure,
        failure: Failure.fromMessage('No counter offer available'),
      ));
      return;
    }
    if (offer.offerType == OfferType.buy) {
      if (user!.wealth < offer.totalCost) {
        errorMessage = 'You don\'t have enough coins to buy at this price';
      } else if (offer.offerQuantity > offer.tradeResourceInventory.storage) {
        errorMessage = 'The NPC doesn\'t have enough resources in storage';
      }
    } else {
      if (state.npc!.wealth < offer.totalCost) {
        errorMessage =
            'The NPC doesn\'t have enough coins to buy at this price';
      } else if (offer.offerQuantity > tradeResourceUserInventory.storage) {
        errorMessage = 'You don\'t have enough resources in storage';
      }
    }

    emit(state.copyWith(
      status: TradeStatus.failure,
      failure: Failure.fromMessage(errorMessage),
    ));
  }
}
