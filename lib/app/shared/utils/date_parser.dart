class DateParser {
  /// Parses a date string in the format DD-MM-YYYY to a DateTime object.
  static DateTime parseDate(String dateString) {
    final dateParts = dateString.split('-');
    final rearrangedDateString =
        '${dateParts[2]}-${dateParts[1]}-${dateParts[0]}';
    return DateTime.parse(rearrangedDateString);
  }
}
