import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:momentvm/widgets/throughout_view.dart';
import 'package:provider/provider.dart';

import '../models/day_provider.dart';

class PanelView extends StatelessWidget {
  final PageController dayController;

  const PanelView({Key? key, required this.dayController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final segments = Provider.of<Day>(context).segments;
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
        bottomLeft: Radius.zero,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Column(children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
                bottomLeft: Radius.zero,
              ),
            ),
            height: 35,
            child: Center(
                child: Container(
              color: Colors.black54,
              height: 3,
              width: 75,
            )),
          ),
          buildHeader(),
          Expanded(
            child: ChangeNotifierProvider.value(
              value: segments[5],
              child: ThroughoutView(dayController: dayController),
            ),
          )
        ]),
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
      height: 35,
      width: double.infinity,
      child: Center(
        child: Text(
          "Archive:",
          textScaleFactor: 1.2,
        ),
      ),
    );
  }
}
