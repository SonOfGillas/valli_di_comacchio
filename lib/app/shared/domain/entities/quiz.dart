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
  final String question;
  final List<Answer> answers;

  Quiz({required this.question, required this.answers});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    final answers =
        (json['answers'] as List).map((item) => Answer.fromJson(item)).toList();

    return Quiz(
      question: json['question'] as String,
      answers: answers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answers': answers.map((answer) => answer.toJson()).toList(),
    };
  }
}

const macroQuizThemes = [
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

const listOfQuizThemes = [
  'Storia: L\'antico Egitto',
  'Storia: L\'Impero Romano',
  'Storia: Le Crociate',
  'Storia: La Rivoluzione Francese',
  'Storia: La Seconda Guerra Mondiale',
  'Storia: Le grandi scoperte geografiche',
  'Storia: Le civiltà precolombiane',
  'Storia: La Guerra Fredda',
  'Storia: Le donne nella storia',
  'Storia: Italia nell\'alto medioevo',
  'Storia: Italia nel basso medioevo',
  'Storia: Italia nel Rinascimento',
  'Storia: Italia nell\'età moderna',
  'Storia: Unità d\'Italia',
  'Storia: Italia nell\'età contemporanea',
  'Geografia: Capitali del mondo',
  'Geografia: Montagne famose',
  'Geografia: I grandi fiumi della Terra',
  'Geografia: I deserti del mondo',
  'Geografia: Le isole più grandi',
  'Geografia: Confini e nazioni',
  'Geografia: Climi e biomi terrestri',
  'Geografia: Geografia dell’Italia',
  'Geografia: Oceani e mari',
  'Geografia: Le meraviglie naturali',
  'Geografia: Città italiane',
  'Geografia: Siti UNESCO in Italia',
  'Geografia: I vulcani attivi',
  'Geografia: Regioni italiane',
  'Geografia: Alpi',
  'Geografia: Appennini',
  'Arte: I grandi pittori del Rinascimento',
  'Arte: Correnti artistiche del Novecento',
  'Arte: Scultura classica',
  'Arte: I musei più famosi',
  'Arte: L\'arte astratta',
  'Arte: Architettura gotica e romanica',
  'Arte: Simbolismo e iconografia',
  'Scienza: Il sistema solare',
  'Scienza: Il corpo umano',
  'Scienza: Le invenzioni che hanno cambiato il mondo',
  'Scienza: Fisica base',
  'Scienza: Grandi scienziati della storia',
  'Scienza: Ecologia e sostenibilità',
  'Scienza: Genetica e DNA',
  'Sport: Storia delle Olimpiadi',
  'Sport: I Mondiali di Calcio',
  'Sport: Regole del basket',
  'Sport: Campioni del tennis',
  'Sport: Sport estremi',
  'Sport: Formula 1',
  'Sport: Sport invernali',
  'Sport: Sport tradizionali italiani',
  'Sport: Pesca',
  'Sport: Ciclismo',
  'Sport: Beach volley',
  'Musica: I grandi compositori classici',
  'Musica: Storia del rock',
  'Musica: Strumenti musicali',
  'Musica: Canzoni italiane famose',
  'Musica: Generi musicali',
  'Musica: Festival di sanremo',
  'Cultura Generale: Curiosità dal mondo',
  'Cultura Generale: Feste e tradizioni internazionali',
  'Cultura Generale: I cibi più strani',
  'Cultura Generale: Record Guinness',
  'Cultura Generale: Linguaggi e alfabeti',
  'Cultura Generale: Religioni del mondo',
  'Cultura Generale: Simboli e bandiere',
  'Cultura Generale: Costumi e abitudini',
  'Cultura Generale: Modi di dire e proverbi',
  'Cultura Generale: Invenzioni moderne',
  'Letteratura: Grandi romanzi della storia',
  'Letteratura: Letteratura italiana',
  'Letteratura: Premi Nobel per la letteratura',
  'Letteratura: Mitologia greca e romana',
  'Letteratura: Fiabe e favole',
  'Letteratura: Poesia del ‘900',
  'Cinema: Film vincitori degli Oscar',
  'Cinema: Colonne sonore iconiche',
  'Cinema: Cinema italiano',
  'Cinema: Film d’animazione',
  'Cinema: Attori e attrici celebri',
  'Animali Terrestri: Mammiferi',
  'Animali Terrestri: Rettili',
  'Animali Terrestri: Insetti',
  'Animali Terrestri: Uccelli',
  'Animali Terrestri: Felini e canidi',
  'Animali Terrestri: Mammiferi africani',
  'Animali Terrestri: Animali delle foreste',
  'Animali Terrestri: Predatori terrestri',
  'Animali Marini: Pesci',
  'Animali Marini: Mammiferi marini',
  'Animali Marini: Invertebrati marini',
  'Animali Marini: Anguille',
  'Animali Marini: Cetacei (balene e delfini)',
  'Animali Marini: Predatori del mare',
  'Animali Marini: Vita negli abissi'
      'Uccelli: Rapaci',
  'Uccelli: Uccelli migratori',
  'Uccelli: Uccelli esotici',
  'Uccelli: Uccelli acquatici',
  'Uccelli: Uccelli canori',
  'Uccelli: Uccelli di rapina',
  'Uccelli: Uccelli notturni',
  'Uccelli: Uccelli in via di estinzione',
  'Uccelli: Fenicotteri',
  'Piante: Piante medicinali',
  'Piante: Foreste pluviali',
  'Piante: Alberi monumentali',
  'Piante: Piante carnivore',
  'Piante: Fiori famosi',
  'Piante: Agricoltura e coltivazioni',
  'Piante: Piante velenose',
  'Curiosita sugli animali',
];
