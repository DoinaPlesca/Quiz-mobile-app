import 'package:flutter/material.dart';
import 'package:quiz/quiz_model.dart';

class QuizScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizScreen({required this.quiz, super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool done = false;
  int index = 0;
  Quiz get questions => widget.quiz;

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[index];
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Quiz")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: _buildQuestion(context, currentQuestion),
          ),
          Expanded(
            child: Center(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _buildOptions(currentQuestion)),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildOptions(Question question) {
    return [
      for (final option in question.options)
        if (question.answered != option)
          OutlinedButton(
              onPressed: () => _onOptionPressed(option), child: Text(option))
        else
          FilledButton(
              onPressed: () => _onOptionPressed(option), child: Text(option))
    ];
  }

  _onOptionPressed(String answer) {
    setState(() {
      questions[index].answered = answer;
    });
  }

  Text _buildQuestion(BuildContext context, Question question) {
    return Text(question.text,
        style: Theme.of(context).textTheme.headlineLarge);
  }


}
