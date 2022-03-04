import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:momentvm/models/authentication_service.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final Color backgroundColor;

  const CustomAppBar(
      {Key? key, required this.title, required this.backgroundColor})
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: AppBar(
        key: key,
        title: title,
        backgroundColor: backgroundColor,
        actions: [
          IconButton(
            onPressed: () => context.read<AuthenticationService>().signOut(),
            icon: Icon(
              Icons.logout,
              color: Colors.black54,
            ),
          )
        ],
      ),
    );
  }
}
