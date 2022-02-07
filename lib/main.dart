import 'package:flutter/material.dart';
import 'package:momentvm/models/day_provider.dart';
import 'package:provider/provider.dart';

import 'screens/routine_screen.dart';
import 'models/day_provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'My Day';

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => Day(),
      child: MaterialApp(
        title: _title,
        home: RoutineScreen(),
      ),
    );
  }
}
