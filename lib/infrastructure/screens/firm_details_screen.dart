import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/infrastructure/providers/infrastructure_apicalls.dart';
import 'package:poultry_login_signup/screens/dashboard_default_screen.dart';
import 'package:poultry_login_signup/widgets/failure_dialog.dart';
import 'package:poultry_login_signup/widgets/success_dialog.dart';
import 'package:provider/provider.dart';

import '../widgets/add_firm_details.dart';

// import '/widgets/add_firm_details.dart';

class FirmDetailScreen extends StatefulWidget {
  FirmDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/FirmDetailsScreen';

  @override
  _FirmDetailScreenState createState() => _FirmDetailScreenState();
}

class _FirmDetailScreenState extends State<FirmDetailScreen> {
  List firmDetails = [];
  @override
  void initState() {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      // Provider.of<InfrastructureApis>(context, listen: false)
      //     .getFirmDetails(token)
      //     .then((value1) {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    firmDetails = Provider.of<InfrastructureApis>(
      context,
    ).firmDetails;
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed(DashBoardDefaultScreen.routeName);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Firm Details'),
          actions: [
            IconButton(
                onPressed: () {
                  Get.offAndToNamed(AddFirmDetails.routeName);
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 2,
            child: ListView.builder(
              itemCount: firmDetails.length,
              itemBuilder: (BuildContext context, int index) {
                return EditFirmDetails(firmDetails: firmDetails, index: index);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class EditFirmDetails extends StatefulWidget {
  const EditFirmDetails(
      {Key? key, required this.firmDetails, required this.index})
      : super(key: key);
  final List firmDetails;
  final int index;

  @override
  _EditFirmDetailsState createState() => _EditFirmDetailsState();
}

class _EditFirmDetailsState extends State<EditFirmDetails> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: ListTile(
        title: Text(widget.firmDetails[widget.index]['Firm_Name']),
        subtitle: Text(widget.firmDetails[widget.index]['Firm_Contact_Number']),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                // Navigator.of(context).pushReplacementNamed(
                //     AddFirmDetails.routeName,
                //     arguments: widget.firmDetails[widget.index]);
                Get.toNamed(AddFirmDetails.routeName,
                    arguments: widget.firmDetails[widget.index]);
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                Provider.of<Apicalls>(context, listen: false)
                    .tryAutoLogin()
                    .then((value) {
                  var token =
                      Provider.of<Apicalls>(context, listen: false).token;
                  Provider.of<InfrastructureApis>(context, listen: false)
                      .deleteFirmDetails(
                          widget.firmDetails[widget.index]['Firm_Id'], token)
                      .then((value) {
                    if (value == 200 || value == 204) {
                      // Provider.of<InfrastructureApis>(context, listen: false)
                      //     .getFirmDetails(token)
                      //     .then((value1) {});
                      showDialog(
                        context: context,
                        builder: (ctx) => SuccessDialog(
                            title: 'Success',
                            subTitle: 'SuccessFully deleted the Firm'),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (ctx) => FailureDialog(
                            title: 'Failed',
                            subTitle: 'Something Went Wrong Please Try Again'),
                      );
                    }
                  });
                });
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
