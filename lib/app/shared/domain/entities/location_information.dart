class SubLocationOrActivity {
  final String name;
  final List<DateTime> opening; // 7 values one for each day of the week
  final List<DateTime> closing;
  final String description;
  final Uri? infoUrl;

  SubLocationOrActivity({
    required this.name,
    required this.opening,
    required this.closing,
    required this.description,
    this.infoUrl,
  });

  factory SubLocationOrActivity.fromJson(Map<String, dynamic> json) {
    final opening = (json['opening'] as List)
        .map((item) => DateTime.fromMillisecondsSinceEpoch(item as int))
        .toList();
    final closing = (json['closing'] as List)
        .map((item) => DateTime.fromMillisecondsSinceEpoch(item as int))
        .toList();
    return SubLocationOrActivity(
      name: json['name'] as String,
      opening: opening,
      closing: closing,
      description: json['description'] as String,
      infoUrl:
          json['infoUrl'] != null ? Uri.parse(json['infoUrl'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'opening': opening.map((dt) => dt.millisecondsSinceEpoch).toList(),
      'closing': closing.map((dt) => dt.millisecondsSinceEpoch).toList(),
      'description': description,
      'infoUrl': infoUrl?.toString(),
    };
  }
}

class LocationInformation {
  final String name;
  final String imagePath;
  final String description;
  final List<SubLocationOrActivity> subLocationsOrActivities;

  LocationInformation({
    required this.name,
    required this.imagePath,
    required this.description,
    required this.subLocationsOrActivities,
  });

  factory LocationInformation.fromJson(Map<String, dynamic> json) {
    return LocationInformation(
      name: json['name'] as String,
      imagePath: json['imagePath'] as String,
      description: json['description'] as String,
      subLocationsOrActivities: (json['subLocationsOrActivities'] as List)
          .map((item) => SubLocationOrActivity.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imagePath': imagePath,
      'description': description,
      'subLocationsOrActivities':
          subLocationsOrActivities.map((item) => item.toJson()).toList(),
    };
  }
}
