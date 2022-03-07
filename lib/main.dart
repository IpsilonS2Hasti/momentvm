import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:momentvm/models/authentication_service.dart';
import 'package:momentvm/models/day_provider.dart';
import 'package:momentvm/screens/sign_in_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/routine_screen.dart';
import 'models/day_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  static const String _title = 'My Day';

  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider<User?>(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        ),
        Provider(
          create: (context) => Day(context
              .read<User?>()!
              .uid), //We need to use the provided context because it's the context of the providers nested after one another
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(canvasColor: Colors.transparent),
        title: _title,
        home: AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  AuthenticationWrapper({Key? key}) : super(key: key);
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    if (firebaseUser != null) {
      return FutureBuilder(
        future: _fbApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('You have an error! ${snapshot.error.toString()}');
            return const Text("Something went wrong!");
          } else if (snapshot.hasData) {
            return RoutineScreen();
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    }
    return SignInPage();
  }
}
