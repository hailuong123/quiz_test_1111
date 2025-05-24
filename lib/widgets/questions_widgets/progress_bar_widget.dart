
import 'package:flutter/material.dart';
import 'package:us_citizenship_friend/main.dart';

class ProgressBarWidget extends StatefulWidget {
  final Function onCloseQuiz;
  final int currentQuestionIndex;
  final int totalQuestions;
  final double progress;

  const ProgressBarWidget({
    super.key, 
    required this.currentQuestionIndex,
    required this.progress,
    required this.totalQuestions,
    required this.onCloseQuiz
  });

  @override
  ProgressBarWidgetState createState() => ProgressBarWidgetState();
}


class ProgressBarWidgetState extends State<ProgressBarWidget> {

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
    return 
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
                    widget.onCloseQuiz();
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
                            '${widget.currentQuestionIndex}/${widget.totalQuestions} Questions',
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
                        final double progressWidth = constraints.maxWidth * widget.progress;
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300), // Thời gian cho animation
                            curve: Curves.easeOut, // Kiểu animation
                            width: progressWidth,
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
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
      );
  }
}