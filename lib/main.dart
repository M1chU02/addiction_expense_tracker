import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(AddictionExpenseTrackerApp());
}

class AddictionExpenseTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Addiction Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
