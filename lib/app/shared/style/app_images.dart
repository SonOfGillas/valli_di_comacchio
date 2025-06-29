// ignore_for_file: non_constant_identifier_names

class AppImages {
  static final logo = _iconPath('LOGO-comacchio');

  static final rosario = _iconPath('rosario');
  static final eelena = _iconPath('eelena');
  static final pino = _iconPath('pino');
  static final alCarpone = _iconPath('al_carpone');
  static final quaQua = _iconPath('qua_qua');

  static String _iconPath(String iconName) => 'assets/images/$iconName.png';
}
