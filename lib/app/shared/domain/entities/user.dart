class User {
  const User({
    required this.code,
    required this.email,
    required this.name,
    required this.surname,
  });

  final String code;
  final String email;
  final String name;
  final String surname;

  // fama? relazioni npc

  Map<String, dynamic> toJson() => {
        'code': code,
        'email': email,
        'name': name,
        'surname': surname,
      };
}
