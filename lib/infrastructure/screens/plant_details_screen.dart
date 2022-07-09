import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/infrastructure/providers/infrastructure_apicalls.dart';
import 'package:poultry_login_signup/widgets/failure_dialog.dart';
import 'package:poultry_login_signup/widgets/success_dialog.dart';
import 'package:provider/provider.dart';

import '../widgets/add_plant_details.dart';

// import '/widgets/add_plant_details.dart';

class PlantDetailsScreen extends StatefulWidget {
  PlantDetailsScreen({Key? key}) : super(key: key);
  static const routeName = '/PlantDetailsScreen';

  @override
  _PlantDetailsScreenState createState() => _PlantDetailsScreenState();
}

class _PlantDetailsScreenState extends State<PlantDetailsScreen> {
  List plantDetails = [];
  // @override
  // void initState() {
  //   Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
  //     var token = Provider.of<Apicalls>(context, listen: false).token;
  //     Provider.of<InfrastructureApis>(context, listen: false)
  //         .getPlantDetails(token)
  //         .then((value1) {});
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    plantDetails = Provider.of<InfrastructureApis>(
      context,
    ).plantDetails;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Details'),
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed(
                  AddPlantDetails.routeName,
                );
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          child: ListView.builder(
            itemCount: plantDetails.length,
            itemBuilder: (BuildContext context, int index) {
              return DisplayPlantDetails(
                plantDetails: plantDetails,
                index: index,
                key: UniqueKey(),
              );
            },
          ),
        ),
      ),
    );
  }
}

class DisplayPlantDetails extends StatefulWidget {
  DisplayPlantDetails(
      {Key? key, required this.plantDetails, required this.index})
      : super(key: key);
  final List plantDetails;
  final int index;

  @override
  _DisplayPlantDetailsState createState() => _DisplayPlantDetailsState();
}

class _DisplayPlantDetailsState extends State<DisplayPlantDetails> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: ListTile(
        title: Text(widget.plantDetails[widget.index]['Plant_Name']),
        subtitle: Text(widget.plantDetails[widget.index]['Plant_Code']),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () {
                  // Navigator.of(context).pushNamed(AddPlantDetails.routeName,
                  //     arguments: widget.plantDetails[widget.index]);
                  Get.toNamed(AddPlantDetails.routeName,
                      arguments: widget.plantDetails[widget.index]);
                },
                icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  Provider.of<Apicalls>(context, listen: false)
                      .tryAutoLogin()
                      .then((value) {
                    var token =
                        Provider.of<Apicalls>(context, listen: false).token;
                    Provider.of<InfrastructureApis>(context, listen: false)
                        .deletePlantDetails(
                            widget.plantDetails[widget.index]['Plant_Id'],
                            token)
                        .then((value) {
                      if (value == 200 || value == 204) {
                        // Provider.of<InfrastructureApis>(context, listen: false)
                        //     .getPlantDetails(token)
                        //     .then((value1) {});
                        // showDialog(
                        //     context: context,
                        //     builder: (ctx) => SuccessDialog(
                        //         title: 'Success',
                        //         subTitle: 'SuccessFully Added Plant Details'));
                      } else {
                        showDialog(
                          context: context,
                          builder: (ctx) => FailureDialog(
                              title: 'Failed',
                              subTitle:
                                  'Something Went Wrong Please Try Again'),
                        );
                      }
                    });
                  });
                },
                icon: const Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }
}
