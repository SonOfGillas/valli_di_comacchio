import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/auth/logic/auth_bloc.dart';
import 'package:valli_di_comacchio/app/feature/auth/presentation/auth_screen.dart';
import 'package:valli_di_comacchio/app/shared/core/dependecy_injection/injection_container.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => sl(),
      child: AuthScreen(),
    );
  }
}
