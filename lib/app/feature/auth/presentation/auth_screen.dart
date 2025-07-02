import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:valli_di_comacchio/app/feature/auth/logic/auth_bloc.dart';
import 'package:valli_di_comacchio/app/feature/auth/logic/auth_event.dart';
import 'package:valli_di_comacchio/app/feature/auth/logic/auth_state.dart';
import 'package:valli_di_comacchio/app/shared/components/alert/app_alert.dart';
import 'package:valli_di_comacchio/app/shared/components/alert/app_alert_style.dart';
import 'package:valli_di_comacchio/app/shared/components/appButton/glowing_button.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h1_on_primary/h1_on_primary.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h3/h3.dart';
import 'package:valli_di_comacchio/app/shared/components/text_field/app_textfield.dart';
import 'package:valli_di_comacchio/app/shared/components/text_field/app_textfield_style.dart';
import 'package:valli_di_comacchio/app/shared/core/routes/routes_paths.dart';
import 'package:valli_di_comacchio/app/shared/l10n/l10n.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';
import 'package:valli_di_comacchio/app/shared/style/app_icons.dart';
import 'package:valli_di_comacchio/app/shared/style/app_images.dart';
import 'package:valli_di_comacchio/app/shared/style/app_text_style.dart';

const emailFieldKey = ValueKey('email');
const usernameFieldKey = ValueKey('username');
const passwordFieldKey = ValueKey('password');
const repeatPasswordFieldKey = ValueKey('repeatPassword');

class AuthScreen extends StatelessWidget {
  const AuthScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    String getTitle(AuthMode mode) {
      switch (mode) {
        case AuthMode.login:
          return "Effettua il login";
        case AuthMode.register:
          return "Registrati";
        case AuthMode.guest:
          return "Continua come ospite";
      }
    }

    return Scaffold(
      backgroundColor: AppColors.palette_secondary,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listenWhen: (previous, current) =>
              previous.failure != current.failure,
          listener: (context, state) {
            if (state.failure != null) {
              AppAlert.show(
                context,
                state.failure?.message() ??
                    l10n.commonErrorUnknownFailureMessage,
                variant: AppAlertVariant.error,
              );
            }
          },
          child: BlocConsumer<AuthBloc, AuthState>(
              listenWhen: (previous, current) =>
                  current.status == AuthStatus.succeeded,
              listener: (context, state) {
                context.go(rootAfterLogin);
              },
              builder: (context, state) {
                final title = getTitle(state.mode);
                return Center(
                  child: state.status == AuthStatus.loading
                      ? const CircularProgressIndicator()
                      : Container(
                          constraints: const BoxConstraints(maxWidth: 800),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Form(
                              child: CustomScrollView(
                                physics: const ClampingScrollPhysics(),
                                slivers: [
                                  SliverFillRemaining(
                                    hasScrollBody: false,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          height: 40,
                                        ),
                                        Image.asset(
                                          AppImages.logo,
                                          height: 160,
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        H1(title),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        if (state.mode != AuthMode.guest)
                                          AppTextField(
                                            key: emailFieldKey,
                                            placeHolder: "email",
                                            leftIcon: AppIcons.email,
                                            onChange: (value) => context
                                                .read<AuthBloc>()
                                                .add(EmailEdit(email: value)),
                                          ),
                                        if (state.mode == AuthMode.register)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 16),
                                            child: AppTextField(
                                              key: usernameFieldKey,
                                              placeHolder: "nome utente",
                                              leftIcon: AppIcons.userNormal,
                                              onChange: (value) => context
                                                  .read<AuthBloc>()
                                                  .add(UsernameEdit(
                                                      username: value)),
                                            ),
                                          ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        if (state.mode != AuthMode.guest)
                                          AppTextField(
                                            key: passwordFieldKey,
                                            placeHolder: l10n.loginPasswordHint,
                                            type: state.showPassword
                                                ? AppTextFieldType.text
                                                : AppTextFieldType.password,
                                            leftIcon: AppIcons.unlock,
                                            rightIconPadding: 12,
                                            rightIcon: state.showPassword
                                                ? AppIcons.visibilityOn
                                                : AppIcons.visibilityOff,
                                            onRightIconTap: () =>
                                                _togglePasswordVisibility(
                                                    context),
                                            onChange: (value) => context
                                                .read<AuthBloc>()
                                                .add(PasswordEdit(
                                                    password: value)),
                                          ),
                                        if (state.mode == AuthMode.register)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 16),
                                            child: AppTextField(
                                              key: repeatPasswordFieldKey,
                                              placeHolder: "ripeti la password",
                                              type: state.showPassword
                                                  ? AppTextFieldType.text
                                                  : AppTextFieldType.password,
                                              leftIcon: AppIcons.unlock,
                                              rightIconPadding: 12,
                                              rightIcon: state.showPassword
                                                  ? AppIcons.visibilityOn
                                                  : AppIcons.visibilityOff,
                                              onRightIconTap: () =>
                                                  _togglePasswordVisibility(
                                                      context),
                                              onChange: (value) => context
                                                  .read<AuthBloc>()
                                                  .add(RepeatPasswordEdit(
                                                      repeatPassword: value)),
                                            ),
                                          ),
                                        if (state.mode == AuthMode.guest)
                                          const GuestPage(),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        if (state.mode != AuthMode.guest)
                                          RichText(
                                            text: TextSpan(
                                              text: "Non vuoi registrarti? ",
                                              style: AppTextStyles.labelText,
                                              children: [
                                                TextSpan(
                                                  text: "accedi come ospite",
                                                  style: AppTextStyles.labelText
                                                      .copyWith(
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          context
                                                              .read<AuthBloc>()
                                                              .add(
                                                                const GoToGuest(),
                                                              );
                                                        },
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (state.mode != AuthMode.guest)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: RichText(
                                              text: TextSpan(
                                                text: state.mode ==
                                                        AuthMode.login
                                                    ? "Non hai un'account? "
                                                    : "Hai già un'account? ",
                                                style: AppTextStyles.labelText,
                                                children: [
                                                  TextSpan(
                                                    text: state.mode ==
                                                            AuthMode.login
                                                        ? 'Registrati'
                                                        : 'Accedi',
                                                    style: AppTextStyles
                                                        .labelText
                                                        .copyWith(
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = () {
                                                            context
                                                                .read<
                                                                    AuthBloc>()
                                                                .add(
                                                                  state.mode ==
                                                                          AuthMode
                                                                              .login
                                                                      ? const GoToRegister()
                                                                      : const GoToLogin(),
                                                                );
                                                          },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        if (state.mode != AuthMode.guest)
                                          const Spacer(),
                                        if (state.mode != AuthMode.guest)
                                          GlowingButton(
                                              text: 'Procedi',
                                              onPressed: () =>
                                                  _onLoginButtonPressed(
                                                      context)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                );
              }),
        ),
      ),
    );
  }

  void _onLoginButtonPressed(BuildContext context) {
    context.read<AuthBloc>().add(
          const MainButtonPressed(),
        );
  }

  void _togglePasswordVisibility(BuildContext context) {
    context.read<AuthBloc>().add(
          TogglePasswordIconPressed(),
        );
  }
}

class GuestPage extends StatelessWidget {
  const GuestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          GlowingButton(
            text: 'Ospite',
            onPressed: () =>
                context.read<AuthBloc>().add(const GuestModeSelected()),
          ),
          const SizedBox(height: 42),
          H3("Hai già un'account?"),
          const SizedBox(height: 8),
          GlowingButton(
            text: 'Accedi',
            onPressed: () => context.read<AuthBloc>().add(const GoToLogin()),
          ),
          const SizedBox(height: 20),
          H3("Non hai un'account?"),
          const SizedBox(height: 8),
          GlowingButton(
            text: 'Registrati',
            onPressed: () => context.read<AuthBloc>().add(const GoToRegister()),
          ),
        ],
      ),
    );
  }
}
