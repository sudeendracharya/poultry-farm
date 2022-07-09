import 'package:flutter/material.dart';

class SuccessDialog extends StatefulWidget {
  SuccessDialog({Key? key, required this.title, required this.subTitle})
      : super(key: key);

  final String title;
  final String subTitle;

  @override
  _SuccessDialogState createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<SuccessDialog> {
  @override
  Widget build(BuildContext context) {
    return
        // SnackBar(
        //   content: Text(
        //     widget.subTitle,
        //   ),
        //   duration: const Duration(seconds: 5),
        //   action: SnackBarAction(
        //       label: 'ok',
        //       onPressed: () {
        //         ScaffoldMessenger.of(context).clearSnackBars();
        //         Navigator.of(context).pop();
        //       }),
        // );
        AlertDialog(
      title: Text(widget.title),
      content: Text(widget.subTitle),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('ok'),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Add Plant'),
        )
      ],
    );
  }
}
