import 'package:flutter/material.dart';
import 'package:quiz/question.dart';

var questions = [
  'What\'s your favorite color?',
  'What\'s your favorite animal?',
  'What\'s your favorite food?'
];

main() => runApp(App());

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  var questionIndex = 0;

  void onAnswerQuestionPressed(int index) {
    setState(() {
      questionIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text('My First App'),
      ),
      body: Column(
        children: [
          Question(questions[questionIndex]),
          ElevatedButton(
            child: Text('Answer 1'),
            onPressed: () => onAnswerQuestionPressed(0),
          ),
          ElevatedButton(
            child: Text('Answer 2'),
            onPressed: () => onAnswerQuestionPressed(1),
          ),
          ElevatedButton(
            child: Text('Answer 3'),
            onPressed: () => onAnswerQuestionPressed(2),
          ),
        ],
      ),
    ));
  }
}
