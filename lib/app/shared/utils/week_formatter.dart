import 'package:valli_di_comacchio/app/shared/utils/week_getter.dart';

class DateFormatter {
  static String format(DateTime date) {
    return '${date.day}/${date.month}';
  }

  static String formatWithHour(DateTime date) {
    return '${date.day}/${date.month}    ${date.hour}:${date.minute}';
  }

  static String weekFormatter(Week week) {
    return '${DateFormatter.format(week.startDate)} - ${DateFormatter.format(week.endDate)}';
  }
}
