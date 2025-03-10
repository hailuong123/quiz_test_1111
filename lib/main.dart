import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 250, // Tăng chiều cao để kéo dài xuống
              decoration: BoxDecoration(
                  color: Color(0xFF222f63)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),
            ClipPath(
              clipper: RoundedBottomClipper(),
              child: Container(
                height: 50, // Chiều cao cố định để giữ độ bo tròn
                decoration: BoxDecoration(
                  color: Color(0xFF222f63)
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Center (
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: GridView.count(
                      // shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      crossAxisCount: 2, // Lưới 2x2
                      crossAxisSpacing: 16.0, // Khoảng cách ngang
                      mainAxisSpacing: 16.0, // Khoảng cách dọc,
                      children: [
                        Container(
                          height: 150, // Chiều cao block
                          width: 150, // Chiều rộng block
                          color: Colors.blue, // Màu nền
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.home, size: 50, color: Colors.white), // Icon ở trên
                              SizedBox(height: 10), // Khoảng cách giữa icon và text
                              Text('Home', style: TextStyle(color: Colors.white, fontSize: 18)), // Text ở dưới
                            ],
                          ),
                        ),
                        Container(
                          height: 150,
                          width: 150,
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
                          height: 150,
                          width: 150,
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
                          height: 150,
                          width: 150,
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
            )
          ]
          /*leadingWidth: 200,
          leading: Padding(
            padding: const EdgeInsets.all(8.0), // Optional padding
            child: Image.asset(
              'assets/images/LOGO.png', // Replace with your logo path
              height: 80,
              width: 50,
              fit: BoxFit.contain
            )
          ),
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(100),
            ),
          ),
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50), // Thêm chiều cao phía dưới
            child: Container(
              height: 10, // Không gian kéo dài xuống
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(100), // Bo tròn ở đáy
                ),
              ),
            ),
          )
        ),*/
        )
      )
    );
  }
}


// Custom Clipper để tạo hình vòng tròn ở đáy
class RoundedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0, size.height - 50); // Điểm bắt đầu ở góc trái dưới
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 50); // Tạo đường cong hình bán nguyệt
    path.lineTo(size.width, 0); // Đóng path về góc phải trên
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
