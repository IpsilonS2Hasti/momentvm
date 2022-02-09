import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/day_provider.dart';

class BackgroundSwitcher extends StatelessWidget {
  final int _currentPage;

  const BackgroundSwitcher(this._currentPage);

  @override
  Widget build(BuildContext context) {
    var _segments = Provider.of<Day>(context).segments;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container(
        key: ValueKey<String>(
            _currentPage.toString()), //Key is need for the animation to work
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_segments[_currentPage].backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
