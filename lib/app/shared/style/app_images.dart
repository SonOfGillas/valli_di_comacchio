// ignore_for_file: non_constant_identifier_names

class AppImages {
  static final logo = _iconPath('LOGO-comacchio');

  static final npcImagesFoulderName = 'npcs';
  static final rosario = _iconPath('$npcImagesFoulderName/rosario');
  static final eelena = _iconPath('$npcImagesFoulderName/eelena');
  static final pino = _iconPath('$npcImagesFoulderName/pino');
  static final alCarpone = _iconPath('$npcImagesFoulderName/al_carpone');
  static final quaQua = _iconPath('$npcImagesFoulderName/qua_qua');

  static String _iconPath(String iconName) => 'assets/images/$iconName.png';
}
