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

  ///getters in Dart
  Quiz get questions => widget.quiz;

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[index];
    final number = index + 1;
    final total = questions.length;
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Quiz")),
      body: Column(
        children: [
          ..._buildProgress(number, total),

          /// arata la cate intrebari ai raspuns din cate 1/7 ori 3/7
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
      floatingActionButton: _buildActionButton(currentQuestion),
    );
  }

  ///access the current question
  ///display the text from parameter
  Text _buildQuestion(BuildContext context, Question question) {
    return Text(question.text,
        style: Theme.of(context).textTheme.headlineLarge);
  }

  ///Each question can have a different number of options.
  ///So we loop over the options.
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

  /// handle the onPressed event.
  /// The call to "setState" results in the UI being rebuilt
  _onOptionPressed(String answer) {
    setState(() {
      questions[index].answered = answer;
    });
  }

  ///button to progress through the questions
  ///When user is at the last question, we show a “Done” button instead of “Next”.
  Widget? _buildActionButton(Question currentQuestion) {
    if (done || currentQuestion.answered == null) return null;
    if (index < questions.length - 1) {
      return TextButton(onPressed: _onNextPressed, child: const Text("Next"));
    } else {
      return Builder(
        builder: (context) => TextButton(
            onPressed: () => _onDonePressed(context),
            child: const Text("Done")),
      );
    }
  }

  ///When the current question has been answered
  /// it will return a button allowing the user to progress.
  ///When the button is pressed, the index gets increased.
  /// It is done within a setState so the UI rebuilds.
  /// The first line in build() method retrieves the current question from the index.
  _onNextPressed() {
    if (index < questions.length - 1) {
      setState(() {
        index++;
      });
    }
  }

  ///It sets a new state for done,
  ///making the button disappear .
  ///Then it finds out if all questions have been answered correctly.
  _onDonePressed(BuildContext context) {
    setState(() {
      done = true;
    });
    final allCorrect =
    questions.every((element) => element.answered == element.correct);

    final controller = showModalBottomSheet(
        context: context,
        builder: (context) => _buildBottomSheet(context, allCorrect));

    controller.whenComplete(() {
      setState(() {
        index = 0;
        done = false;
      });
    });
  }

  ///build widgets for the bottom sheet.
  Widget _buildBottomSheet(BuildContext context, bool allCorrect) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      color: allCorrect ? Colors.green : Colors.red,
      width: double.infinity,
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(
                allCorrect
                    ? "Hurray 🥳, you are a true expert!"
                    : "😥 you can do better!",
                style: textTheme.headlineSmall),
          ])),
    );
  }

  ///user could follow their progress
  ///build progress indicator widgets
  List<Widget> _buildProgress(int number, int total) {
    return [
      LinearProgressIndicator(value: number / total),
      const SizedBox(height: 8),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [const Text('Question:'), Text('$number of $total')],
        ),
      ),
      const Divider(),
    ];
  }
}
