import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:valli_di_comacchio/app/feature/home/logic/home_cubit.dart';
import 'package:valli_di_comacchio/app/feature/home/logic/home_state.dart';
import 'package:valli_di_comacchio/app/feature/home/presentation/components/event_element.dart';
import 'package:valli_di_comacchio/app/feature/home/presentation/components/location_element.dart';
import 'package:valli_di_comacchio/app/feature/home/presentation/components/search_app_bar.dart';
import 'package:valli_di_comacchio/app/feature/home/presentation/components/walk_element.dart';
import 'package:valli_di_comacchio/app/shared/components/footer_nav_bar/footer_nav_bar.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

class WalksAndPlacesScreen extends StatelessWidget {
  WalksAndPlacesScreen({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return DefaultTabController(
          length: HomeType.values.length,
          child: Scaffold(
              backgroundColor: AppColors.palette_secondary,
              appBar: SearchAppBar(
                searchController: searchController,
                onSearch: (query) {
                  context.read<HomeCubit>().search(query);
                },
                clearSearch: () {
                  context.read<HomeCubit>().clearSearch();
                },
              ),
              body: Column(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.palette_tertiary,
                    ),
                    child: TabBar(
                      labelColor: AppColors.palette_primary,
                      unselectedLabelColor: AppColors.primary_light,
                      dividerColor: AppColors.palette_tertiary,
                      indicatorColor: AppColors.palette_primary,
                      labelStyle: GoogleFonts.lilitaOne(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      tabs: HomeType.values.map((type) {
                        return Tab(text: type.displayName);
                      }).toList(),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        GridView.builder(
                          itemCount: state.filteredNpcs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.0,
                          ),
                          itemBuilder: (context, index) {
                            final npc = state.filteredNpcs[index];
                            return LocationElement(npc: npc);
                          },
                        ),
                        EventPanelList(events: state.filteredEvents),
                        ListView.builder(
                          itemCount: state.filteredWalks.length,
                          itemBuilder: (context, index) {
                            final walk = state.filteredWalks[index];
                            return WalkElement(walk: walk);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: FooterNavBar()),
        );
      },
    );
  }
}
