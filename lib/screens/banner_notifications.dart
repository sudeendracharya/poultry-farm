import 'package:flutter/material.dart';

class BannerNotifications extends StatefulWidget {
  BannerNotifications({Key? key}) : super(key: key);

  @override
  _BannerNotificationsState createState() => _BannerNotificationsState();
}

class _BannerNotificationsState extends State<BannerNotifications> {
  bool isOpened = false;
  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      elevation: 0,
      children: [
        ExpansionPanel(
          backgroundColor: Color.fromRGBO(252, 232, 232, 1),
          headerBuilder: (context, isOpened) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 82.0, right: 15),
                  child: Icon(Icons.info_outline),
                ),
                Text('Name'),
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.close)),
                  ),
                )
              ],
            );
          },
          isExpanded: isOpened,
          canTapOnHeader: true,
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 82.0),
                child: ListTile(
                  title: const Text('data'),
                  onTap: () async {
                    // Navigator.of(context)
                    //     .pushNamed(DashBoardScreen.routeName);
                  },
                ),
              ),
            ],
          ),
        ),
        ExpansionPanel(
          backgroundColor: Color.fromRGBO(255, 250, 224, 1),
          headerBuilder: (context, isOpened) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 82.0, right: 15),
                  child: Icon(Icons.info_outline),
                ),
                Text('Name'),
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child:
                        IconButton(onPressed: () {}, icon: Icon(Icons.close)),
                  ),
                )
              ],
            );
          },
          isExpanded: isOpened,
          canTapOnHeader: true,
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 82.0),
                child: ListTile(
                  title: const Text('data'),
                  onTap: () async {
                    // Navigator.of(context)
                    //     .pushNamed(DashBoardScreen.routeName);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
      expansionCallback: (i, isOpen) => setState(
        () {
          isOpened = !isOpen;
        },
      ),
    );
  }
}
