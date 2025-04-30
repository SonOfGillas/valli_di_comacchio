import 'dart:ui';

class SvgColorDef {
  SvgColorDef({
    required this.enabledColor,
    required this.disabledColor,
  });
  Color enabledColor;
  Color disabledColor;
}

class IconDef {
  IconDef({
    required this.enabledIcon,
    required this.disabledIcon,
  });
  String enabledIcon;
  String disabledIcon;
}
