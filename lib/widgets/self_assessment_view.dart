import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:givestarreviews/givestarreviews.dart';
import 'package:momentvm/models/day_provider.dart';
import 'package:momentvm/models/task.dart';
import 'package:momentvm/screens/new_task_screen.dart';
import 'package:momentvm/screens/task_screen.dart';
import 'package:momentvm/utils/matchSegLoc.dart';
import 'package:momentvm/widgets/task_tile.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/segment_provider.dart';
import '../screens/new_task_screen.dart';
import './time_tracker.dart';

class SelfAssessmentView extends StatefulWidget {
  final PageController dayController;

  const SelfAssessmentView({Key? key, required this.dayController})
      : super(key: key);

  @override
  State<SelfAssessmentView> createState() => _SelfAssessmentViewState();
}

class _SelfAssessmentViewState extends State<SelfAssessmentView> {
  int consistency = 0;
  int motivation = 0;
  int productivity = 0;

  @override
  Widget build(BuildContext context) {
    final segment = Provider.of<Segment>(context);
    final day = Provider.of<Day>(context);
    return Column(
      children: [
        Container(
          height: 380,
          margin: const EdgeInsets.only(
            top: 80,
            left: 16,
            right: 16,
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
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: GiveStarReviews(
                          spaceBetween: 45,
                          starData: [
                            GiveStarData(
                              value: consistency,
                              text: AppLocalizations.of(context)!.consistency,
                              onChanged: (rate) {
                                setState(() {
                                  consistency = rate;
                                });
                              },
                            ),
                            GiveStarData(
                              value: motivation,
                              text: AppLocalizations.of(context)!.motivation,
                              onChanged: (rate) {
                                setState(() {
                                  motivation = rate;
                                });
                              },
                            ),
                            GiveStarData(
                              value: productivity,
                              text: AppLocalizations.of(context)!.productivity,
                              onChanged: (rate) {
                                setState(() {
                                  productivity = rate;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 24),
                        ),
                        onPressed: () {
                          var uid = context.read<User>().uid;
                          FirebaseFirestore firestore =
                              FirebaseFirestore.instance;
                          var newTaskRef = firestore
                              .collection('/users/$uid/assessments')
                              .doc();
                          var date = new DateTime.now();
                          final curT = "${date.year}-${date.month}-${date.day}";
                          newTaskRef.set({
                            "consistency": consistency,
                            "motivation": motivation,
                            "productivity": productivity,
                            "date": curT,
                          });
                          day.beginDay();
                        },
                        child: Text(
                          AppLocalizations.of(context)!.submit,
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
      ],
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
                matchSegLoc(segment.name, context) + ":",
                textScaleFactor: 1.3,
              )),
        ],
      ),
    );
  }
}
