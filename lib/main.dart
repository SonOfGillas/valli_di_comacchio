import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_cubit.dart';
import 'package:valli_di_comacchio/app/shared/core/dependecy_injection/injection_container.dart';
import 'package:valli_di_comacchio/bootstrap.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

void main() {
  bootstrap(
    () => BlocProvider<AppCubit>(
      create: (context) => sl(),
      child: const App(),
    ),
  );
}
