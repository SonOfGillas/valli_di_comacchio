// ignore_for_file: non_constant_identifier_names

class AppImages {
  static final logo = _iconPath('LOGO-comacchio');

  static final rosario = _iconPath('rosario');
  static final rosario_location = _iconPath('viale_dei_bilancioni');
  static final eelena = _iconPath('eelena');
  static final eelena_location = _iconPath('ponte_trepponti');
  static final pino = _iconPath('pino');
  static final pino_location = _iconPath('lido_di_spina');
  static final alCarpone = _iconPath('al_carpone');
  static final alCarpone_location = _iconPath('lido_degli_estensi');
  static final quaQua = _iconPath('qua_qua');
  static final quaQua_location = _iconPath('porto_garibaldi');

  static String _iconPath(String iconName) => 'assets/images/$iconName.png';
}
