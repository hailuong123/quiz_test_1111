import 'package:flutter/material.dart';
import 'package:us_citizenship_friend/main.dart';

class PracticeTestFlashCardPage extends StatelessWidget {
  const PracticeTestFlashCardPage({super.key});


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
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                        if (shouldExit == true) { // đang thiếu mounted check
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
                                  '15/100 Questions',
                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                )
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
                              double progressWidth = constraints.maxWidth * 15 / 100; // 80% chiều rộng
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
                  )

                ]
              )
            ),
            
            Expanded(
              child: Container (
                width: double.infinity,
                padding: EdgeInsets.all(16), // Thêm padding cho nội dung
                margin: EdgeInsets.fromLTRB(16, 0, 16, 0), 
                constraints: BoxConstraints(
                  minHeight: 400, // Chiều cao tối thiểu
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text('Where is the Eiffel Tower located?',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ],
                    ),
                  ]
                )
              )
            ),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16), // Thêm padding cho nội dung
              margin: EdgeInsets.fromLTRB(0, 8, 0, 0), 
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color.fromRGBO(251, 133, 0, 1), width: 1),
                          color: Color.fromRGBO(251, 133, 0, .3),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '5',
                              style: TextStyle(fontSize: 20, color: Color.fromRGBO(251, 133, 0, 1), fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
                            ),
                          ]
                        )
                      ),
                      
                      Icon(Icons.settings_backup_restore, color: Colors.black, size: 30),
                      
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color.fromRGBO(33, 150, 243, 1), width: 1),
                          color: Color.fromRGBO(33, 150, 243, .3),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '3',
                              style: TextStyle(fontSize: 20, color: Color.fromRGBO(33, 150, 243, 1), fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
                            ),
                          ]
                        )
                      ),

                    ]
                  ),
                ]
              )
            )

          ],
        ),
      )
    );
  }
}