import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:valli_di_comacchio/app/shared/components/button/app_button_style.dart';
import 'package:valli_di_comacchio/app/shared/style/icon_models.dart';

class AppButton extends StatelessWidget {
  ///App standard button
  const AppButton({
    super.key,
    this.text = '',
    this.labelTextStyle,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.disabled = false,
    this.size = AppButtonSize.medium,
    required this.onClick,
    this.textDirection = TextDirection.rtl,
    this.image,
    this.coverHorizontalSpace = true,
  });

  ///OPTIONAL. Disables the button. Default: false
  final bool disabled;

  ///OPTIONAL. Changes button's size. Default: AppButtonSize.medium
  final AppButtonSize size;

  ///OPTIONAL. Changes button's style. Default: AppButtonVariant.primary
  final AppButtonVariant variant;

  ///OPTIONAL. The text shown in the button.
  final String text;

  ///OPTIONAL. label text style
  final TextStyle? labelTextStyle;

  ///OPTIONAL. The icon shown in the button.
  final String? icon;

  ///REQUIRED. OnClick callback function.
  final void Function() onClick;

  ///OPTIONAL. The direction text in the button
  final TextDirection textDirection;

  ///OPTIONAL. The image in the button
  final Image? image;

  ///OPTIONAL. define if the button try to conver all the space horizontally
  final bool coverHorizontalSpace;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle();
    final svgCol = _getSVGColors();
    final labelStyle = labelTextStyle ??
        TextStyle(fontWeight: FontWeight.bold, fontSize: size.fontSize);

    return SizedBox(
      height: size.buttonHeight,
      child: //if icon not defined
          (icon?.isEmpty ?? true)
              ? ElevatedButton(
                  onPressed: disabled ? null : onClick,
                  style: buttonStyle,
                  child: CoverHorizontalSpaceWidget(
                    coverHorizontalSpace: coverHorizontalSpace,
                    child: Text(text, style: labelStyle),
                  ),
                )
              : //if icon defined but no text
              (text.isEmpty)
                  ? ElevatedButton(
                      onPressed: disabled ? null : onClick,
                      style: buttonStyle,
                      child: CoverHorizontalSpaceWidget(
                        coverHorizontalSpace: coverHorizontalSpace,
                        child: SvgPicture.asset(
                          icon!,
                          colorFilter: disabled
                              ? ColorFilter.mode(
                                  svgCol.disabledColor,
                                  BlendMode.srcIn,
                                )
                              : ColorFilter.mode(
                                  svgCol.enabledColor,
                                  BlendMode.srcIn,
                                ),
                          width: size.iconSize,
                          height: size.iconSize,
                        ),
                      ),
                    )
                  : //if icon and text
                  Directionality(
                      textDirection: textDirection,
                      child: ElevatedButton.icon(
                        // <-- ElevatedButton
                        onPressed: disabled ? null : onClick,
                        icon: CoverHorizontalSpaceWidget(
                          coverHorizontalSpace: coverHorizontalSpace,
                          child: icon!.contains('png')
                              ? Image.asset(
                                  icon!,
                                  height: size.iconSize,
                                  width: size.iconSize,
                                )
                              : SvgPicture.asset(
                                  icon!,
                                  width: size.iconSize,
                                  height: size.iconSize,
                                  colorFilter: disabled
                                      ? ColorFilter.mode(
                                          svgCol.disabledColor,
                                          BlendMode.srcIn,
                                        )
                                      : ColorFilter.mode(
                                          svgCol.enabledColor,
                                          BlendMode.srcIn,
                                        ),
                                ),
                        ),
                        label: CoverHorizontalSpaceWidget(
                          coverHorizontalSpace: coverHorizontalSpace,
                          mainAxisAlignment: MainAxisAlignment.end,
                          child: Text(text, style: labelStyle),
                        ),
                        style: buttonStyle,
                      ),
                    ),
    );
  }

  ButtonStyle _getButtonStyle() {
    switch (variant) {
      case AppButtonVariant.primary:
        return primaryButtonStyle(disabled: disabled);
      case AppButtonVariant.secondary:
        return secondaryButtonStyle(disabled: disabled);
    }
  }

  SvgColorDef _getSVGColors() {
    switch (variant) {
      case AppButtonVariant.primary:
        return primarySvgColors();
      case AppButtonVariant.secondary:
        return secondarySvgColors();
    }
  }
}

class CoverHorizontalSpaceWidget extends StatelessWidget {
  const CoverHorizontalSpaceWidget({
    super.key,
    required this.child,
    required this.coverHorizontalSpace,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  final Widget child;
  final bool coverHorizontalSpace;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize:
          coverHorizontalSpace == false ? MainAxisSize.min : MainAxisSize.max,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        child,
      ],
    );
  }
}
