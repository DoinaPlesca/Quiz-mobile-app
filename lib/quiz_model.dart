//Data class for questions
class Question {
  final String text;
  final List<String> options;
  final String correct;
  String? answered;

  Question(this.text,
      {required this.options, required this.correct, this.answered});
}

/// A quiz is just a list of questions.
/// The `typedef` keyword means that `Quiz` becomes an alias for
/// `List<Question>`.

typedef Quiz = List<Question>;
