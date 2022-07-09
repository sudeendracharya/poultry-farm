import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/add_permission.dart';

class Permission extends StatefulWidget {
  const Permission({Key? key}) : super(key: key);
  static const routeName = '/Permission';

  @override
  _PermissionState createState() => _PermissionState();
}

class _PermissionState extends State<Permission> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permission'),
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed(AddPermission.routeName);
              },
              icon: const Icon(Icons.add))
        ],
      ),
    );
  }
}
