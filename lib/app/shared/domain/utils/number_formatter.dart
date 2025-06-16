String formatNumber(int number) {
  // . every 3 digits
  final numberString = number.toString();
  final buffer = StringBuffer();
  final length = numberString.length;
  for (int i = 0; i < length; i++) {
    if (i > 0 && (length - i) % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(numberString[i]);
  }
  return buffer.toString();
}
