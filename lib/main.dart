import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:us_citizenship_friend/models/questions_model.dart';
import 'package:us_citizenship_friend/widgets/app_bar_home.dart';
import 'package:us_citizenship_friend/widgets/clip_path_bottom.dart';
import 'package:us_citizenship_friend/widgets/features_block_home.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => QuestionsModel(), 
      child: const MyApp()
    )
  );
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
            AppBarHome(),
            ClipPathBottom(),
            FeaturesBlockHome()
          ]
        )
      )
    );
  }
}
