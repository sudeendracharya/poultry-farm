import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/add_module.dart';

class ModuleData extends StatefulWidget {
  const ModuleData({Key? key}) : super(key: key);

  static const routeName = '/Module';

  @override
  _ModuleDataState createState() => _ModuleDataState();
}

class _ModuleDataState extends State<ModuleData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Module'),
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed(AddModule.routeName);
              },
              icon: const Icon(Icons.add))
        ],
      ),
    );
  }
}
