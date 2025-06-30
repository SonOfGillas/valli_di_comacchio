import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:valli_di_comacchio/app/shared/core/routes/routes_paths.dart';
import 'package:valli_di_comacchio/app/shared/style/app_icons.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

class FooterNavBar extends StatelessWidget {
  const FooterNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).matchedLocation;

    int selectedIndex() {
      if (path == RoutesPaths.quest) {
        return 0;
      } else if (path == RoutesPaths.walksAndPlaces) {
        return 1;
      } else if (path == RoutesPaths.map) {
        return 2;
      } else if (path == RoutesPaths.cards) {
        return 3;
      } else if (path == RoutesPaths.profile) {
        return 4;
      }
      return 5;
    }

    return Container(
      color: AppColors.palette_primary,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _FooterNavItem(
            icon: SvgPicture.asset(
              AppIcons.quest,
              height: 40,
              colorFilter:
                  ColorFilter.mode(AppColors.palette_tertiary, BlendMode.srcIn),
            ),
            index: 0,
            selectedIndex: selectedIndex(),
            onTap: (int _) => context.go(RoutesPaths.quest),
          ),
          _FooterNavItem(
            icon: SvgPicture.asset(
              AppIcons.walksAndPlaces,
              height: 40,
              colorFilter:
                  ColorFilter.mode(AppColors.palette_tertiary, BlendMode.srcIn),
            ),
            index: 1,
            selectedIndex: selectedIndex(),
            onTap: (int _) => context.go(RoutesPaths.walksAndPlaces),
          ),
          _FooterNavItem(
            icon: SvgPicture.asset(
              AppIcons.map,
              height: 40,
              colorFilter:
                  ColorFilter.mode(AppColors.palette_tertiary, BlendMode.srcIn),
            ),
            index: 2,
            selectedIndex: selectedIndex(),
            onTap: (int _) => context.go(RoutesPaths.map),
          ),
          _FooterNavItem(
            icon: SvgPicture.asset(
              AppIcons.cards,
              height: 40,
              colorFilter:
                  ColorFilter.mode(AppColors.palette_tertiary, BlendMode.srcIn),
            ),
            index: 3,
            selectedIndex: selectedIndex(),
            onTap: (int _) => context.go(RoutesPaths.cards),
          ),
          _FooterNavItem(
            icon: const Icon(Icons.person,
                size: 40, color: AppColors.palette_tertiary),
            index: 4,
            selectedIndex: selectedIndex(),
            onTap: (int _) => context.go(RoutesPaths.profile),
          ),
        ],
      ),
    );
  }
}

class _FooterNavItem extends StatelessWidget {
  final Widget icon;
  final int index;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _FooterNavItem({
    required this.icon,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selectedIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Opacity(
        opacity: isSelected ? 1.0 : 0.6,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: icon,
        ),
      ),
    );
  }
}
