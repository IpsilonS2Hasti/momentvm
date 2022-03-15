import 'package:flutter/material.dart';
import 'package:momentvm/screens/progress_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

import 'package:momentvm/models/authentication_service.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final Color backgroundColor;
  final String bgImage;

  const CustomAppBar(
      {Key? key,
      required this.title,
      required this.backgroundColor,
      required this.bgImage})
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
          Container(
            margin: EdgeInsets.all(7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Color.fromARGB(18, 0, 0, 0),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => ProgressScreen(
                    bgColor: backgroundColor,
                    bgImage: bgImage,
                  ),
                ));
              },
              child: Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.black54,
                    size: 26,
                  ),
                  Text(
                    " Progress",
                    style: TextStyle(color: Colors.black54, fontSize: 18),
                  )
                ],
              ),
            ),
          ),
          if (kIsWeb)
            IconButton(
              onPressed: () async {
                final url =
                    "https://drive.google.com/file/d/1QGz8Kwz13YV5XKjJj6dYcHXTZ8rYU9zq/view?usp=sharing";

                if (await canLaunch(url)) {
                  await launch(url);
                }
              },
              icon: Icon(Icons.download, color: Colors.black54),
            ),
          IconButton(
            onPressed: () => context.read<AuthenticationService>().signOut(),
            icon: Icon(Icons.logout, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
