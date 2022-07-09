import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/batch_plan/providers/batch_plan_apis.dart';
import 'package:provider/provider.dart';

import '../widgets/addbatchplanmapping.dart';

class BatchPlanMapping extends StatefulWidget {
  BatchPlanMapping({Key? key}) : super(key: key);
  static const routeName = '/BatchPlanMapping';
  @override
  _BatchPlanMappingState createState() => _BatchPlanMappingState();
}

class _BatchPlanMappingState extends State<BatchPlanMapping> {
  List batchPlanMapData = [];
  @override
  void initState() {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<BatchApis>(context, listen: false)
          .getBatchPlanMapping(token)
          .then((value1) {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    batchPlanMapData = Provider.of<BatchApis>(
      context,
    ).batchPlanMapping;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Batch Planning Mapping'),
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed(AddBatchPlanMapping.routeName);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          child: ListView.builder(
            itemCount: batchPlanMapData.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(batchPlanMapData[index]['Batch_Status']),
                    Text(batchPlanMapData[index]['Required_Qunatity']
                        .toString()),
                    Text(batchPlanMapData[index]['Required_Date_Of_Delivery']),
                    Text(batchPlanMapData[index]['Received_Quantity']
                        .toString()),
                    Text(batchPlanMapData[index]['Received_Date']),
                    Text(batchPlanMapData[index]['Hatch_Date']),
                    Text(batchPlanMapData[index]['Bird_Age_Name']),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
