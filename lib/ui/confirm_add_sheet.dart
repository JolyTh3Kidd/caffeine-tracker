import 'package:flutter/cupertino.dart';
import 'package:caffeine_tracker/l10n/app_localizations.dart';

Future<bool?> showConfirmAdd(BuildContext context, String drink) {
  return showCupertinoModalPopup<bool>(
    context: context,
    builder: (_) => CupertinoActionSheet(
      title: Text(AppLocalizations.of(context)!.confirmAddTitle(drink)),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context, true),
          child: Text(AppLocalizations.of(context)!.confirm),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.pop(context, false),
        child: Text(AppLocalizations.of(context)!.cancel),
      ),
    ),
  );
}
