import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_cubit.dart';
import 'package:valli_di_comacchio/app/shared/core/routes/routes_paths.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/user.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

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

    // Navigate to the home page after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go(RoutesPaths.map);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO REMOVE MOCK USER AUTHENTICATION
    final appCubit = context.read<AppCubit>();
    appCubit.setLocalUser(
        User(
            id: 'user_id',
            email: 'user@example.com',
            name: 'John',
            surname: 'Doe'),
        'password');
    ///////////////////////////////////////////

    return const Scaffold(
      backgroundColor: AppColors.palette_secondary,
      body: SizedBox.expand(),
    );
  }
}
