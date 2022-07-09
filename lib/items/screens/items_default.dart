import 'package:flutter/material.dart';

// part '../../packages/items/lib/screens/inventory_adjustment.dart';
// part '../../packages/items/lib/screens/item_category.dart';
// part '../../packages/items/lib/screens/item_details.dart';
// part '../../packages/items/lib/screens/item_sub_category.dart';

// part '../../packages/items/lib/widgets/add_inventory_adjustment.dart';
// part '../../packages/items/lib/widgets/add_item_category.dart';
// part '../../packages/items/lib/widgets/add_item_details.dart';
// part '../../packages/items/lib/widgets/add_item_sub_category.dart';

class Items extends StatefulWidget {
  Items({Key? key}) : super(key: key);

  static const routeName = '/Items';

  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: ItemDefaultPage(),
//       routes: {

//       },
//     );
//   }
// }

// class ItemDefaultPage extends StatefulWidget {
//   ItemDefaultPage({Key? key}) : super(key: key);

//   @override
//   _ItemDefaultPageState createState() => _ItemDefaultPageState();
// }

// class _ItemDefaultPageState extends State<ItemDefaultPage> {
  List<bool> _isOpen = [false];
  bool isOpened = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('Welcome'),
                ],
              ),
            ),
            const Divider(color: Colors.black),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Items'),
      ),
      body: const Center(
        child: Text('Item Default Page'),
      ),
    );
  }
}
