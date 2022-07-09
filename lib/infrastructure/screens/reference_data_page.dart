import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/widgets/administration_search_widget.dart';

class ReferenceDataPage extends StatefulWidget {
  ReferenceDataPage({Key? key}) : super(key: key);

  @override
  _ReferenceDataPageState createState() => _ReferenceDataPageState();
}

class _ReferenceDataPageState extends State<ReferenceDataPage> {
  @override
  void initState() {
    super.initState();
  }

  var query = '';

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var halfWidth = MediaQuery.of(context).size.width / 2;

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Firms',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  width: 253,
                  child: AdministrationSearchWidget(
                      search: (value) {},
                      reFresh: (value) {},
                      text: query,
                      onChanged: (value) {},
                      hintText: 'Search'),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                padding: const EdgeInsets.only(top: 40),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.52,
                  child: InteractiveViewer(
                    alignPanAxis: true,
                    constrained: false,
                    // panEnabled: false,
                    scaleEnabled: false,
                    child: DataTable(
                        showCheckboxColumn: true,
                        columnSpacing: width <= 770
                            ? 45
                            : MediaQuery.of(context).size.width * 0.09765625,
                        headingTextStyle: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Color.fromRGBO(0, 0, 0, 1),
                          ),
                        ),
                        columns: const <DataColumn>[
                          DataColumn(
                              label: Text(
                            'Breed Id',
                            textAlign: TextAlign.left,
                          )),
                          DataColumn(label: Text('Breed Name')),
                          DataColumn(label: Text('Version')),
                          DataColumn(label: Text('Age Grouping')),
                        ],
                        rows: <DataRow>[
                          // for(var data in displayData)
                          // DataRow(
                          //   onSelectChanged: (value) {},
                          //   cells: <DataCell>[
                          //     // DataCell(
                          //     //   // TextButton(
                          //     //   //   onPressed: () async {
                          //     //   //     final prefs =
                          //     //   //         await SharedPreferences
                          //     //   //             .getInstance();
                          //     //   //     // final userData = json.encode(
                          //     //   //     //   {
                          //     //   //     //     'plantName': _plantName,
                          //     //   //     //     'batchName':
                          //     //   //     //         data['Batch_Code'],
                          //     //   //     //     'grading': data['Grading'],
                          //     //   //     //     'productionRate':
                          //     //   //     //         data['Production_Rate'],
                          //     //   //     //     'feedConsumptionRate': data[
                          //     //   //     //         'Feed_Consumption_Rate'],
                          //     //   //     //     'mortalityRate':
                          //     //   //     //         data['Mortality_Rate'],
                          //     //   //     //     'wareHouseCode':
                          //     //   //     //         data['WareHouse_Code']
                          //     //   //     //   },
                          //     //   //     // );
                          //     //   //     // prefs.setString(
                          //     //   //     //     'batchDetails', userData);

                          //     //   //   },
                          //     //   //   child:
                          //     //   // ),
                          //     // ),
                          //   ],
                          // ),
                        ]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
