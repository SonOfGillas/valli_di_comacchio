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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Card(
          color: AppColors.palette_primary,
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/walks/walks_1.png',
                    height: 130,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              H3(walk.name),
              DecoratedBox(
                decoration: BoxDecoration(color: AppColors.primary_light),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.directions_walk,
                          color: AppColors.palette_secondary,
                        ),
                        Text(
                          'Passeggiata facile',
                          style: TextStyle(color: AppColors.palette_secondary),
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
                        Text(
                          walk.priceFormatted,
                          style: TextStyle(color: AppColors.palette_secondary),
                        ),
                      ],
                    ),
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
