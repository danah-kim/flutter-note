import 'package:flutter/material.dart';
import './answer.dart';
import './question.dart';

class Quize extends StatelessWidget {
  final List<Map<String, Object>> questions;
  final int questionIndex;
  final void Function(int score) answerQuestion;

  const Quize({
    required this.questions,
    required this.questionIndex,
    required this.answerQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Question(questions[questionIndex]['questionText'] as String),
        ...(questions[questionIndex]['answers'] as List<Map<String, Object>>)
            .map((answer) => Answer(answer['text'] as String,
                () => answerQuestion(answer['score'] as int)))
            .toList()
      ],
    );
  }
}
