import 'package:flutter/material.dart';

class PracticeTestFlashCardPage extends StatelessWidget {
  const PracticeTestFlashCardPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                              '15/100 Questions',
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
              ),
            
              Container (
                width: double.infinity,
                padding: EdgeInsets.all(16), // Thêm padding cho nội dung
                margin: EdgeInsets.fromLTRB(16, 0, 16, 0), 
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      
                    ),
                  ]
                )
              )
            ],
          ),
        )
      )
    );
  }
}