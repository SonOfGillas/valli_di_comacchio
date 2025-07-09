import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_cubit.dart';
import 'package:valli_di_comacchio/app/shared/components/appButton/glowing_button.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h3/h3.dart';
import 'package:valli_di_comacchio/app/shared/components/footer_nav_bar/footer_nav_bar.dart';
import 'package:valli_di_comacchio/app/shared/components/valli_app_bar/valli_app_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ValliAppBar(),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              H3('Profile'),
              GlowingButton(
                  text: 'enable dev mode',
                  onPressed: () {
                    context.read<AppCubit>().setDevMode(true);
                  }),
              GlowingButton(
                  text: 'disable dev mode',
                  onPressed: () {
                    context.read<AppCubit>().setDevMode(false);
                  })
            ],
          ),
        ),
        bottomNavigationBar: FooterNavBar());
  }
}
