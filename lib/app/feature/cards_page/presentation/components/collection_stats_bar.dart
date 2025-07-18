import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/domain/cards.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/logic/card_cubit.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/logic/card_state.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/labelText.dart/label_text.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

class CollectionStatsBar extends StatelessWidget {
  const CollectionStatsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CardCubit, CardState>(
      buildWhen: (previous, current) =>
          previous.userCards.length != current.userCards.length,
      builder: (context, state) {
        return Container(
          color: AppColors.palette_tertiary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LabelText(
                'Collezione: ${state.userCards.length}/${appCardsCompleteList.length}',
                withBoarder: false,
              ),
            ],
          ),
        );
      },
    );
  }
}
