import 'package:flutter/material.dart';

import '../../screens/main_drawer_screen.dart';
import '../../search_widget.dart';

class PlantDashBoardScreen extends StatefulWidget {
  PlantDashBoardScreen({Key? key}) : super(key: key);

  static const routeName = '/PlantDashBoardScreen';

  @override
  _PlantDashBoardScreenState createState() => _PlantDashBoardScreenState();
}

class _PlantDashBoardScreenState extends State<PlantDashBoardScreen> {
  ScrollController controller = ScrollController();

  var query = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(controller: controller),
      appBar: AppBar(
        title: const Text('DashBoard Screen'),
        backgroundColor: Theme.of(context).backgroundColor,
        actions: [
          Container(
              width: 216,
              height: 36,
              child: SearchWidget(
                  text: query, onChanged: (value) {}, hintText: 'Search')),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          const SizedBox(
            width: 6,
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.person)),
        ],
      ),
    );
  }
}
