import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_cubit.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_state.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h1_on_primary/h1_on_primary.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/labelText.dart/label_text.dart';
import 'package:valli_di_comacchio/app/shared/core/routes/routes_paths.dart';
import 'package:valli_di_comacchio/app/shared/domain/utils/number_formatter.dart';
import 'package:valli_di_comacchio/app/shared/l10n/l10n.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';
import 'package:valli_di_comacchio/app/shared/style/app_icons.dart';

class ValliAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ValliAppBar({
    super.key,
    this.onBackPressed,
  });

  final VoidCallback? onBackPressed;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final path = GoRouterState.of(context).matchedLocation;

    String getTitle() {
      switch (path) {
        case RoutesPaths.trade:
          return l10n.tradePageTitle;
        case RoutesPaths.map:
          return l10n.mapPageTitle;
        case RoutesPaths.root:
        default:
          return '';
      }
    }

    bool showBackButton() {
      return path == RoutesPaths.trade;
    }

    goBack() {
      if (showBackButton()) {
        if (onBackPressed != null) {
          onBackPressed!();
        } else {
          context.pop();
        }
      }
    }

    return AppBar(
      leading: showBackButton()
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: AppColors.background_white),
              onPressed: () => goBack())
          : null,
      title: H1(getTitle()),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Column(
            children: [
              SvgPicture.asset(
                AppIcons.money,
                width: 30,
                height: 30,
                colorFilter: ColorFilter.mode(
                  AppColors.background_white,
                  BlendMode.srcIn,
                ),
              ),
              BlocBuilder<AppCubit, AppState>(
                builder: (context, state) {
                  return LabelText(
                    formatNumber(state.user?.wealth ?? 0),
                    withBoarder: true,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
