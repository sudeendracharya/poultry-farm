import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/breed_info/providers/breed_info_apicalls.dart';
import 'package:provider/provider.dart';
import 'package:excel/excel.dart';

import 'package:file_picker/file_picker.dart';

import '../../widgets/failure_dialog.dart';
import '../../widgets/success_dialog.dart';
import '../providers/activity_plan_apis.dart';

class AddActivityPlan extends StatefulWidget {
  AddActivityPlan({Key? key}) : super(key: key);
  static const routeName = '/AddActivityPlan';

  @override
  _AddActivityPlanState createState() => _AddActivityPlanState();
}

class _AddActivityPlanState extends State<AddActivityPlan> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController controller = TextEditingController();

  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(left: 8.0);
  }

  var ActivityId;
  var breedVersionId;
  var doctorName = '';
  List sendData = [];
  List displayData = [];

  var activityPlan = {
    'Age': null,
    'Activity_Name': '',
    'Notification_Prior_To_Activity': null,
  };
  var activityHeader = {
    'Recommended_By': '',
    'Breed_Version_Id': null,
  };

  Map<String, dynamic> activity = {
    'Activity_Plan': '',
    'Activity_Header': '',
  };

  List breedVersion = [];

  List activityHeaderData = [];
  @override
  void initState() {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;

      Provider.of<BreedInfoApis>(context, listen: false)
          .getBreedversionInfo(token)
          .then((value1) {});
    });

    super.initState();
  }

  void save() {
    var isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    if (sendData.isEmpty) {
      activity['Activity_Plan'] = activityPlan;
    } else {
      bool isExcelSheetValid = true;
      for (int i = 0; i < sendData.length; i++) {
        if (sendData[i]['Age'] == '' ||
            sendData[i]['Age'] == null ||
            sendData[i]['Activity_Name'] == '' ||
            sendData[i]['Activity_Name'] == null ||
            sendData[i]['Notification_Prior_To_Activity'] == '' ||
            sendData[i]['Notification_Prior_To_Activity'] == null) {
          Get.defaultDialog(
              title: 'Alert',
              middleText:
                  'one or more items in your excel sheet contains a null value',
              confirm: TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('ok')));
          isExcelSheetValid = false;
          return;
        }
      }
      if (isExcelSheetValid == true) {
        activity['Activity_Plan'] = sendData;
      }
    }

    activity['Activity_Header'] = activityHeader;

    // print(activity);

    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<ActivityApis>(context, listen: false)
          .addActivityPlanData(activity, token)
          .then((value) {
        if (value == 200 || value == 201) {
          showDialog(
            context: context,
            builder: (ctx) => SuccessDialog(
                title: 'Success', subTitle: 'SuccessFully Added Activity Plan'),
          );
          _formKey.currentState!.reset();
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
  }

  Future<void> getExcelFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      allowMultiple: false,
    )
        .then((value) {
      if (value != null) {
        var file = value.files.single.bytes;
        var excel = Excel.decodeBytes(value.files.single.bytes!);

        List names = ['Age', 'Activity_Name', 'Notification_Prior_To_Activity'];

        for (var table in excel.tables.keys) {
          for (int i = 1; i < excel.tables[table]!.rows.length; i++) {
            Map temp = {
              'Age': '',
              'Activity_Name': '',
              'Notification_Prior_To_Activity': ''
            };
            List tempList = [];
            // print(excel.tables[table]!.rows[i].length.toString());

            for (int j = 0; j < excel.tables[table]!.rows[i].length; j++) {
              // print(excel.tables[table]!.rows[i][j]!.value.toString());
              temp[names[j]] = excel.tables[table]!.rows[i][j] == null
                  ? ''
                  : excel.tables[table]!.rows[i][j]!.value;
              tempList.add(excel.tables[table]!.rows[i][j] == null
                  ? ''
                  : excel.tables[table]!.rows[i][j]!.value);
            }
            sendData.add(temp);
            displayData.add(tempList);
          }
        }

        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    activityHeaderData = Provider.of<ActivityApis>(context).activityHeader;
    breedVersion = Provider.of<BreedInfoApis>(context).breedVersion;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Activity Header and Plan'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Recommended By Doctor'),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            controller.text = value;
                          });
                        },
                        onSaved: (value) {
                          activityHeader['Recommended_By'] = value!;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 700,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Breed Version'),
                    Container(
                      width: 385,
                      child: DropdownButton(
                        value: breedVersionId,
                        items: breedVersion.map<DropdownMenuItem<String>>((e) {
                          return DropdownMenuItem(
                            child: Text(e['Breed_Version']),
                            value: e['Breed_Version'],
                            onTap: () {
                              // firmId = e['Firm_Code'];
                              activityHeader['Breed_Version_Id'] =
                                  e['Breed_Version_Id'].toString();
                            },
                          );
                        }).toList(),
                        hint: const Text('Please Choose Breed Name'),
                        onChanged: (value) {
                          setState(() {
                            breedVersionId = value as String;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Age'),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          activityPlan['Age'] = value!;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Activity Name'),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          activityPlan['Activity_Name'] = value!;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Notification Prior To Activity'),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          activityPlan['Notification_Prior_To_Activity'] =
                              value!;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25.0),
                    child: ElevatedButton(
                        onPressed: save, child: const Text('Save')),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25.0),
                    child: ElevatedButton(
                        onPressed: getExcelFile,
                        child: const Text('Upload Excel File')),
                  ),
                ],
              ),
              displayData.isEmpty
                  ? SizedBox()
                  : Expanded(
                      child: SingleChildScrollView(
                        child: DataTable(columns: const <DataColumn>[
                          DataColumn(label: Text('Age')),
                          DataColumn(label: Text('Activity Name')),
                          DataColumn(
                              label: Text('Notification Prior To Activity')),
                        ], rows: <DataRow>[
                          for (var data in displayData)
                            DataRow(
                              cells: <DataCell>[
                                for (var data in data)
                                  DataCell(
                                    Text(
                                      data.toString(),
                                    ),
                                  )
                              ],
                            )
                        ]),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
