import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/logic/quests_cubit.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/logic/quests_state.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/presentation/components/basic_quest_component.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/components/npc_dislay_header.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/labelText.dart/label_text.dart';
import 'package:valli_di_comacchio/app/shared/components/footer_nav_bar/footer_nav_bar.dart';
import 'package:valli_di_comacchio/app/shared/components/valli_app_bar/valli_app_bar.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';
import 'package:valli_di_comacchio/app/shared/style/app_icons.dart';

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

class AcceptedQuestsWidget extends StatelessWidget {
  const AcceptedQuestsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestsCubit, QuestsState>(
      builder: (context, state) {
        return state.status == QuestPageStatus.loading
            ? const Center(
                child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                ],
              ))
            : state.acceptedQuests.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            AppIcons.empty_folder,
                            height: 64,
                            colorFilter: ColorFilter.mode(
                              AppColors.palette_primary,
                              BlendMode.srcIn,
                            ),
                          ),
                          SizedBox(height: 16),
                          LabelText(
                            'Non hai ancora accettato nessuna missione.',
                            withBoarder: false,
                          ),
                        ],
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      // Implement the UI for accepted quests
                      children: [
                        ...state.acceptedQuests.map((quest) {
                          return ListTile(
                            title: Text(quest.uuid),
                            subtitle: Text(quest.type.toString()),
                            trailing: IconButton(
                              icon: const Icon(Icons.check),
                              onPressed: () {
                                // Handle quest completion
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  );
      },
    );
  }
}

class NpcQuestsWidget extends StatelessWidget {
  const NpcQuestsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestsCubit, QuestsState>(
      builder: (context, state) {
        return state.status == QuestPageStatus.loading
            ? const Center(
                child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  LabelText('Stiamo generando delle nuove missioni per te!'),
                ],
              ))
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (state.mode == QuestPageMode.npcList)
                      ...context.read<QuestsCubit>().npcs.map((npc) {
                        return ListTile(
                          title: Text(npc.name),
                          onTap: () {
                            context.read<QuestsCubit>().showNpcQuests(npc);
                          },
                        );
                      }),
                    if (state.mode == QuestPageMode.npcQuests)
                      Stack(
                        children: [
                          NpcDisplayHeader(
                            npc: state.selectedNpc!,
                            npcMessage:
                                'Completa una missione per guardagnare monete!',
                            showBalance: false,
                          ),
                          Positioned(
                            top: 16,
                            right: 16,
                            child: IconButton(
                              icon: const Icon(
                                Icons.close,
                                size: 36,
                                color: AppColors.palette_primary,
                              ),
                              onPressed: () {
                                context.read<QuestsCubit>().goToNpcList();
                              },
                            ),
                          ),
                        ],
                      ),
                    if (state.mode == QuestPageMode.npcQuests)
                      ...state.npcQuests.map((quest) {
                        return BasicQuestComponent(
                          quest: quest,
                        );
                      })
                  ],
                ),
              );
      },
    );
  }
}
