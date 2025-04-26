import 'package:flutter/material.dart';

class QuestionsModel with ChangeNotifier {
  List<dynamic> _questionsCurrent = [];
  // Map<String, dynamic> _questionsAfterShuffle = {};
  int currentQuestionIndex = 0;
  bool isShuffled = true;

  final Map<String, dynamic> _questionsList = {
    "PrinciplesOfAmericanDemocracy": [
      {
        "question": "What is the supreme law of the land?",
        "answer": "the Constitution",
        "answer_custom": "the Constitution",
        "detail": "The Constitution is the supreme law of the land. It establishes the framework for the government and protects the rights of citizens."
      },
      {
        "question": "What does the Constitution do?",
        "answer": [
          "sets up the government",
          "defines the government",
          "protects basic rights of Americans"
        ],
        "answer_custom": "sets up the government",
        "detail": "The Constitution sets up the government, defines its powers, and protects the basic rights of Americans."
      },
      {
        "question": "The idea of self-government is in the first three words of the Constitution. What are these words?",
        "answer": "We the People",
        "answer_custom": "We the People",
        "detail": "The first three words of the Constitution are 'We the People'. This phrase emphasizes that the government derives its power from the people."
      },
    ]
  };

  List<dynamic> get questionsCurrent => _questionsCurrent;
  int get currentQuestionIndexValue => currentQuestionIndex;

  QuestionsModel () {
    generateQuestion();
  }

  // void shuffleQuestions () {
  //   List<dynamic> q = _questionsList['PrinciplesOfAmericanDemocracy'];
    
  //   q.shuffle(Random());
  //   _questionsAfterShuffle = {
  //     "PrinciplesOfAmericanDemocracy": q
  //   };
  // }

  void changeQuestion(String nextPrev) {
    if (nextPrev == 'next') {
      currentQuestionIndex++;
    } else {
      currentQuestionIndex--;
    }
    debugPrint("Current Question Index: $currentQuestionIndex");
    notifyListeners();
  }

  void generateQuestion() {
    // if (isShuffled) {
    //   shuffleQuestions();
    //   _questionsCurrent = _questionsAfterShuffle['PrinciplesOfAmericanDemocracy'][currentQuestionIndex];
    // } else {
    //   _questionsCurrent = _questionsList['PrinciplesOfAmericanDemocracy'][currentQuestionIndex];
    // }
    currentQuestionIndex = 0;
    _questionsCurrent = _questionsList['PrinciplesOfAmericanDemocracy'];

    notifyListeners();
  }
}
