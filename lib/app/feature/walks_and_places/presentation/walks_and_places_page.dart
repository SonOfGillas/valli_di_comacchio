import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/walks_and_places/logic/walks_and_places_cubit.dart';
import 'package:valli_di_comacchio/app/feature/walks_and_places/presentation/walks_and_places_screen.dart';
import 'package:valli_di_comacchio/app/shared/core/dependecy_injection/injection_container.dart';

class WalksAndPlacesPage extends StatelessWidget {
  const WalksAndPlacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WalksAndPlacesCubit>(
      create: (context) => sl<WalksAndPlacesCubit>(),
      child: WalksAndPlacesScreen(),
    );
  }
}
