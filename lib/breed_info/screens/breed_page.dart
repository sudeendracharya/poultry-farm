import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:poultry_login_signup/breed_info/widgets/add_breed_dialog.dart';
import 'package:poultry_login_signup/breed_info/widgets/edit_breed_dialog.dart';
import 'package:poultry_login_signup/colors.dart';
import 'package:poultry_login_signup/main.dart';
import 'package:provider/provider.dart';

import '../../providers/apicalls.dart';
import '../../styles.dart';
import '../../widgets/administration_search_widget.dart';
import '../providers/breed_info_apicalls.dart';

class BreedPage extends StatefulWidget {
  BreedPage({Key? key}) : super(key: key);

  @override
  State<BreedPage> createState() => _BreedPageState();
}

class _BreedPageState extends State<BreedPage> {
  var query = '';

  List list = [];

  void updateCheckBox(int data) {
    setState(() {});
  }

  void update(int data) {
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<BreedInfoApis>(context, listen: false)
            .getBreed(token)
            .then((value) {
          selectedBreeds.clear();
        });
      }
    });
  }

  Future<String> fetchCredientials() async {
    bool data =
        await Provider.of<Apicalls>(context, listen: false).tryAutoLogin();

    if (data != false) {
      var token = Provider.of<Apicalls>(context, listen: false).token;

      return token;
    } else {
      return '';
    }
  }

  List breedDetails = [];
  List selectedActivityIds = [];
  var extratedPermissions;
  bool loading = true;
  @override
  void initState() {
    selectedBreeds.clear();
    getPermission('Breed').then((value) {
      extratedPermissions = value;
      setState(() {
        loading = false;
      });
    });
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<BreedInfoApis>(context, listen: false).getBreed(token);
      }
    });
    super.initState();
  }

  int defaultRowsPerPage = 3;

  void delete() {
    if (selectedBreeds.isEmpty) {
      alertSnackBar('Please select the checkbox to delete');
    } else {
      List temp = [];
      for (var data in selectedBreeds) {
        temp.add(data['Breed_Id']);
      }
      fetchCredientials().then((token) {
        if (token != '') {
          Provider.of<BreedInfoApis>(context, listen: false)
              .deleteBreeds(temp, token)
              .then((value) {
            if (value == 204) {
              successSnackbar('Successfully deleted the data');
              update(100);
              selectedBreeds.clear();
            } else {
              update(100);
              selectedBreeds.clear();
              failureSnackbar('Unable to delete the data Something went wrong');
            }
          });
        }
      });
    }
  }

  void searchBook(String query) {
    final searchOutput = breedDetails.where((details) {
      final breedVendor = details['Breed_Name'].toString().toLowerCase();
      final searchName = query.toLowerCase();

      return breedVendor.contains(searchName);
    }).toList();

    setState(() {
      this.query = query;
      list = searchOutput;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = MediaQuery.of(context).size.width;
    breedDetails = Provider.of<BreedInfoApis>(context).breedInfo;
    List batchDetails = [];

    return loading == true
        ? const Center(
            child: Text('Loading'),
          )
        : extratedPermissions['View'] == false
            ? SizedBox(
                height: size.height * 0.5,
                child: const Center(
                    child: Text('You don\'t have access to view this page')),
              )
            : SizedBox(
                width: width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 34,
                    ),
                    Text(
                      'Breed',
                      style: ProjectStyles.contentHeaderStyle(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Container(
                        width: 253,
                        child: AdministrationSearchWidget(
                            search: (value) {},
                            reFresh: (value) {},
                            text: query,
                            onChanged: searchBook,
                            hintText: 'Breed Name'),
                      ),
                    ),
                    Container(
                      width: size.width * 0.35,
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          extratedPermissions['Create'] == true
                              ? IconButton(
                                  onPressed: () {
                                    showGlobalDrawer(
                                        context: context,
                                        builder: (ctx) => AddBreedDialog(
                                              reFresh: update,
                                            ),
                                        direction: AxisDirection.right);
                                  },
                                  icon: const Icon(Icons.add),
                                )
                              : const SizedBox(),
                          const SizedBox(
                            width: 10,
                          ),
                          extratedPermissions['Edit'] == true
                              ? selectedBreeds.length == 1
                                  ? IconButton(
                                      onPressed: () {
                                        showGlobalDrawer(
                                            context: context,
                                            builder: (ctx) => EditBreedDialog(
                                                  breedId: selectedBreeds[0]
                                                          ['Breed_Id']
                                                      .toString(),
                                                  breedName: selectedBreeds[0]
                                                      ['Breed_Name'],
                                                  vendor: selectedBreeds[0]
                                                      ['Vendor'],
                                                  reFresh: update,
                                                ),
                                            direction: AxisDirection.right);
                                      },
                                      icon: const Icon(Icons.edit),
                                    )
                                  : const SizedBox()
                              : const SizedBox(),
                          const SizedBox(
                            width: 10,
                          ),
                          extratedPermissions['Delete'] == true
                              ? IconButton(
                                  onPressed: delete,
                                  icon: const Icon(Icons.delete),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                        width: size.width * 0.35,
                        child: PaginatedDataTable(
                          arrowHeadColor: ProjectColors.themecolor,

                          source: MySearchBreedData(
                              query == '' ? breedDetails : list,
                              updateCheckBox),

                          columns: const [
                            DataColumn(
                                label: Text('Breed Name',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Vendor',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                          ],
                          onRowsPerPageChanged: (index) {
                            setState(() {
                              defaultRowsPerPage = index!;
                            });
                          },

                          availableRowsPerPage: const <int>[
                            3,
                            5,
                            10,
                            20,
                            40,
                            60,
                            80,
                          ],
                          columnSpacing: 20,
                          //  horizontalMargin: 10,
                          rowsPerPage: defaultRowsPerPage,
                          showCheckboxColumn: true,
                          // addEmptyRows: false,
                          checkboxHorizontalMargin: 30,
                          // onSelectAll: (value) {},
                          showFirstLastButtons: true,
                        ),
                      ),
                    ),
                  ],
                ),
              );
  }
}

List selectedBreeds = [];

class MySearchBreedData extends DataTableSource {
  final List<dynamic> data;

  final ValueChanged<int> reFresh;

  MySearchBreedData(this.data, this.reFresh);

  @override
  int get selectedRowCount => 0;

  DataRow displayRows(int index) {
    return DataRow(
        onSelectChanged: (value) {
          data[index]['Is_Selected'] = value;

          if (selectedBreeds.isEmpty) {
            selectedBreeds.add(data[index]);
          } else {
            if (value == true) {
              selectedBreeds.add(data[index]);
            } else {
              selectedBreeds.remove(data[index]);
            }
          }
          reFresh(100);
          // print('selected breeds $selectedBreeds');
        },
        selected: data[index]['Is_Selected'],
        cells: [
          DataCell(Text(data[index]['Breed_Name'].toString())),
          DataCell(
            Text(data[index]['Vendor'].toString()),
          ),
        ]);
  }

  @override
  DataRow getRow(int index) => displayRows(index);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;
}
