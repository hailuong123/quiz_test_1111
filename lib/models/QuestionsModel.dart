import 'package:flutter/material.dart';

class QuestionsModel with ChangeNotifier {
  String _questionsCurrent = '';

  final _questionsList = ["Quest 1","2"];

  String get questionsCurrent => _questionsCurrent;

  QuestionsModel () {
    generateQuestion();
  }

  void generateQuestion() {
    _questionsCurrent = _questionsList[0];
    notifyListeners();
  }

}