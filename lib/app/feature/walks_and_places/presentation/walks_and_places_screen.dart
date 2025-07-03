import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/walks_and_places/logic/walks_and_places_cubit.dart';
import 'package:valli_di_comacchio/app/feature/walks_and_places/logic/walks_and_places_state.dart';
import 'package:valli_di_comacchio/app/feature/walks_and_places/presentation/components/location_element.dart';
import 'package:valli_di_comacchio/app/shared/components/footer_nav_bar/footer_nav_bar.dart';
import 'package:valli_di_comacchio/app/shared/components/valli_app_bar/valli_app_bar.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

class WalksAndPlacesScreen extends StatelessWidget {
  const WalksAndPlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalksAndPlacesCubit, WalksAndPlacesState>(
      builder: (context, state) {
        return Scaffold(
            backgroundColor: AppColors.palette_secondary,
            appBar: ValliAppBar(),
            body: GridView.builder(
              itemCount: state.npcs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                final npc = state.npcs[index];
                return LocationElement(npc: npc);
              },
            ),
            bottomNavigationBar: FooterNavBar());
      },
    );
  }
}
