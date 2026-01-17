import 'package:flutter/cupertino.dart';

Future<bool?> showConfirmAdd(BuildContext context, String drink) {
  return showCupertinoModalPopup<bool>(
    context: context,
    builder: (_) => CupertinoActionSheet(
      title: Text('Add $drink?'),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Confirm'),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.pop(context, false),
        child: const Text('Cancel'),
      ),
    ),
  );
}