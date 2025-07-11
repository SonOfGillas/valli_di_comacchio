import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/logic/quests_cubit.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/components/npc_dislay_header.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/trade_page.dart';
import 'package:valli_di_comacchio/app/shared/components/appButton/glowing_button.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h1_on_primary/h1_on_primary.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h2/h2.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h3/h3.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/labelText.dart/label_text.dart';
import 'package:valli_di_comacchio/app/shared/core/routes/routes_paths.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/location_information.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

class NpcLocationDetail extends StatelessWidget {
  const NpcLocationDetail({
    super.key,
    required this.npc,
    this.onBack,
  });

  final Npc npc;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NpcLocationAppBar(onBack: onBack, npc: npc),
      backgroundColor: AppColors.palette_secondary,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              npc.locationInformation.imagePath,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: AppColors.palette_secondary.withOpacity(0.2),
          ),
          SingleChildScrollView(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // NPC Header
                  NpcDisplayHeader(
                    npc: npc,
                    npcMessage:
                        'Benvenuto,  Scorri per avere piu informazioni su ${npc.locationInformation.name}. oppure accetta una missione o commercia con me per iniziare a fare punti',
                    expanded: true,
                  ),
                  const SizedBox(height: 24),
                  // Glowing Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GlowingButton(
                          text: 'Missioni',
                          onPressed: () {
                            Navigator.of(context).pop();
                            context.push(
                              RoutesPaths.quest,
                              extra: QuestPageParameters(selectedNpc: npc),
                            );
                          },
                        ),
                        GlowingButton(
                          text: 'Commercia',
                          onPressed: () {
                            Navigator.of(context).pop();
                            context.push(
                              RoutesPaths.trade,
                              extra: TradePageParameters(npcId: npc.id),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        LocationDescription(
                          description: npc.locationInformation.description,
                        ),
                        const SizedBox(height: 16),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.palette_primary,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: H2('Cosa fare?'),
                          ),
                        ),
                        // Sublocations npc.locationInformation.subLocationsOrActivities
                        Column(
                          children: npc
                              .locationInformation.subLocationsOrActivities
                              .map((subLocation) => SubLocationOrActivityWidget(
                                    subLocationOrActivity: subLocation,
                                  ))
                              .toList(),
                        ),
                        SizedBox(height: 32),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NpcLocationAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NpcLocationAppBar({
    super.key,
    required this.onBack,
    required this.npc,
  });

  final VoidCallback? onBack;
  final Npc npc;

  @override
  Size get preferredSize => const Size.fromHeight(62);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      decoration: BoxDecoration(
        color: AppColors.palette_primary,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: onBack ?? () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: H1(
              npc.locationInformation.name,
            ),
          ),
        ],
      ),
    );
  }
}

class LocationDescription extends StatelessWidget {
  const LocationDescription({
    super.key,
    required this.description,
  });

  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.palette_primary,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: H2('Descrizione'),
            ),
          ),
          LabelText(description),
        ],
      ),
    );
  }
}

class SubLocationOrActivityWidget extends StatelessWidget {
  const SubLocationOrActivityWidget({
    super.key,
    required this.subLocationOrActivity,
  });

  final SubLocationOrActivity subLocationOrActivity;

  @override
  Widget build(BuildContext context) {
    final mondayOpening = subLocationOrActivity.opening[0];
    final mondayClosing = subLocationOrActivity.closing[0];
    final tuesdayOpening = subLocationOrActivity.opening[1];
    final tuesdayClosing = subLocationOrActivity.closing[1];
    final wednesdayOpening = subLocationOrActivity.opening[2];
    final wednesdayClosing = subLocationOrActivity.closing[2];
    final thursdayOpening = subLocationOrActivity.opening[3];
    final thursdayClosing = subLocationOrActivity.closing[3];
    final fridayOpening = subLocationOrActivity.opening[4];
    final fridayClosing = subLocationOrActivity.closing[4];
    final saturdayOpening = subLocationOrActivity.opening[5];
    final saturdayClosing = subLocationOrActivity.closing[5];
    final sundayOpening = subLocationOrActivity.opening[6];
    final sundayClosing = subLocationOrActivity.closing[6];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.palette_primary,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: H3(subLocationOrActivity.name),
            ),
          ),
          const SizedBox(height: 8),
          LabelText(subLocationOrActivity.description),
          // opening hours
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DayOfTheWeek(
                name: 'Lun',
                opening: mondayOpening,
                closing: mondayClosing,
              ),
              DayOfTheWeek(
                name: 'Mar',
                opening: tuesdayOpening,
                closing: tuesdayClosing,
              ),
              DayOfTheWeek(
                name: 'Mer',
                opening: wednesdayOpening,
                closing: wednesdayClosing,
              ),
              DayOfTheWeek(
                name: 'Gio',
                opening: thursdayOpening,
                closing: thursdayClosing,
              ),
              DayOfTheWeek(
                name: 'Ven',
                opening: fridayOpening,
                closing: fridayClosing,
              ),
              DayOfTheWeek(
                name: 'Sab',
                opening: saturdayOpening,
                closing: saturdayClosing,
              ),
              DayOfTheWeek(
                name: 'Dom',
                opening: sundayOpening,
                closing: sundayClosing,
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              launchUrl(Uri.parse('https://flutter.dev'));
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary_light,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: AppColors.background_white.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppColors.background_white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Per saperne di più',
                      style: TextStyle(
                        color: AppColors.background_white,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.background_white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: AppColors.background_white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DayOfTheWeek extends StatelessWidget {
  final String name;
  final TimeOfDay opening;
  final TimeOfDay closing;

  const DayOfTheWeek({
    super.key,
    required this.name,
    required this.opening,
    required this.closing,
  });

  String formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        LabelText(name),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.palette_tertiary,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Column(
              children: [
                LabelText(
                  formatTimeOfDay(opening),
                  withBoarder: false,
                ),
                LabelText(formatTimeOfDay(closing), withBoarder: false),
              ],
            ),
          ),
        )
      ],
    );
  }
}
