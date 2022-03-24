import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String matchSegLoc(String s, BuildContext context) {
  if (s == "Morning") return AppLocalizations.of(context)!.morning;
  if (s == "Afternoon") return AppLocalizations.of(context)!.afternoon;
  if (s == "Evening") return AppLocalizations.of(context)!.evening;
  if (s == "Night") return AppLocalizations.of(context)!.night;
  if (s == "Self Assessment")
    return AppLocalizations.of(context)!.selfAssessment;
  if (s == "Archive") return AppLocalizations.of(context)!.archive;
  return "null";
}
