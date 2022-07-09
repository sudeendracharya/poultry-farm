import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_login_signup/breed_info/widgets/edit_bird_age_grouping_dialog.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/breed_info/providers/breed_info_apicalls.dart';
import 'package:provider/provider.dart';
import '../../colors.dart';
import '../../main.dart';
import '../../styles.dart';
import '../../widgets/administration_search_widget.dart';
import '../providers/breed_info_apicalls.dart';
import '../widgets/add_bird_age_group_dialog.dart';

class BirdAgeGroup extends StatefulWidget {
  BirdAgeGroup({Key? key}) : super(key: key);
  static const routeName = '/BirdAgeGroup';
  @override
  _BirdAgeGroupState createState() => _BirdAgeGroupState();
}

class _BirdAgeGroupState extends State<BirdAgeGroup> {
  var query = '';

  List list = [];

  var extratedPermissions;

  bool loading = true;

  void update(int data) {
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<BreedInfoApis>(context, listen: false)
            .getBirdAgeGroup(token);
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

  List birdsAgeGroup = [];
  List selectedActivityIds = [];
  int defaultRowsPerPage = 3;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    getPermission('Bird_Age_Grouping').then((value) {
      extratedPermissions = value;
      setState(() {
        loading = false;
      });
    });
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<BreedInfoApis>(context, listen: false)
            .getBirdAgeGroup(token);
      }
    });
    super.initState();
  }

  void updateCheckBox(int data) {
    setState(() {});
  }

  void delete() {
    if (selectedBirdAgeGroup.isEmpty) {
      alertSnackBar('Please select the checkbox to delete');
    } else {
      List temp = [];
      for (var data in selectedBirdAgeGroup) {
        temp.add(data['Bird_Age_Id']);
      }
      fetchCredientials().then((token) {
        if (token != '') {
          Provider.of<BreedInfoApis>(context, listen: false)
              .deleteBirdAgeGroup(temp, token)
              .then((value) {
            update(100);
          });
        }
      });
    }
  }

  void searchBook(String query) {
    final searchOutput = birdsAgeGroup.where((details) {
      final birdName = details['Name'].toString().toLowerCase();

      final searchName = query.toLowerCase();

      return birdName.contains(searchName);
    }).toList();

    setState(() {
      this.query = query;
      list = searchOutput;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    birdsAgeGroup = Provider.of<BreedInfoApis>(context).birdAgeGroup;
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
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 34,
                    ),
                    Text(
                      'Bird Age Group',
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
                            hintText: 'Search'),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          extratedPermissions['Create'] == true
                              ? IconButton(
                                  onPressed: () {
                                    showGlobalDrawer(
                                            context: context,
                                            builder: (ctx) => AddBirdAgeGroup(
                                                  reFresh: update,
                                                ),
                                            direction: AxisDirection.right)
                                        .then((value) {});
                                  },
                                  icon: const Icon(Icons.add),
                                )
                              : const SizedBox(),
                          const SizedBox(
                            width: 10,
                          ),
                          extratedPermissions['Edit'] == true
                              ? selectedBirdAgeGroup.length == 1
                                  ? IconButton(
                                      onPressed: () {
                                        showGlobalDrawer(
                                            context: context,
                                            builder: (ctx) =>
                                                EditBirdAgeGroupingDialog(
                                                  birdAgeid:
                                                      selectedBirdAgeGroup[0]
                                                              ['Bird_Age_Id']
                                                          .toString(),
                                                  breedId:
                                                      selectedBirdAgeGroup[0]
                                                          ['Breed_Id'],
                                                  endWeek:
                                                      selectedBirdAgeGroup[0]
                                                              ['End_Week']
                                                          .toString(),
                                                  name: selectedBirdAgeGroup[0]
                                                      ['Name'],
                                                  startWeek:
                                                      selectedBirdAgeGroup[0]
                                                              ['Start_Week']
                                                          .toString(),
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
                      child: SizedBox(
                        width: size.width * 0.4,
                        child: PaginatedDataTable(
                          source: MySearchData(
                              query == '' ? birdsAgeGroup : list,
                              updateCheckBox),
                          arrowHeadColor: ProjectColors.themecolor,
                          columns: const [
                            DataColumn(
                                label: Text('Birds Age Group',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Age From',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Age To',
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

List selectedBirdAgeGroup = [];

class MySearchData extends DataTableSource {
  final List<dynamic> data;

  final ValueChanged<int> reFresh;

  MySearchData(this.data, this.reFresh);

  @override
  int get selectedRowCount => 0;

  DataRow displayRows(int index) {
    return DataRow(
        selected: data[index]['Is_Selected'],
        onSelectChanged: (value) {
          data[index]['Is_Selected'] = value;
          if (selectedBirdAgeGroup.isEmpty) {
            selectedBirdAgeGroup.add(data[index]);
          } else {
            if (value == true) {
              selectedBirdAgeGroup.add(data[index]);
            } else {
              selectedBirdAgeGroup.remove(data[index]);
            }
          }
          reFresh(100);
          // print(selectedBirdAgeGroup);
        },
        cells: [
          DataCell(
            Text(
              data[index]['Name'].toString(),
            ),
          ),
          DataCell(
            Text(
              data[index]['Start_Week'].toString(),
            ),
          ),
          DataCell(
            Text(
              data[index]['End_Week'].toString(),
            ),
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
