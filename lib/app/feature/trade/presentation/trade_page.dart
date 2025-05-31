import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_bloc.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/trade_screen.dart';
import 'package:valli_di_comacchio/app/shared/core/dependecy_injection/injection_container.dart';

class TradePageParameters {
  const TradePageParameters({
    required this.npcId,
  });
  final String npcId;
}

class TradePage extends StatelessWidget {
  const TradePage({super.key, required this.tradePageParameters});

  final TradePageParameters tradePageParameters;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TradeBloc>(
      create: (context) => sl<TradeBloc>(param1: tradePageParameters),
      child: TradeScreen(),
    );
  }
}
