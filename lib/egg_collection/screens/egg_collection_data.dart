import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/egg_collection/providers/egg_collection_apis.dart';
import 'package:provider/provider.dart';

import '../widgets/add_egg_collection_data.dart';

class EggCollectionData extends StatefulWidget {
  EggCollectionData({Key? key}) : super(key: key);
  static const routeName = '/EggCollectionData';

  @override
  _EggCollectionDataState createState() => _EggCollectionDataState();
}

class _EggCollectionDataState extends State<EggCollectionData> {
  List eggCollectionData = [];
  @override
  void initState() {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<EggCollectionApis>(context, listen: false)
          .getEggCollection(token)
          .then((value1) {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    eggCollectionData = Provider.of<EggCollectionApis>(context).eggCollection;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Egg Collection Data'),
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed(AddEggCollectionData.routeName);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          child: ListView.builder(
            itemCount: eggCollectionData.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 10,
                child: ListTile(
                  title:
                      Text(eggCollectionData[index]['Egg_Collection_Status']),
                  subtitle:
                      Text(eggCollectionData[index]['Egg_Collection_Date']),
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
