import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/add_grading.dart';

class Grading extends StatefulWidget {
  Grading({Key? key}) : super(key: key);
  static const routeName = '/Grading';

  @override
  _GradingState createState() => _GradingState();
}

class _GradingState extends State<Grading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grading'),
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed(AddGrading.routeName);
              },
              icon: const Icon(Icons.add))
        ],
      ),
    );
  }
}
