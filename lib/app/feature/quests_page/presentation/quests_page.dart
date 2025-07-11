import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/logic/quests_cubit.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/presentation/quests_screen.dart';
import 'package:valli_di_comacchio/app/shared/core/dependecy_injection/injection_container.dart';

class QuestsPage extends StatelessWidget {
  const QuestsPage({super.key, required this.questPageParameters});

  final QuestPageParameters questPageParameters;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QuestsCubit>(
        create: (context) => sl<QuestsCubit>(param1: questPageParameters),
        child: const QuestsScreen());
  }
}
