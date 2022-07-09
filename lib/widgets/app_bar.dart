import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';

import '../screens/notifications_page.dart';
import '../search_widget.dart';

class AppbarWidget extends StatefulWidget {
  AppbarWidget({Key? key}) : super(key: key);

  @override
  State<AppbarWidget> createState() => _AppbarWidgetState();
}

class _AppbarWidgetState extends State<AppbarWidget> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('DashBoard Screen'),
      backgroundColor: Theme.of(context).backgroundColor,
      actions: [
        // Container(
        //     width: 216,
        //     height: 36,
        //     child: SearchWidget(
        //         text: query, onChanged: (value) {}, hintText: 'Search')),
        IconButton(
            onPressed: () {
              showGlobalDrawer(
                context: context,
                builder: (ctx) => NotificationPage(),
                direction: AxisDirection.right,
              );
            },
            icon: const Icon(Icons.notifications)),
        const SizedBox(
          width: 6,
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.person)),
      ],
    );
  }
}
