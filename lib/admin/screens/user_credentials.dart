import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/add_user_credentials.dart';

class UserCredentials extends StatefulWidget {
  const UserCredentials({Key? key}) : super(key: key);
  static const routeName = '/UserCredentials';

  @override
  _UserCredentialsState createState() => _UserCredentialsState();
}

class _UserCredentialsState extends State<UserCredentials> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Credentials'),
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed(AddUserCredentials.routeName);
              },
              icon: const Icon(Icons.add))
        ],
      ),
    );
  }
}
