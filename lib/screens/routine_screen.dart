import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:momentvm/models/day_provider.dart';
import 'package:momentvm/widgets/custom_app_bar.dart';
import 'package:momentvm/widgets/panel_view.dart';
import 'package:momentvm/widgets/self_assessment_view.dart';
import 'package:momentvm/widgets/throughout_view.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  final dayController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final day = Provider.of<Day>(context);
    final segments = day.segments;
    return Scaffold(
      appBar: CustomAppBar(
        key: ValueKey<String>(_currentPage.toString()),
        title: Row(
          children: [
            Icon(Icons.format_list_numbered_rtl_rounded, color: Colors.black54),
            Text(
              AppLocalizations.of(context)!.myRoutine,
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
        backgroundColor: segments[_currentPage].listColor,
        bgImage: segments[_currentPage].backgroundImage,
      ),
      body: SlidingUpPanel(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            BackgroundSwitcher(_currentPage),
            Column(
              children: [
                Expanded(
                  //I guess Expanded() needs an axis-defining widget as it's parent
                  child: PageView.builder(
                    controller: dayController,
                    physics: const CustomPageViewScrollPhysics(),
                    itemCount: segments.length - (day.dayEnd ? 1 : 2),
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return ChangeNotifierProvider.value(
                        value: segments[index],
                        child: index != 4
                            ? SegmentView(
                                key: ValueKey(segments[index].name),
                                dayController: dayController,
                              )
                            : SelfAssessmentView(
                                key: ValueKey(segments[index].name),
                                dayController: dayController),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        minHeight: 35,
        maxHeight: 565,
        color: Colors.white54,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
          bottomLeft: Radius.zero,
        ),
        panel: PanelView(
          dayController: dayController,
        ),
      ),
    );
  }
}
