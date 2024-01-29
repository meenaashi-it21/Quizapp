import 'package:flutter/material.dart';
import './screens/home_screen.dart';
import '../models/question_model.dart';
import '../models/db_connection.dart';

void main() {
    var db = DBConnect();
    db.fetchQuestions();
  runApp(const MyApp());
}

 /* Stateless widgets are the widgets that don’t change i.e. they are immutable. Its appearance and properties remain unchanged throughout the lifetime of the widget. In simple words, Stateless widgets cannot change their state during the runtime of the app, which means the widgets cannot be redrawn while the app is in action. 
Examples: Icon, IconButton, and Text are examples of stateless widgets.  */
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) :super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
