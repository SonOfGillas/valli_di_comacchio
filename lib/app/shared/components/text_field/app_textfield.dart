import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:valli_di_comacchio/app/shared/components/text_field/app_textfield_style.dart';
import 'package:valli_di_comacchio/app/shared/style/app_text_style.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.placeHolder,
    this.type = AppTextFieldType.text,
    this.labelPosition = AppTextFieldLabelPosition.left,
    this.labelStyle = AppTextFieldLabelStyle.normal,
    this.variant = AppTextFieldVariant.standard,
    this.disabled = false,
    this.readOnly = false,
    this.label,
    this.controller,
    this.rightIcon,
    this.leftIcon,
    this.leftIconColor,
    this.leftIconPadding,
    this.rightIconColor,
    this.rightIconPadding,
    this.onRightIconTap,
    this.errorMessage,
    this.onChange,
    this.onSubmit,
    this.height,
    this.placeholderStyle,
    this.maxLength,
    this.focusNode,
  });

  ///OPTIONAL. The label to show. Default: null
  final String? label;

  ///OPTIONAL. The placeHolder to show. Default: null
  final String? placeHolder;

  ///OPTIONAL. The placeholder style if the placeholder is defined. Default: AppTextStyles.headingLevel3RegularGrey60C.copyWith(color: AppColors.gray30)
  final TextStyle? placeholderStyle;

  ///OPTIONAL. The message to show in case of failing validation. Default: null
  final String? errorMessage;

  ///OPTIONAL. The label style if the label is defined. Default: AppTextFieldLabelStyle.normal
  final AppTextFieldLabelStyle labelStyle;

  ///OPTIONAL. The textfield type. Default: AppTextFieldLabelType.text
  final AppTextFieldType type;

  ///OPTIONAL. The textfield variant. Default: AppTextFieldLabelVariant.standard
  final AppTextFieldVariant variant;

  ///OPTIONAL. The label position if the label is defined. Default: AppTextFieldLabelPosition.left
  final AppTextFieldLabelPosition labelPosition;

  ///OPTIONAL. Disables the textfield. Default: false
  final bool disabled;

  ///OPTIONAL. Disables input. Default: false
  final bool readOnly;

  ///OPTIONAL. Textfield's left icon
  final String? leftIcon;

  ///OPTIONAL. Textfield's left icon's color
  final Color? leftIconColor;

  ///OPTIONAL. Textfield's left icon's padding
  final double? leftIconPadding;

  ///OPTIONAL. Textfield's right icon
  final String? rightIcon;

  ///OPTIONAL. Textfield's right icon's color
  final Color? rightIconColor;

  ///OPTIONAL. Textfield's right icon's padding
  final double? rightIconPadding;

  ///OPTIONAL. Callback invoked when the right icon is pressed
  final VoidCallback? onRightIconTap;

  ///OPTIONAL. Validation controller
  final TextEditingController? controller;

  ///OPTIONAL. OnChange callback
  final void Function(String)? onChange;

  ///OPTIONAL. OnSubmit callback
  final void Function(String)? onSubmit;

  ///OPTIONAL. Textfield's height
  final double? height;

  ///OPTIONAL. Textfield's max num of characters
  final int? maxLength;

  final FocusNode? focusNode;

  static const double conententLeftPadding = 16;

  @override
  Widget build(BuildContext context) {
    final lblStyle = _getLabelStyle(labelStyle);

    final getKeyboardType = () {
      switch (type) {
        case AppTextFieldType.text:
          return TextInputType.text;
        case AppTextFieldType.number:
          return TextInputType.number;
        case AppTextFieldType.password:
          return TextInputType.visiblePassword;
        case AppTextFieldType.textArea:
          return TextInputType.multiline;
      }
    }();

    final textfield = SizedBox(
      height: height,
      child: TextField(
        maxLength: maxLength,
        keyboardType: getKeyboardType,
        obscureText: type == AppTextFieldType.password,
        maxLines: type == AppTextFieldType.textArea ? 4 : 1,
        enabled: !disabled,
        onChanged: (val) => onChange?.call(val),
        onSubmitted: (val) => onSubmit?.call(val),
        readOnly: readOnly,
        controller: controller,
        style: AppTextStyles.labelText,
        textAlign: type == AppTextFieldType.number
            ? TextAlign.center
            : TextAlign.start,
        decoration: InputDecoration(
          //isDense: true,
          contentPadding: EdgeInsets.only(
            left: type == AppTextFieldType.number ? 0 : conententLeftPadding,
            right: type == AppTextFieldType.textArea ? conententLeftPadding : 0,
            top: type == AppTextFieldType.textArea ? 20 : 0,
          ),
          filled: variant == AppTextFieldVariant.filled ||
              variant == AppTextFieldVariant.standard,
          fillColor: variant == AppTextFieldVariant.filled
              ? AppTextFieldColors.fill
              : AppTextFieldColors.background,
          prefixIcon: (!(leftIcon?.isEmpty ?? true))
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(leftIconPadding ?? 8),
                      child: SvgPicture.asset(
                        leftIcon!,
                        width: 34,
                        height: 34,
                        colorFilter: ColorFilter.mode(
                          leftIconColor ?? AppTextFieldColors.leftIcon,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(width: conententLeftPadding),
                  ],
                )
              : null, // otherwise default padding is applied,
          suffixIcon: (!(rightIcon?.isEmpty ?? true))
              ? Padding(
                  padding: EdgeInsets.all(rightIconPadding ?? 8),
                  child: SvgPicture.asset(
                    rightIcon!,
                    width: 34,
                    height: 34,
                    colorFilter: ColorFilter.mode(
                      rightIconColor ?? AppTextFieldColors.rightIcon,
                      BlendMode.srcIn,
                    ),
                  ),
                )
              : null,
          border: const OutlineInputBorder(
            borderRadius: appTextFieldBorderRadius,
            borderSide: BorderSide(
                width: appTextFieldBorderWidth,
                color: AppTextFieldColors.border),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: appTextFieldBorderRadius,
            borderSide: BorderSide(
                width: appTextFieldBorderWidth,
                color: AppTextFieldColors.border),
          ),
          hintText: placeHolder,
          hintStyle: placeholderStyle ?? textFieldPlaceHolderStyle,
          errorText: errorMessage,
          errorBorder: const OutlineInputBorder(
            borderRadius: appTextFieldBorderRadius,
            borderSide: BorderSide(
                width: appTextFieldBorderWidth,
                color: AppTextFieldColors.borderError),
          ),
          counterText: '',
        ),
        focusNode: focusNode,
      ),
    );

    return SizedBox(
      width: type == AppTextFieldType.number ? 60 : double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: (label?.isEmpty ?? true)
            ? <Widget>[Expanded(child: textfield)]
            : labelPosition == AppTextFieldLabelPosition.top
                ? <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 3),
                            child: Text(label!, style: lblStyle),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: textfield,
                          ),
                        ],
                      ),
                    ),
                  ]
                : <Widget>[
                    Text(label!, style: lblStyle),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: textfield,
                      ),
                    ),
                  ],
      ),
    );
  }

  TextStyle _getLabelStyle(AppTextFieldLabelStyle lStyle) {
    switch (lStyle) {
      case AppTextFieldLabelStyle.normal:
        return normalLabelStyle;
      case AppTextFieldLabelStyle.bold:
        return boldLabelStyle;
      case AppTextFieldLabelStyle.italics:
        return italicsLabelStyle;
      case AppTextFieldLabelStyle.boldItalics:
        return boldItalicsLabelStyle;
    }
  }
}
