import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:momentvm/models/day_provider.dart';
import 'package:momentvm/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

import '../widgets/background_switcher.dart';
import '../widgets/segment_view.dart';

class CustomPageViewScrollPhysics extends ScrollPhysics {
  const CustomPageViewScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  CustomPageViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPageViewScrollPhysics(parent: buildParent(ancestor)!);
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 80,
        stiffness: 100,
        damping: 0.8,
      );
}

class RoutineScreen extends StatefulWidget {
  @override
  _RoutineScreenState createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final segments = Provider.of<Day>(context).segments;
    return Scaffold(
      appBar: CustomAppBar(
        key: ValueKey<String>(_currentPage.toString()),
        title: const Text(
          'Today',
          style: TextStyle(color: Colors.black54),
        ),
        backgroundColor: segments[_currentPage].listColor,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BackgroundSwitcher(_currentPage),
          Column(
            children: [
              Expanded(
                //I guess Expanded() needs an axis-defining widget as it's parent
                child: PageView.builder(
                  physics: const CustomPageViewScrollPhysics(),
                  itemCount: segments.length,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return ChangeNotifierProvider.value(
                      value: segments[index],
                      child: SegmentView(key: ValueKey(segments[index].name)),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
