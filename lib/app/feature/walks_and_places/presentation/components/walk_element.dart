import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:valli_di_comacchio/app/feature/walks_and_places/domain/walk.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h3/h3.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';
import 'package:valli_di_comacchio/app/shared/style/app_icons.dart';

class WalkElement extends StatelessWidget {
  final Walk walk;

  const WalkElement({
    super.key,
    required this.walk,
  });

  @override
  Widget build(BuildContext context) {
    String getWalkDifficultyTitle() {
      switch (walk.difficulty) {
        case WalkDifficulty.easy:
          return 'Passeggiata facile';
        case WalkDifficulty.medium:
          return 'Passeggiata media';
        case WalkDifficulty.hard:
          return 'Passeggiata difficile';
      }
    }

    return InkWell(
      onTap: () {
        // showDialog(
        //   context: context,
        //   barrierColor: Colors.black.withOpacity(0.85),
        //   builder: (context) => NpcLocationDetail(
        //     npc: npc,
        //     onBack: () => Navigator.of(context).pop(),
        //   ),
        // );
      },
      child: Card(
        color: AppColors.palette_primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Image.asset(
                  walk.imageFilePath,
                  height: 130,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: H3(walk.name),
              ),
              DecoratedBox(
                decoration: BoxDecoration(color: AppColors.primary_light),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          children: [
                            Icon(
                              walk.type == WalkType.pedestrian
                                  ? Icons.directions_walk
                                  : Icons.directions_bike,
                              color: AppColors.palette_secondary,
                            ),
                            SizedBox(width: 8),
                            Text(
                              getWalkDifficultyTitle(),
                              style: TextStyle(
                                  color: AppColors.palette_secondary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            SvgPicture.asset(
                              AppIcons.euro,
                              height: 20,
                              colorFilter: ColorFilter.mode(
                                AppColors.palette_secondary,
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              walk.priceFormatted,
                              style: TextStyle(
                                  color: AppColors.palette_secondary,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          WalkData(
                            data: walk.trackDurationFormatted,
                            iconPath: AppIcons.time,
                          ),
                          WalkData(
                            data: walk.trackDistanceFormatted,
                            iconPath: AppIcons.distance,
                          ),
                          WalkData(
                            data: walk.slopeFormatted,
                            iconPath: AppIcons.angle,
                          ),
                          WalkData(
                            data: walk.upHillFormatted,
                            iconPath: AppIcons.upHill,
                          ),
                          WalkData(
                            data: walk.downHillFormatted,
                            iconPath: AppIcons.downHill,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class WalkData extends StatelessWidget {
  const WalkData({
    super.key,
    required this.data,
    required this.iconPath,
  });

  final String data;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          iconPath,
          height: 20,
          colorFilter: ColorFilter.mode(
            AppColors.palette_secondary,
            BlendMode.srcIn,
          ),
        ),
        Text(
          data,
          style: TextStyle(color: AppColors.palette_secondary),
        ),
      ],
    );
  }
}
