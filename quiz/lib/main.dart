import 'package:flutter/material.dart';
import './quiz.dart';
import './result.dart';

main() => runApp(App());

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _questions = const [
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
  int _questionIndex = 0;

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
      body: _questionIndex < _questions.length
          ? Quize(
              questions: _questions,
              questionIndex: _questionIndex,
              answerQuestion: _onAnswerQuestionPressed,
            )
          : Result(),
    ));
  }
}
