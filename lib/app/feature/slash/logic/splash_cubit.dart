// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:valli_di_comacchio/app/feature/slash/logic/splash_state.dart';
// import 'package:valli_di_comacchio/app/shared/app_state/app_cubit.dart';
// import 'package:valli_di_comacchio/app/shared/core/error/failures/failures.dart';
// import 'package:valli_di_comacchio/app/shared/domain/repositories/user_repository.dart';
// import 'package:valli_di_comacchio/app/shared/utils/storage.dart';

// class SplashCubit extends Cubit<SplashState> {
//   SplashCubit({
//     required this.userRepository,
//     required this.appBloc,
//   }) : super(SplashLoading()) {
//     _checkInitialConfiguration();
//   }

//   final UserRepository userRepository;
//   final AppCubit appBloc;

//   Future<void> _checkInitialConfiguration() async {
//     emit(SplashLoading());

//     // load data or do the necessary checks;
//     try {
//       await appBloc.loadLocalUserData();
//       if (appBloc.state.user == null) {
//         emit(SplashSetupCompleted(loginFailed: true));
//         return;
//       } else {

//       }
//     } on Exception {
//       emit(SplashSetupCompleted(loginFailed: true));
//       return;
//     }

//     emit(
//       SplashSetupCompleted(
//         isUserPasswordExpired: _isUserPasswordExpired,
//       ),
//     );
//   }
// }
