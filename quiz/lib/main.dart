import 'package:flutter/material.dart';

import 'quiz.dart';
import 'result.dart';

main() => runApp(App());

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _questions = const [
    {
      'questionText': 'What\'s your favorite color?',
      'answers': [
        {'text': 'Black', 'score': 10},
        {'text': 'Red', 'score': 5},
        {'text': 'Green', 'score': 3},
        {'text': 'White', 'score': 1},
      ],
    },
    {
      'questionText': 'What\'s your favorite animal?',
      'answers': [
        {'text': 'Rabbit', 'score': 3},
        {'text': 'Snake', 'score': 11},
        {'text': 'Elephant', 'score': 5},
        {'text': 'Lion', 'score': 9}
      ],
    },
    {
      'questionText': 'What\'s your favorite food?',
      'answers': [
        {'text': 'Cake', 'score': 4},
        {'text': 'Cookie', 'score': 1},
        {'text': 'Candy', 'score': 7},
        {'text': 'Jelly', 'score': 3}
      ],
    }
  ];
  int _questionIndex = 0;
  int _totalScore = 0;

  void _onAnswerQuestionPressed(int score) {
    _questionIndex += 1;

    setState(() {
      _totalScore += score;
    });
  }

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
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
          : Result(
              resultScore: _totalScore,
              resetHandler: _resetQuiz,
            ),
    ));
  }
}
