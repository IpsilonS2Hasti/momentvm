import 'package:flutter/material.dart';
import 'package:momentvm/screens/progress_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'package:momentvm/models/authentication_service.dart';

import '../models/locale_provider.dart';

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
                    AppLocalizations.of(context)!.progress,
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
          PopupMenuButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            icon: Icon(
              Icons.settings,
              color: Colors.black54,
            ),
            color: backgroundColor,
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: false,
                child: Center(
                  child: ToggleSwitch(
                    cornerRadius: 16,
                    inactiveBgColor: Colors.black26,
                    fontSize: 16,
                    customWidths: [50.0, 50.0],
                    initialLabelIndex:
                        Localizations.localeOf(context).languageCode == "bg"
                            ? 0
                            : 1,
                    totalSwitches: 2,
                    labels: ['🇧🇬', '🇺🇸'],
                    onToggle: (index) {
                      Locale locale = index == 0 ? Locale("bg") : Locale("en");
                      Provider.of<LocaleProvider>(context, listen: false)
                          .setLocale(locale);
                    },
                  ),
                ),
                value: 1,
              ),
              PopupMenuItem(
                onTap: () => context.read<AuthenticationService>().signOut(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Sign out"),
                    Padding(padding: EdgeInsets.only(right: 15)),
                    Icon(
                      Icons.logout,
                      color: Colors.black54,
                    ),
                  ],
                ),
                value: 2,
              )
            ],
          ),
        ],
      ),
    );
  }
}
