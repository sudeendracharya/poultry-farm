import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:poultry_login_signup/main.dart';
import 'package:poultry_login_signup/screens/notifications_page.dart';

import '../search_widget.dart';

class GlobalAppBar extends StatefulWidget implements PreferredSizeWidget {
  const GlobalAppBar({
    Key? key,
    required this.firmName,
    required this.appbar,
  }) : super(key: key);

  final String firmName;
  final AppBar appbar;

  @override
  State<GlobalAppBar> createState() => _GlobalAppBarState();
  @override
  Size get preferredSize => Size.fromHeight(appbar.preferredSize.height);
}

class _GlobalAppBarState extends State<GlobalAppBar> {
  String firmName = '';
  @override
  void initState() {
    getFirm();
    super.initState();
  }

  getFirm() async {
    firmName = await getFirmName();
    if (firmName != '') {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(firmName),
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
