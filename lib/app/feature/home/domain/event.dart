class Event {
  final String title;
  final String imageFileName;
  final String description;
  final String program;
  final List<DateTime> days;
  final String contacts;

  Event({
    required this.title,
    required this.imageFileName,
    required this.description,
    required this.program,
    required this.days,
    required this.contacts,
  });

  Event.fromMap(Map<String, dynamic> map)
      : title = map['title'] as String,
        imageFileName = 'assets/events/${map['imageFileName'] as String}',
        description = map['description'] as String,
        program = map['program'] as String,
        days = (map['days'] as List)
            .map((day) => DateTime.fromMillisecondsSinceEpoch(
                day.millisecondsSinceEpoch as int))
            .toList(),
        contacts = map['contacts'] as String;
}
