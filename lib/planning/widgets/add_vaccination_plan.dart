import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/breed_info/providers/breed_info_apicalls.dart';
import 'package:provider/provider.dart';

import '../../widgets/failure_dialog.dart';
import '../../widgets/success_dialog.dart';
import '../providers/activity_plan_apis.dart';

class AddVaccinationPlan extends StatefulWidget {
  AddVaccinationPlan({Key? key}) : super(key: key);
  static const routeName = '/AddVaccinationPlan';

  @override
  _AddVaccinationPlanState createState() => _AddVaccinationPlanState();
}

class _AddVaccinationPlanState extends State<AddVaccinationPlan> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(left: 8.0);
  }

  var vaccinationId;
  var breedVersionId;
  TextEditingController controller = TextEditingController();
  List sendData = [];
  List displayData = [];

  var vaccinationHeader = {
    'Recommended_By': '',
    'Breed_Version_Id': null,
  };
  List breedVersion = [];

  var vaccinationPlan = {
    'Age': '',
    'Vaccination_Name': null,
    'Mode': null,
    'Site': null,
    'Dosage': null,
    'Dosage_Unit': null,
    'Vaccine_Store_Temperature': null,
    'Notification_Prior_Days': null,
    'Description': '',
  };
  List vaccinationHeaderData = [];
  Map<String, dynamic> vaccinationActivity = {
    'Vaccination_Plan': '',
    'Vaccination_Header': '',
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
      vaccinationActivity['Vaccination_Plan'] = vaccinationPlan;
    } else {
      vaccinationActivity['Vaccination_Plan'] = sendData;
    }

    vaccinationActivity['Vaccination_Header'] = vaccinationHeader;

    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<ActivityApis>(context, listen: false)
          .addVaccinationPlanData(vaccinationActivity, token)
          .then((value) {
        if (value == 200 || value == 201) {
          showDialog(
            context: context,
            builder: (ctx) => SuccessDialog(
                title: 'Success',
                subTitle: 'SuccessFully Added Vaccination Plan'),
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
          'Vaccination_Name',
          'Mode',
          'Site',
          'Dosage',
          'Dosage_Unit',
          'Vaccine_Store_Temperature',
          'Notification_Prior_Days',
          'Description',
        ];

        for (var table in excel.tables.keys) {
          for (int i = 1; i < excel.tables[table]!.rows.length; i++) {
            Map temp = {
              'Age': '',
              'Vaccination_Name': null,
              'Mode': null,
              'Site': null,
              'Dosage': null,
              'Dosage_Unit': null,
              'Vaccine_Store_Temperature': null,
              'Notification_Prior_Days': null,
              'Description': '',
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
    vaccinationHeaderData =
        Provider.of<ActivityApis>(context).vaccinationHeader;
    breedVersion = Provider.of<BreedInfoApis>(context).breedVersion;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Vaccination Plan and Header'),
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
                            vaccinationHeader['Recommended_By'] = value!;
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
                                vaccinationHeader['Breed_Version_Id'] =
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
                            vaccinationPlan['Age'] = value!;
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
                      const Text('Vaccination Name'),
                      Container(
                        width: 400,
                        child: TextFormField(
                          onSaved: (value) {
                            vaccinationPlan['Vaccination_Name'] = value!;
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
                            vaccinationPlan['Mode'] = value!;
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
                            vaccinationPlan['Site'] = value!;
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
                            vaccinationPlan['Dosage'] = value!;
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
                            vaccinationPlan['Dosage_Unit'] = value!;
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
                      const Text('Vaccine Store Temperature'),
                      Container(
                        width: 400,
                        child: TextFormField(
                          onSaved: (value) {
                            vaccinationPlan['Vaccine_Store_Temperature'] =
                                value!;
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
                            vaccinationPlan['Notification_Prior_Days'] = value!;
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
                            vaccinationPlan['Description'] = value!;
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
                sendData.isEmpty
                    ? const SizedBox()
                    : PaginatedDataTable(
                        columns: const [
                          DataColumn(label: Text('Age')),
                          DataColumn(label: Text('Vaccination Name')),
                          DataColumn(label: Text('Mode')),
                          DataColumn(label: Text('Site')),
                          DataColumn(
                            label: Text('Dosage'),
                          ),
                          DataColumn(label: Text('Dosage Unit')),
                          DataColumn(label: Text('Store Temperature')),
                          DataColumn(label: Text('Notification Prior Days')),
                          DataColumn(label: Text('Description')),
                        ],
                        source: ExcelData(sendData),
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

class ExcelData extends DataTableSource {
  ExcelData(this.data);

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
      DataCell(Text('${data[index]['Vaccination_Name']}')),
      DataCell(Text('${data[index]['Mode']}')),
      DataCell(Text('${data[index]['Site']}')),
      DataCell(Text('${data[index]['Dosage']}')),
      DataCell(Text('${data[index]['Dosage_Unit']}')),
      DataCell(Text('${data[index]['Vaccine_Store_Temperature']}')),
      DataCell(Text('${data[index]['Notification_Prior_Days']}')),
      DataCell(Text('${data[index]['Description']}')),
    ]);
  }
}


// 