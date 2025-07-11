class Answer {
  final String answer;
  final bool correct;

  Answer({required this.answer, required this.correct});

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      answer: json['answer'] as String,
      correct: json['correct'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'answer': answer,
      'correct': correct,
    };
  }
}

class Quiz {
  final String message;
  final List<Answer> answers;

  Quiz({required this.message, required this.answers});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    final answers =
        (json['answers'] as List).map((item) => Answer.fromJson(item)).toList();

    return Quiz(
      message: json['message'] as String,
      answers: answers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'answers': answers.map((answer) => answer.toJson()).toList(),
    };
  }
}

const listOfQuizThemes = [
  'Storia',
  'Geografia',
  'Arte',
  'Scienza',
  'Sport',
  'Musica',
  'Cultura Generale',
  'Letteratura',
  'Cinema',
  'Tecnologia',
  'Animali Terrestri',
  'Animali Marini',
  'Uccelli',
  'Piante'
];
