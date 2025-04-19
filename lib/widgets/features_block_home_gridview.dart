import 'package:flutter/material.dart';

class FeaturesBlockHomeGridView extends StatelessWidget {
  const FeaturesBlockHomeGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: Center (
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: GridView.count(
              // shrinkWrap: true,
              padding: EdgeInsets.zero,
              crossAxisCount: 1, // Lưới 2x2
              crossAxisSpacing: 16.0, // Khoảng cách ngang
              mainAxisSpacing: 16.0, // Khoảng cách dọc,
              children: [
                Container(
                  width: double.infinity,
                  height: 10,
                  color: Colors.blue, // Màu nền
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.home, size: 50, color: Colors.white), // Icon ở trên
                      SizedBox(height: 10), // Khoảng cách giữa icon và text
                      Text('Home 1', style: TextStyle(color: Colors.white, fontSize: 18)), // Text ở dưới
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 100,
                  color: Colors.green,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person, size: 50, color: Colors.white),
                      SizedBox(height: 10),
                      Text('Profile', style: TextStyle(color: Colors.white, fontSize: 18)),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 100,
                  color: Colors.red,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.settings, size: 50, color: Colors.white),
                      SizedBox(height: 10),
                      Text('Settings', style: TextStyle(color: Colors.white, fontSize: 18)),
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  width: double.infinity,
                  color: Colors.yellow,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info, size: 50, color: Colors.white),
                      SizedBox(height: 10),
                      Text('Info', style: TextStyle(color: Colors.white, fontSize: 18)),
                    ],
                  ),
                ),
              ],
            ),
          )
        )
      )
    );
  }
}