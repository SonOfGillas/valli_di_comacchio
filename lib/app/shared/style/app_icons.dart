// ignore_for_file: non_constant_identifier_names

class AppIcons {
  static final close = _iconPath('close');
  static final money = _iconPath('money');
  static final check = _iconPath('check');
  static final chevronLeftFilled = _iconPath('chevron_left_filled');
  static final chevronRightFilled = _iconPath('chevron_right_filled');
  static final logout = _iconPath('logout');
  static final save = _iconPath('save');
  static final unlock = _iconPath('unlock');
  static final userNormal = _iconPath('user_normal');
  static final visibilityOff = _iconPath('visibility_off');
  static final visibilityOn = _iconPath('visibility_on');
  static final warning = _iconPath('warning');
  static final info = _iconPath('info');
  static final email = _iconPath('email');

  static String _iconPath(String iconName) => 'assets/icons/$iconName.svg';
}
