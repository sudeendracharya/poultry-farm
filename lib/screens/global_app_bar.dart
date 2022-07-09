import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:poultry_login_signup/screens/notifications_page.dart';

import '../search_widget.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GlobalAppBar({
    Key? key,
    required this.query,
    required this.appbar,
  }) : super(key: key);

  final String query;
  final AppBar appbar;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Geetha Farms'),
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

  @override
  Size get preferredSize => Size.fromHeight(appbar.preferredSize.height);
}
