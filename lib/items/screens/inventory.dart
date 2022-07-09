import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/items/providers/items_apis.dart';

import 'package:provider/provider.dart';

import '../widgets/add_inventory.dart';

class Inventory extends StatefulWidget {
  Inventory({Key? key}) : super(key: key);
  static const routeName = '/Inventory';
  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  List inventory = [];
  @override
  void initState() {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<ItemApis>(context, listen: false)
          .getInventoryItems(token)
          .then((value1) {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    inventory = Provider.of<ItemApis>(context).inventoryItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed(
                  AddInventory.routeName,
                );
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          child: ListView.builder(
            itemCount: inventory.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 10,
                child: ListTile(
                  title: Text(inventory[index]['Inventory_Code']),
                  //subtitle: Text(itemDetails[index]['Description']),
                  trailing: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.edit)),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
