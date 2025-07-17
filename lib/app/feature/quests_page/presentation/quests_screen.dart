import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/logic/quests_cubit.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/logic/quests_state.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/presentation/components/accepted_quest_widget.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/presentation/components/basic_quest_component.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/presentation/components/npc_quests_widget.dart';
import 'package:valli_di_comacchio/app/shared/components/footer_nav_bar/footer_nav_bar.dart';
import 'package:valli_di_comacchio/app/shared/components/success_modal/base_success_modal.dart';
import 'package:valli_di_comacchio/app/shared/components/valli_app_bar/valli_app_bar.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

class QuestsScreen extends StatefulWidget {
  const QuestsScreen({super.key});

  @override
  State<QuestsScreen> createState() => _QuestsScreenState();
}

class _QuestsScreenState extends State<QuestsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuestsCubit, QuestsState>(
      listener: (context, state) {
        // Update tab when state changes
        if (_tabController.index != state.selectedTabIndex) {
          _tabController.animateTo(state.selectedTabIndex);
        }
        if (state.completedQuest != null) {
          showDialog(
              context: context,
              builder: (context) {
                return BaseSuccessModal(
                  alternativeChild: Center(
                      child: BasicQuestComponent(
                          quest: state.completedQuest!, isCompleted: true)),
                  onClose: () {},
                );
              });
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: ValliAppBar(),
            backgroundColor: AppColors.palette_secondary,
            body: Column(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.palette_tertiary,
                  ),
                  child: TabBar(
                    controller: _tabController,
                    onTap: (index) {
                      context.read<QuestsCubit>().changeTab(index);
                    },
                    labelColor: AppColors.palette_primary,
                    unselectedLabelColor: AppColors.primary_light,
                    dividerColor: AppColors.palette_tertiary,
                    indicatorColor: AppColors.palette_primary,
                    labelStyle: GoogleFonts.lilitaOne(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    tabs: [
                      Tab(text: 'Missioni accettate'),
                      Tab(text: 'Elenco missioni'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      AcceptedQuestsWidget(),
                      NpcQuestsWidget(),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: FooterNavBar());
      },
    );
  }
}
