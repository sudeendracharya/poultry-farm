import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/breed_info/providers/breed_info_apicalls.dart';
import 'package:provider/provider.dart';

import '../../widgets/failure_dialog.dart';
import '../../widgets/success_dialog.dart';
import '../providers/activity_plan_apis.dart';

class AddMedicationPlan extends StatefulWidget {
  AddMedicationPlan({Key? key}) : super(key: key);
  static const routeName = '/AddMedicationPlan';

  @override
  _AddMedicationPlanState createState() => _AddMedicationPlanState();
}

class _AddMedicationPlanState extends State<AddMedicationPlan> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(left: 8.0);
  }

  TextEditingController controller = TextEditingController();

  var medicationId;

  var medicationPlan = {
    'Age': '',
    'Medication_Name': null,
    'Mode': null,
    'Site': null,
    'Dosage': '',
    'Dosage_Unit': '',
    'Notification_Prior_Days': null,
    'Description': null,
  };

  List medicationHeaderData = [];
  List breedVersion = [];
  var breedVersionId;
  List sendData = [];
  List displayData = [];

  var medicationHeader = {
    'Recommended_By': '',
    'Breed_Version_Id': '',
  };
  Map<String, dynamic> medicationActivity = {
    'Medication_Plan': '',
    'Medication_Header': '',
  };
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
      medicationActivity['Medication_Plan'] = medicationPlan;
    } else {
      medicationActivity['Medication_Plan'] = sendData;
    }

    medicationActivity['Medication_Header'] = medicationHeader;

    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<ActivityApis>(context, listen: false)
          .addMedicationPlan(medicationActivity, token)
          .then((value) {
        if (value == 200 || value == 201) {
          showDialog(
            context: context,
            builder: (ctx) => SuccessDialog(
                title: 'Success',
                subTitle: 'SuccessFully Added Medication Plan'),
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

        List names = [
          'Age',
          'Medication_Name',
          'Mode',
          'Site',
          'Dosage',
          'Dosage_Unit',
          'Notification_Prior_Days',
          'Description',
        ];

        for (var table in excel.tables.keys) {
          for (int i = 1; i < excel.tables[table]!.rows.length; i++) {
            Map temp = {
              'Age': '',
              'Medication_Name': null,
              'Mode': null,
              'Site': null,
              'Dosage': '',
              'Dosage_Unit': '',
              'Notification_Prior_Days': null,
              'Description': null,
            };
            List tempList = [];
            for (int j = 0; j < excel.tables[table]!.rows[i].length; j++) {
              temp[names[j]] = excel.tables[table]!.rows[i][j]!.value;
              tempList.add(excel.tables[table]!.rows[i][j]!.value);
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
    medicationHeaderData = Provider.of<ActivityApis>(context).medicationHeader;
    breedVersion = Provider.of<BreedInfoApis>(context).breedVersion;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medication Plan and Header'),
      ),
      body: SingleChildScrollView(
        child: Form(
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
                            medicationHeader['Recommended_By'] = value!;
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
                          items:
                              breedVersion.map<DropdownMenuItem<String>>((e) {
                            return DropdownMenuItem(
                              child: Text(e['Breed_Version']),
                              value: e['Breed_Version'],
                              onTap: () {
                                // firmId = e['Firm_Code'];
                                medicationHeader['Breed_Version_Id'] =
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
                            medicationPlan['Age'] = value!;
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
                      const Text('Medication Name'),
                      Container(
                        width: 400,
                        child: TextFormField(
                          onSaved: (value) {
                            medicationPlan['Medication_Name'] = value!;
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
                      const Text('Mode'),
                      Container(
                        width: 400,
                        child: TextFormField(
                          onSaved: (value) {
                            medicationPlan['Mode'] = value!;
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
                      const Text('Site'),
                      Container(
                        width: 400,
                        child: TextFormField(
                          onSaved: (value) {
                            medicationPlan['Site'] = value!;
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
                      const Text('Dosage'),
                      Container(
                        width: 400,
                        child: TextFormField(
                          onSaved: (value) {
                            medicationPlan['Dosage'] = value!;
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
                      const Text('Dosage Unit'),
                      Container(
                        width: 400,
                        child: TextFormField(
                          onSaved: (value) {
                            medicationPlan['Dosage_Unit'] = value!;
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
                      const Text('Notification Prior Days'),
                      Container(
                        width: 400,
                        child: TextFormField(
                          onSaved: (value) {
                            medicationPlan['Notification_Prior_Days'] = value!;
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
                      const Text('Description'),
                      Container(
                        width: 400,
                        child: TextFormField(
                          onSaved: (value) {
                            medicationPlan['Description'] = value!;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25.0),
                      child: ElevatedButton(
                          onPressed: save, child: const Text('Save')),
                    ),
                    SizedBox(
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
                sendData.isEmpty
                    ? const SizedBox()
                    : PaginatedDataTable(
                        columns: const [
                          DataColumn(label: Text('Age')),
                          DataColumn(label: Text('Medication Name')),
                          DataColumn(label: Text('Mode')),
                          DataColumn(label: Text('Site')),
                          DataColumn(
                            label: Text('Dosage'),
                          ),
                          DataColumn(label: Text('Dosage Unit')),
                          DataColumn(label: Text('Notification Prior Days')),
                          DataColumn(label: Text('Description')),
                        ],
                        source: MedicationExcelData(sendData),
                        showFirstLastButtons: true,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MedicationExcelData extends DataTableSource {
  MedicationExcelData(this.data);

  List data = [];
  @override
  DataRow? getRow(int index) => displayRows(index);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;

  DataRow displayRows(int index) {
    return DataRow(cells: [
      DataCell(Text('${data[index]['Age']}')),
      DataCell(Text('${data[index]['Medication_Name']}')),
      DataCell(Text('${data[index]['Mode']}')),
      DataCell(Text('${data[index]['Site']}')),
      DataCell(Text('${data[index]['Dosage']}')),
      DataCell(Text('${data[index]['Dosage_Unit']}')),
      DataCell(Text('${data[index]['Notification_Prior_Days']}')),
      DataCell(Text('${data[index]['Description']}')),
    ]);
  }
}
