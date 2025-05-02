import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:us_citizenship_friend/main.dart';
import 'package:us_citizenship_friend/models/questions_model.dart';

class PracticeTestPage extends StatefulWidget {
  const PracticeTestPage({super.key});

  @override
  PracticeTestPageState createState() => PracticeTestPageState();
}

class PracticeTestPageState extends State<PracticeTestPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final questionsModel = Provider.of<QuestionsModel>(context, listen: false);
      questionsModel.generateQuestion();
    });
  }

  // Hàm hiển thị popup xác nhận
  Future<bool?> _showExitConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit Quiz'),
        content: Text('Are you sure you want to exit the quiz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Hủy
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Xác nhận
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuestionsModel>(
      builder: (context, questionsModel, child) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container (
                    width: double.infinity,
                    padding: EdgeInsets.all(16), // Thêm padding cho nội dung
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 8), 
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 2),
                          child: GestureDetector(
                            onTap: () async{
                              final navigator = Navigator.of(context);
                              final shouldExit = await _showExitConfirmationDialog(context);
                              if (mounted && shouldExit == true) {
                                questionsModel.closeQuiz();
                                navigator.pushReplacement(
                                  MaterialPageRoute(builder: (context) => MyApp()),
                                );
                              } 
                            },
                            child: Icon(Icons.close, color: Colors.grey, size: 30),
                          )
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Learning Progress',
                                    style: TextStyle(fontSize: 13, color: Colors.black),
                                  ),
                                  Row (
                                    children: [
                                      Icon(Icons.book, color: Colors.black, size: 13),
                                      SizedBox(width: 5),
                                      Text(
                                        '${(questionsModel.currentQuestionIndex + 1)}/${questionsModel.questionsCurrent.length} Questions',
                                        style: TextStyle(fontSize: 13, color: Colors.black),
                                      ),
                                    ],
                                  )
                                ]
                              ),
                              SizedBox(height: 5),
                              Container(
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: LayoutBuilder(
                                  builder: (BuildContext context, BoxConstraints constraints) {
                                    final totalQuestions = questionsModel.questionsCurrent.length;
                                    final safeTotal = totalQuestions == 0 ? 1 : totalQuestions; // tránh chia 0
                                    final progress = (questionsModel.currentQuestionIndex + 1) / safeTotal;
                                    final progressWidth = constraints.maxWidth * progress;
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        width: progressWidth,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(100),
                                        ),
                                      )
                                    );
                                  }
                                )
                              )
                            ]
                          )
                        )

                      ]
                    )
                  ),

                  Text(
                    'Question ${questionsModel.currentQuestionIndex + 1}',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16), // Thêm padding cho nội dung
                    margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    constraints: BoxConstraints(
                      minHeight: 80, // Chiều cao tối thiểu
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF222f63), width: 2),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Column( // Sử dụng Column để hiển thị 2 dòng
                      crossAxisAlignment: CrossAxisAlignment.start, // Căn trái nội dung
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          questionsModel.questionsCurrent[questionsModel.currentQuestionIndex]['question'] ?? 'No question',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        )
                      ],
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16), // Thêm padding cho nội dung
                    margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    constraints: BoxConstraints(
                      minHeight: 250, // Chiều cao tối thiểu
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF222f63), width: 2),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Column( // Sử dụng Column để hiển thị 2 dòng
                      crossAxisAlignment: CrossAxisAlignment.start, // Căn trái nội dung
                      children: [
                        Text(
                          questionsModel.questionsCurrent[questionsModel.currentQuestionIndex]['answer_custom'] ?? 'No Answer',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        )
                      ],
                    ),
                  ),

                  // Rational
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 8),
                    padding: EdgeInsets.all(16), // Thêm padding cho nội dung
                    color: Colors.white,
                    constraints: BoxConstraints(
                      minHeight: 250, // Chiều cao tối thiểu
                    ),
                    child: Column( // Sử dụng Column để hiển thị 2 dòng
                      crossAxisAlignment: CrossAxisAlignment.start, // Căn trái nội dung
                      children: [
                        Text(
                          questionsModel.questionsCurrent[questionsModel.currentQuestionIndex]['detail'] ?? 'No detail',
                          style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic, color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: Color(0xFF222f63), // Màu nền của thanh bar
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (questionsModel.currentQuestionIndex > 0) 
                    GestureDetector(
                      onTap: () {
                        questionsModel.changeQuestion('prev');
                      },
                      child: Row(
                        children: [
                          Icon(Icons.chevron_left, size: 25, color: Colors.white),
                          SizedBox(width: 2),
                          Text(
                            'Previous',
                            style: TextStyle(color: Colors.white, fontSize: 18), // Biểu tượng mũi tên quay lại
                          )
                        ],
                      ),
                    ),
                  
                  SizedBox(width: 20),

                  if (questionsModel.currentQuestionIndex < questionsModel.questionsCurrent.length - 1)
                    GestureDetector(
                      onTap: () {
                        questionsModel.changeQuestion('next');
                      },
                      child: Row(
                        children: [
                          Text(
                            'Next',
                            style: TextStyle(color: Colors.white, fontSize: 18), // Biểu tượng mũi tên quay lại
                          ),
                          SizedBox(width: 2),
                          Icon(Icons.chevron_right, size: 25, color: Colors.white),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}