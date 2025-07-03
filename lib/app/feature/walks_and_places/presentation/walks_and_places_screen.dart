import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/walks_and_places/logic/walks_and_places_cubit.dart';
import 'package:valli_di_comacchio/app/feature/walks_and_places/logic/walks_and_places_state.dart';
import 'package:valli_di_comacchio/app/feature/walks_and_places/presentation/components/location_element.dart';
import 'package:valli_di_comacchio/app/feature/walks_and_places/presentation/components/search_app_bar.dart';
import 'package:valli_di_comacchio/app/shared/components/footer_nav_bar/footer_nav_bar.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

class WalksAndPlacesScreen extends StatelessWidget {
  WalksAndPlacesScreen({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalksAndPlacesCubit, WalksAndPlacesState>(
      builder: (context, state) {
        return Scaffold(
            backgroundColor: AppColors.palette_secondary,
            appBar: SearchAppBar(
              searchController: searchController,
              onSearch: (query) {
                context.read<WalksAndPlacesCubit>().search(query);
              },
              clearSearch: () {
                context.read<WalksAndPlacesCubit>().clearSearch();
              },
            ),
            body: GridView.builder(
              itemCount: state.filteredNpcs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                final npc = state.filteredNpcs[index];
                return LocationElement(npc: npc);
              },
            ),
            bottomNavigationBar: FooterNavBar());
      },
    );
  }
}
