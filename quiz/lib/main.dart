import 'package:flutter/material.dart';
import 'package:quiz/answer.dart';
import 'package:quiz/question.dart';

main() => runApp(App());

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final questions = const [
    {
      'questionText': 'What\'s your favorite color?',
      'answers': ['Black', 'Red', 'Green', 'White'],
    },
    {
      'questionText': 'What\'s your favorite animal?',
      'answers': ['Rabbit', 'Snake', 'Elephant', 'Lion'],
    },
    {
      'questionText': 'What\'s your favorite food?',
      'answers': ['Cake', 'Cookie', 'Candy', 'Jelly'],
    }
  ];
  var _questionIndex = 0;

  void _onAnswerQuestionPressed() {
    setState(() {
      _questionIndex += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text('My First App'),
      ),
      body: _questionIndex < questions.length
          ? Column(
              children: [
                Question(questions[_questionIndex]['questionText'] as String),
                ...(questions[_questionIndex]['answers'] as List<String>)
                    .map((answer) => Answer(answer, _onAnswerQuestionPressed))
                    .toList()
              ],
            )
          : Center(
              child: Text('You did it!'),
            ),
    ));
  }
}
