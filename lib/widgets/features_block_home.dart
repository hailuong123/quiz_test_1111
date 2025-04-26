import 'package:flutter/material.dart';
import 'package:us_citizenship_friend/widgets/practice_test_flashcard_page.dart';
import 'package:us_citizenship_friend/widgets/practice_test_page.dart';

class FeaturesBlockHome extends StatelessWidget {
  const FeaturesBlockHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Practice Test
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PracticeTestPage()),
                );
              },
              child: Container(
                height: 100,
                width: double.infinity,
                padding: EdgeInsets.only(left: 10), 
                margin: EdgeInsets.fromLTRB(16, 8, 16, 8), 
                decoration: BoxDecoration(
                  color: Color(0xFF222f63),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 68,
                          child: Icon(Icons.menu_book, size: 50, color: Colors.white),
                        )
                      ],
                    ),
                    Text(
                      'Practice Test',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ]
                ) 
              ),
            ),
            
            // Practice Test Flash Card
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PracticeTestFlashCardPage()),
                );
              },
              child: Container(
                height: 100,
                width: double.infinity,
                padding: EdgeInsets.only(left: 10), 
                margin: EdgeInsets.fromLTRB(16, 8, 16, 8), 
                decoration: BoxDecoration(
                  color: Color(0xFF222f63),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 68,
                          child: Icon(Icons.web_stories, size: 50, color: Colors.white),
                        )
                      ],
                    ),
                    Text(
                      'Flash Cards',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ]
                ) 
              ),
            ),

            // 100 Yes/No Questions
            GestureDetector(
              onTap: () {
                // Navigate to Flash Cards Page
              },
              child: Container(
                height: 100,
                width: double.infinity,
                padding: EdgeInsets.only(left: 10), 
                margin: EdgeInsets.fromLTRB(16, 8, 16, 8), 
                decoration: BoxDecoration(
                  color: Color(0xFF222f63),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 68,
                          child: Icon(Icons.rule, size: 50, color: Colors.white),
                        )
                      ],
                    ),
                    Text(
                      'Yes/No Questions',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ]
                ) 
              ),
            ),

            // View All Questions
            GestureDetector(
              onTap: () {
                // Navigate to Flash Cards Page
              },
              child: Container(
                height: 100,
                width: double.infinity,
                padding: EdgeInsets.only(left: 10), 
                margin: EdgeInsets.fromLTRB(16, 8, 16, 8), 
                decoration: BoxDecoration(
                  color: Color(0xFF222f63),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 68,
                          child: Icon(Icons.menu_book, size: 50, color: Colors.white),
                        )
                      ],
                    ),
                    Text(
                      'View All Questions',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ]
                ) 
              ),
            ),
            
            // Simulate A Real Test
            GestureDetector(
              onTap: () {
                // Navigate to Flash Cards Page
              },
              child: Container(
                height: 100,
                width: double.infinity,
                padding: EdgeInsets.only(left: 10), 
                margin: EdgeInsets.fromLTRB(16, 8, 16, 8), 
                decoration: BoxDecoration(
                  color: Color(0xFF222f63),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 68,
                          child: Icon(Icons.face, size: 50, color: Colors.white),
                        )
                      ],
                    ),
                    Text(
                      'Simulate A Real Test',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ]
                ) 
              ),
            ),

            // Settings and Remove Ads
            GestureDetector(
              onTap: () {
                // Navigate to Flash Cards Page
              },
              child: Container(
                height: 100,
                margin: EdgeInsets.fromLTRB(16, 8, 16, 8), 
                child: GridView.count(
                  padding: EdgeInsets.zero,
                  crossAxisCount: 2, // Lưới 2x2
                  crossAxisSpacing: 16.0, // Khoảng cách ngang
                  childAspectRatio: 2,
                  children: [
                    Container (
                      decoration: BoxDecoration(
                        color: Color(0xFF222f63),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'REMOVE ADS',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container (
                      decoration: BoxDecoration(
                        color: Color(0xFF222f63),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'SETTINGS',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          
                        ],
                      )
                    )
                  ]
                )
              )
            ),
          ]
        )
      )
    );
  }
}