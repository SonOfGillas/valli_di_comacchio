import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:valli_di_comacchio/app/feature/slash/logic/splash_cubit.dart';
import 'package:valli_di_comacchio/app/feature/slash/logic/splash_state.dart';
import 'package:valli_di_comacchio/app/shared/core/dependecy_injection/injection_container.dart';
import 'package:valli_di_comacchio/app/shared/core/routes/routes_paths.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';
import 'package:valli_di_comacchio/app/shared/style/app_images.dart';

class SlashScreen extends StatefulWidget {
  const SlashScreen({super.key});

  @override
  State<SlashScreen> createState() => _SlashScreenState();
}

class _SlashScreenState extends State<SlashScreen> {
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashCubit>(
      create: (context) => sl<SplashCubit>(),
      child: BlocListener<SplashCubit, SplashState>(
        listenWhen: (context, state) {
          return state is SplashSetupCompleted;
        },
        listener: (context, state) {
          if (state is SplashSetupCompleted) {
            // Navigate based on login status
            if (state.loginFailed) {
              context.go(RoutesPaths.auth);
            } else {
              context.go(rootAfterLogin);
            }
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.palette_secondary,
          body: Center(
            child: Image.asset(
              AppImages.logo,
              height: 200,
            ),
          ),
        ),
      ),
    );
  }
}
