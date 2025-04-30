import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/shared/core/routes/routes.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';
import 'package:valli_di_comacchio/app/shared/l10n/app_translations.dart';
import 'package:valli_di_comacchio/app/shared/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: AppColors.palette_primary),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('it'),
      builder: (context, child) {
        AppTranslations.init(context);
        // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        //   AppAlert.show(
        //     context,
        //     '''
        //   ${message.notification?.title ?? ''}
        //   ${message.notification?.body ?? ''}
        //   ''',
        //   );
        // });
        // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        //   router.replace(RoutesPaths.home);
        // });
        return child ?? const Text('Missin');
      },
    );
  }
}
