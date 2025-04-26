import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:us_citizenship_friend/models/questions_model.dart';

class PracticeTestPage extends StatelessWidget {
  const PracticeTestPage({super.key});

  @override
  Widget build(BuildContext context) {

    final questionsModel = Provider.of<QuestionsModel>(context);
    int currentQuestionIndex = questionsModel.currentQuestionIndexValue;
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container (
                width: double.infinity,
                padding: EdgeInsets.all(16), // Thêm padding cho nội dung
                margin: EdgeInsets.fromLTRB(0, 0, 0, 8), 
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Learning Progress',
                          style: TextStyle(fontSize: 13, color: Colors.black),
                        ),
                        Row(
                          children: [
                            Icon(Icons.book, color: Colors.black, size: 13),
                            SizedBox(width: 5),
                            Text(
                              '${currentQuestionIndex + 1}/${questionsModel.questionsCurrent.length} Questions',
                              style: TextStyle(fontSize: 13, color: Colors.black),
                            )
                          ],
                        ),
                        
                      ]
                    ),
                    Container(
                      height: 5,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 0),
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          double progressWidth = constraints.maxWidth * (currentQuestionIndex + 1) / questionsModel.questionsCurrent.length; // 80% chiều rộng
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
                        },
                      )
                    )
                  ]
                )
              ),

              Text(
                'Question ${currentQuestionIndex + 1}',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16), // Thêm padding cho nội dung
                margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                constraints: BoxConstraints(
                  minHeight: 100, // Chiều cao tối thiểu
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF222f63), width: 2),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Column( // Sử dụng Column để hiển thị 2 dòng
                  crossAxisAlignment: CrossAxisAlignment.start, // Căn trái nội dung
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      questionsModel.questionsCurrent[currentQuestionIndex]['question'] ?? 'No question',
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
                      questionsModel.questionsCurrent[currentQuestionIndex]['answer_custom'] ?? 'No Answer',
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
                      questionsModel.questionsCurrent[currentQuestionIndex]['detail'] ?? 'No detail',
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
  }
}