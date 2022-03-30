import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:momentvm/screens/sign_in_page.dart';
import 'package:provider/provider.dart';

import '../models/authentication_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/login.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentNode = FocusScope.of(context);
            if (currentNode.focusedChild != null &&
                !currentNode.hasPrimaryFocus) {
              FocusManager.instance.primaryFocus!.unfocus();
            }
          },
          child: Stack(
            children: [
              Container(),
              Container(
                padding: EdgeInsets.only(left: 35, top: 110),
                child: Text(
                  'Nice to meet you!',
                  style: TextStyle(color: Colors.white, fontSize: 33),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: EdgeInsets.only(top: 260),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: Color(0xff525E92).withOpacity(0.3),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 35, right: 35),
                              child: Column(
                                children: [
                                  TextField(
                                    controller: emailController,
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      fillColor: Colors.transparent,
                                      filled: true,
                                      hintText: "Email",
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  TextField(
                                    controller: passwordController,
                                    style: TextStyle(),
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      fillColor: Colors.transparent,
                                      filled: true,
                                      hintText: "Password",
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Sign up',
                                        style: TextStyle(
                                            fontSize: 27,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor:
                                            Color(0xff675ABD).withOpacity(0.7),
                                        child: IconButton(
                                            color: Colors.white,
                                            onPressed: () {
                                              context
                                                  .read<AuthenticationService>()
                                                  .signUp(
                                                    email: emailController.text
                                                        .trim(),
                                                    password: passwordController
                                                        .text
                                                        .trim(),
                                                  );
                                              Navigator.of(context).pop();
                                            },
                                            icon: Icon(
                                              Icons.arrow_forward,
                                            )),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.arrow_back,
                                              size: 28,
                                              color: Color(0xffF6A1B8)
                                                  .withOpacity(0.7),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              "Sign in",
                                              style: TextStyle(
                                                color: Color(0xffF6A1B8)
                                                    .withOpacity(0.7),
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                        style: ButtonStyle(),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
