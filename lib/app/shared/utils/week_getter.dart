class Week {
  const Week(this.startDate, this.endDate);

  final DateTime startDate;
  final DateTime endDate;
}

class WeekGetter {
  static Week getCurrentWeek() {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    final end = now.add(Duration(days: DateTime.daysPerWeek - now.weekday));
    return Week(start, end);
  }

  static Week getWeekAgo(int howManyWeeksAgo) {
    final now = DateTime.now();
    final start = now.subtract(
      Duration(
        days: now.weekday - 1 + (howManyWeeksAgo * DateTime.daysPerWeek),
      ),
    );
    final end = now.subtract(
      Duration(
        days: now.weekday + (howManyWeeksAgo - 1) * DateTime.daysPerWeek,
      ),
    );
    return Week(start, end);
  }
}
