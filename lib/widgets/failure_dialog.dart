import 'package:flutter/material.dart';

class FailureDialog extends StatefulWidget {
  FailureDialog({Key? key, required this.title, required this.subTitle})
      : super(key: key);
  final String title;
  final String subTitle;

  @override
  _FailureDialogState createState() => _FailureDialogState();
}

class _FailureDialogState extends State<FailureDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Text(widget.subTitle),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('ok'),
        )
      ],
    );
  }
}
