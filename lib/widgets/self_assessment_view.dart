import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:givestarreviews/givestarreviews.dart';
import 'package:momentvm/models/task.dart';
import 'package:momentvm/screens/new_task_screen.dart';
import 'package:momentvm/screens/task_screen.dart';
import 'package:momentvm/widgets/task_tile.dart';
import 'package:provider/provider.dart';

import '../models/segment_provider.dart';
import '../screens/new_task_screen.dart';
import './time_tracker.dart';

class SelfAssessmentView extends StatelessWidget {
  final PageController dayController;

  const SelfAssessmentView({Key? key, required this.dayController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final segment = Provider.of<Segment>(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 16,
              ),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: segment.listColor.withOpacity(0.5),
                    ),
                    child: Column(
                      children: [
                        buildHeader(segment, context),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 35),
                            child: GiveStarReviews(
                              spaceBetween: 50,
                              starData: [
                                GiveStarData(
                                  text: 'Consistency',
                                  onChanged: (rate) {},
                                ),
                                GiveStarData(
                                  text: 'Motivation',
                                  onChanged: (rate) {},
                                ),
                                GiveStarData(
                                  text: 'Productivity',
                                  onChanged: (rate) {},
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 50),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 24),
                            ),
                            onPressed: () {},
                            child: const Text(
                              'Submit',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildHeader(Segment segment, BuildContext context) {
    return Container(
      //Segment Header
      height: 52,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        color: Color(0x0B000000),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                segment.name + ":",
                textScaleFactor: 1.3,
              )),
        ],
      ),
    );
  }
}
