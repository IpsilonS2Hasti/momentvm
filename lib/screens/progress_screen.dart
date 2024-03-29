import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:momentvm/models/task.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProgressScreen extends StatefulWidget {
  final Color bgColor;
  final String bgImage;
  const ProgressScreen({Key? key, required this.bgColor, required this.bgImage})
      : super(key: key);

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.star, color: Colors.black54),
            Text(
              AppLocalizations.of(context)!.progress,
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
        iconTheme: const IconThemeData(
          color: Colors.black54,
        ),
        backgroundColor: widget.bgColor,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(widget.bgImage), fit: BoxFit.cover),
        ),
        child: ListView(children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: widget.bgColor.withOpacity(0.7),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 40, bottom: 24),
                  child: FutureBuilder(
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        var snapData = snapshot.data as List<List<FlSpot>>;
                        return Column(children: [
                          Expanded(child: buildLineChart(snapData)),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Wrap(
                              runSpacing: 7,
                              alignment: WrapAlignment.spaceAround,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.consistency,
                                  style: TextStyle(color: Colors.red),
                                ),
                                Text(
                                  AppLocalizations.of(context)!.motivation,
                                  style: TextStyle(color: Colors.blue),
                                ),
                                Text(
                                  AppLocalizations.of(context)!.productivity,
                                  style: TextStyle(color: Colors.purple),
                                ),
                              ],
                            ),
                          )
                        ]);
                      }
                      if (snapshot.connectionState == ConnectionState.done &&
                          !snapshot.hasData) {
                        return Container(
                          width: double.infinity,
                          child: Text(
                              AppLocalizations.of(context)!.noAssessmentsYet),
                        );
                      }
                      return Container(
                        width: double.infinity,
                        child: Text(AppLocalizations.of(context)!.loading),
                      );
                    }),
                    future: getChartData(),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: widget.bgColor.withOpacity(0.7),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      buildHeader(),
                      FutureBuilder(
                        future: getPubTasks(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            var pubTasks = snapshot.data as List;
                            if (pubTasks.length == 0)
                              return Container(
                                  padding: EdgeInsets.only(top: 15),
                                  height: 45,
                                  child: Text(
                                    AppLocalizations.of(context)!.pubATaskFirst,
                                  ));
                            return Column(
                              children:
                                  pubTasks.map((e) => buildPubItem(e)).toList(),
                            );
                          }
                          return Padding(
                              padding: EdgeInsets.only(top: 25),
                              child: CircularProgressIndicator());
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }

  Future<List<List<FlSpot>>> getChartData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var uid = context.read<User>().uid;
    var querySnap = await firestore
        .collection('/users/$uid/assessments')
        .orderBy('date')
        .limit(30)
        .get();
    var assessList = querySnap.docs.toList();
    List<List<FlSpot>> barsData = [[], [], []];
    for (int i = 0; i < assessList.length; i++) {
      var f = await assessList[i].data()["consistency"];
      var s = await assessList[i].data()["motivation"];
      var t = await assessList[i].data()["productivity"];
      barsData[0].add(FlSpot(i.toDouble() + 1, f.toDouble()));
      barsData[1].add(FlSpot(i.toDouble() + 1, s.toDouble()));
      barsData[2].add(FlSpot(i.toDouble() + 1, t.toDouble()));
      print(barsData.toString());
    }
    print(barsData.toString());
    return barsData;
  }

  LineChart buildLineChart(List<List<FlSpot>> barsData) {
    return LineChart(
      LineChartData(
          titlesData: FlTitlesData(
            topTitles: SideTitles(showTitles: false),
            rightTitles: SideTitles(showTitles: false),
            bottomTitles: SideTitles(showTitles: false),
          ),
          minX: 1,
          maxX: barsData[0].length.toDouble(),
          minY: 0,
          maxY: 5,
          lineTouchData: LineTouchData(enabled: false),
          gridData: FlGridData(
            show: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.black38,
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.transparent,
                strokeWidth: 0,
              );
            },
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: barsData[0],
              isCurved: true,
              colors: [Colors.red],
            ),
            LineChartBarData(
              spots: barsData[1],
              isCurved: true,
              colors: [Colors.blue],
            ),
            LineChartBarData(
              spots: barsData[2],
              isCurved: true,
              colors: [Colors.purple],
            ),
          ]),
    );
  }

  Future<List> getPubTasks() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var uid = context.read<User>().uid;
    List taskArr = [];
    var userDoc = await firestore.doc('/users/$uid').get();
    try {
      List refArr = await userDoc.get(FieldPath(["Published"]));
      for (int i = 0; i < refArr.length; i++) {
        var curTask = await refArr[i].get();
        taskArr.add(curTask);
      }
    } on StateError catch (e) {
      print('No nested field exists!');
    }
    return taskArr;
  }

  Widget buildPubItem(DocumentSnapshot doc) {
    return Material(
      color: const Color(0x00000000),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.5, color: Color(0x17000000)),
          ),
        ),
        height: 75,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  doc["title"],
                  maxLines: 3,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.bar_chart_rounded,
                    color: Colors.black54,
                  ),
                  Text(
                    doc["popularity"].toString(),
                  ),
                  SizedBox(width: 5),
                  Container(
                    width: 30,
                    child: IconButton(
                      onPressed: () async {
                        doc.reference.delete();
                        var firestore = FirebaseFirestore.instance;
                        var uid = context.read<User>().uid;
                        var pubTasks = await getPubTasks();
                        pubTasks.removeWhere((element) => element.id == doc.id);
                        var newTasks =
                            pubTasks.map((e) => e.reference).toList();
                        var userDoc = await firestore
                            .doc('/users/$uid')
                            .update({"Published": newTasks});
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.delete_outline_outlined,
                        color: Color.fromARGB(146, 244, 67, 54),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    //make header widget
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1.5,
            color: Color(0x17000000),
          ),
        ),
      ),
      height: 55,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              AppLocalizations.of(context)!.yourPubTasks,
              textScaleFactor: 1.2,
            ),
          )
        ],
      ),
    );
  }
}
