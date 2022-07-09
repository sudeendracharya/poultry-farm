import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/items/providers/items_apis.dart';
import 'package:provider/provider.dart';

import '../widgets/add_inventory_adjustment.dart';

class InventoryAdjustment extends StatefulWidget {
  InventoryAdjustment({Key? key}) : super(key: key);
  static const routeName = '/InventoryAdjustment';

  @override
  _InventoryAdjustmentState createState() => _InventoryAdjustmentState();
}

class _InventoryAdjustmentState extends State<InventoryAdjustment> {
  List inventoryAdjustment = [];
  @override
  void initState() {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<ItemApis>(context, listen: false)
          .getInventoryAdjustment(token)
          .then((value1) {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    inventoryAdjustment = Provider.of<ItemApis>(context).inventoryAdjustment;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Adjustment'),
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed(
                  AddInventoryAdjustment.routeName,
                );
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          child: ListView.builder(
            itemCount: inventoryAdjustment.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 10,
                child: ListTile(
                  title: Text(inventoryAdjustment[index]['Description']),
                  subtitle: Text(
                      inventoryAdjustment[index]['Inventory_Adjustment_Date']),
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
