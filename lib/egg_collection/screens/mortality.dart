import 'package:flutter/material.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/egg_collection/providers/egg_collection_apis.dart';
import 'package:provider/provider.dart';

class Mortality extends StatefulWidget {
  Mortality({Key? key}) : super(key: key);
  static const routeName = '/Mortality';

  @override
  _MortalityState createState() => _MortalityState();
}

class _MortalityState extends State<Mortality> {
  List getMortality = [];
  @override
  void initState() {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<EggCollectionApis>(context, listen: false)
          .getBirdMortality(token)
          .then((value1) {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getMortality = Provider.of<EggCollectionApis>(context).mortality;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mortality'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add))],
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          child: ListView.builder(
            itemCount: getMortality.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 10,
                child: ListTile(
                  title: Text(getMortality[index]['Mortality_Description']),
                  subtitle: Text(getMortality[index]['Mortality_Date']),
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
