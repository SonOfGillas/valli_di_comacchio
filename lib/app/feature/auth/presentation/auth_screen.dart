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
              print(
                'AuthScreen: User logged in successfully',
              );
              // context.go(rootAfterLogin);
            },
            builder: (context, state) => Center(
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    H1(
                                      state.mode == AuthMode.login
                                          ? 'Effettua il login'
                                          : 'Registrati',
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
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
                                        padding: const EdgeInsets.only(top: 16),
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
                                          _togglePasswordVisibility(context),
                                      onChange: (value) => context
                                          .read<AuthBloc>()
                                          .add(PasswordEdit(password: value)),
                                    ),
                                    if (state.mode == AuthMode.register)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 16),
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
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: state.mode == AuthMode.login
                                            ? "Non hai un'account? "
                                            : "Hai già un'account? ",
                                        style: AppTextStyles.labelText,
                                        children: [
                                          TextSpan(
                                            text: state.mode == AuthMode.login
                                                ? 'Registrati'
                                                : 'Accedi',
                                            style: AppTextStyles.labelText
                                                .copyWith(
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                context.read<AuthBloc>().add(
                                                      const SwitchAccessMode(),
                                                    );
                                              },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    GlowingButton(
                                        text: 'Procedi',
                                        onPressed: () =>
                                            _onLoginButtonPressed(context)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ),
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
