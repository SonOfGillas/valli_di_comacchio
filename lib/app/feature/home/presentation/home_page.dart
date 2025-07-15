import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/home/logic/home_cubit.dart';
import 'package:valli_di_comacchio/app/feature/home/presentation/home_screen.dart';
import 'package:valli_di_comacchio/app/shared/core/dependecy_injection/injection_container.dart';

class WalksAndPlacesPage extends StatelessWidget {
  const WalksAndPlacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (context) => sl<HomeCubit>(),
      child: WalksAndPlacesScreen(),
    );
  }
}
