import 'dart:convert';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/main.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/infrastructure/providers/infrastructure_apicalls.dart';
import 'package:poultry_login_signup/screens/dashboard_default_screen.dart';
import 'package:poultry_login_signup/screens/global_app_bar.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/add_ware_house_section_line_dialog.dart';
import '../widgets/add_warehouse_details.dart';
import '../widgets/edit_ware_house_section_dialog.dart';
import '../widgets/edit_ware_house_section_line_dialog.dart';
import '../widgets/edit_warehouse_details_dialog.dart';

// import '/widgets/add_warehouse_details.dart';

class WareHouseDetailsScreen extends StatefulWidget {
  WareHouseDetailsScreen({Key? key}) : super(key: key);
  static const routeName = '/WarehouseDetails';
  @override
  _WareHouseDetailsScreenState createState() => _WareHouseDetailsScreenState();
}

class _WareHouseDetailsScreenState extends State<WareHouseDetailsScreen> {
  var query = '';

  var _wareHouseId;

  var _wareHouseCode;

  var _wareHouseName;

  var _category;

  var _sections;

  var _lines;

  var _subCategory;

  var _plantName;

  bool _loading = true;

  List wareHouseSectionDetailsList = [];

  bool _multiSelected = true;
  var count = 0;

  List sectionCodeList = [];

  var _wareHouseCategoryId;

  var _wareHouseDescription;

  var _wareHouseCategoryDescription;

  var _wareHouseSubCategoryDescription;

  var _wareHouseSubCategoryId;

  var _plantId;

  Map<String, dynamic> individualWarehouseDetails = {};

  void refresh(int data) {
    getWareHouseData().then((value) {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<InfrastructureApis>(context, listen: false)
            .getWareHouseSectionDetails(_wareHouseId, token)
            .then((value1) {
          if (value1 == 200 || value1 == 201) {}
        });

        // Provider.of<InfrastructureApis>(context, listen: false)
        //     .getPlantDetails(token)
        //     .then((value1) {});
      });
      reRun();
    });
  }

  TextStyle baseHeadingStyle() {
    return GoogleFonts.roboto(
      fontWeight: FontWeight.w700,
      fontSize: 24,
      color: const Color.fromRGBO(0, 0, 0, 1),
    );
  }

  TextStyle headingStyle() {
    return GoogleFonts.roboto(
      textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
    );
  }

  TextStyle dataStyle() {
    return GoogleFonts.roboto(
      textStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
    );
  }

  Container getHeadingContainer(var data) {
    return Container(
      width: 200,
      height: 25,
      child: Text(
        data,
        style: headingStyle(),
      ),
    );
  }

  Container getDataContainer(var data) {
    return Container(
      width: 200,
      height: 25,
      child: Text(
        data,
        style: dataStyle(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getWareHouseData().then((value) {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<InfrastructureApis>(context, listen: false)
            .fetchIndividualWareHouseDetails(
              _wareHouseId,
              token,
            )
            .then((value1) {});
        Provider.of<InfrastructureApis>(context, listen: false)
            .getWareHouseSectionDetails(_wareHouseId, token)
            .then((value1) {
          if (value1 == 200 || value1 == 201) {}
        });

        // Provider.of<InfrastructureApis>(context, listen: false)
        //     .getPlantDetails(token)
        //     .then((value1) {});
      });
      reRun();
    });
  }

  Future<void> getWareHouseData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('WareHouseDetails')) {
      return;
    }
    final extratedUserData =
        //we should use dynamic as a another value not a Object
        json.decode(prefs.getString('WareHouseDetails')!)
            as Map<String, dynamic>;
    _wareHouseId = extratedUserData['WareHouseId'] ?? '';
    // _wareHouseCode = extratedUserData['WareHouseCode'] ?? '';
    // _wareHouseName = extratedUserData['WareHouseName'] ?? '';
    // _category = extratedUserData['Category'] ?? '';
    // _sections = extratedUserData['Sections'] ?? '';
    // _lines = extratedUserData['Lines'] ?? '';
    // _subCategory = extratedUserData['SubCategory'] ?? '';
    // _plantName = extratedUserData['PlantName'] ?? '';
    // _wareHouseCategoryId = extratedUserData['WareHouseCategoryId'] ?? '';
    // _wareHouseSubCategoryId = extratedUserData['WareHouseSubCategoryId'] ?? '';
    // _wareHouseDescription = extratedUserData['WareHouseDescription'] ?? '';
    // _wareHouseCategoryDescription =
    //     extratedUserData['WareHouseCategoryDescription'] ?? '';
    // _wareHouseSubCategoryDescription =
    //     extratedUserData['WareHouseSubCategoryDescription'] ?? '';
    // _plantId = extratedUserData['PlantId'] ?? '';
  }

  void updateWareHouseDatas(int data) {
    getWareHouseData().then((value) {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<InfrastructureApis>(context, listen: false)
            .fetchIndividualWareHouseDetails(
              _wareHouseId,
              token,
            )
            .then((value1) {});
      });
      // reRun();
    });
  }

  void reRun() {
    setState(() {
      _loading = false;
    });
  }

  void edit(Map<String, dynamic> data) {
    if (data['Selected'] == true) {
      count = count + 1;
      sectionCodeList.add(data);
    } else {
      count = count - 1;
      sectionCodeList.removeAt(data['index']);
    }
  }

  void deleteSections() {
    if (sectionCodeList.isNotEmpty) {
      List temp = [];
      for (var data in sectionCodeList) {
        temp.add(data['WareHouse_Section_Id']);
      }

      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<InfrastructureApis>(context, listen: false)
            .deleteWareHouseSectionDetails(temp, token)
            .then((value1) {
          if (value1 == 204 || value1 == 201) {
            refresh(100);
            successSnackbar('Successfully deleted the section');
          } else {
            failureSnackbar('Unable to delete section something went wrong');
          }
        });

        // Provider.of<InfrastructureApis>(context, listen: false)
        //     .getPlantDetails(token)
        //     .then((value1) {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final breadCrumpsStyle = Theme.of(context).textTheme.headline4;
    var width = MediaQuery.of(context).size.width;
    individualWarehouseDetails = Provider.of<InfrastructureApis>(
      context,
    ).individualWareHouseDetails;
    wareHouseSectionDetailsList = Provider.of<InfrastructureApis>(
      context,
    ).warehouseSection;
    return WillPopScope(
      onWillPop: () async {
        Get.toNamed(DashBoardDefaultScreen.routeName, arguments: 2);
        return true;
      },
      child: Scaffold(
        appBar: GlobalAppBar(query: query, appbar: AppBar()),
        body: _loading == true
            ? const Center(child: CircularProgressIndicator())
            : InteractiveViewer(
                panEnabled: false,
                scaleEnabled: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 43),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                moveToDashboard();
                                // Get.offUntil(
                                //   MaterialPageRoute(
                                //     builder: (BuildContext context) =>
                                //         SecondaryDashBoardScreen(),
                                //   ),
                                //   (route) =>
                                //       route ==
                                //       MaterialPageRoute(
                                //         builder: (BuildContext context) =>
                                //             MainDashBoardScreen(),
                                //       ),
                                // );
                              },
                              child: Text('Dashboard', style: breadCrumpsStyle),
                            ),
                            const Icon(
                              Icons.arrow_back_ios_new,
                              size: 15,
                            ),
                            TextButton(
                              onPressed: () {
                                Get.toNamed(DashBoardDefaultScreen.routeName,
                                    arguments: 2);
                              },
                              child: Text('Infrastructure',
                                  style: breadCrumpsStyle),
                            ),
                            const Icon(
                              Icons.arrow_back_ios_new,
                              size: 15,
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                individualWarehouseDetails.isEmpty
                                    ? ''
                                    : individualWarehouseDetails[
                                        'WareHouse_Name'],
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: const Color.fromRGBO(0, 0, 0, 0.5)),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    individualWarehouseDetails.isEmpty
                                        ? ''
                                        : individualWarehouseDetails[
                                            'WareHouse_Name'],
                                    style: GoogleFonts.roboto(
                                      textStyle: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 36),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 143),
                                    child: TextButton(
                                      onPressed: () {
                                        showGlobalDrawer(
                                            context: context,
                                            builder: (ctx) =>
                                                EditWareHouseDetailsDialog(
                                                  reFresh: updateWareHouseDatas,
                                                  categoryName:
                                                      individualWarehouseDetails[
                                                          'WareHouse_Category_Id__WareHouse_Category_Name'],
                                                  description:
                                                      _wareHouseDescription,
                                                  subCategoryName:
                                                      individualWarehouseDetails[
                                                          'WareHouse_Sub_Category_Id__WareHouse_Sub_Category_Name'],
                                                  wareHouseCode:
                                                      individualWarehouseDetails[
                                                          'WareHouse_Code'],
                                                  wareHouseId:
                                                      individualWarehouseDetails[
                                                          'WareHouse_Id'],
                                                  wareHouseName:
                                                      individualWarehouseDetails[
                                                          'WareHouse_Name'],
                                                  wareHouseCategoryId:
                                                      individualWarehouseDetails[
                                                          'WareHouse_Category_Id__WareHouse_Category_Id'],
                                                  wareHouseSubCategoryId:
                                                      individualWarehouseDetails[
                                                          'WareHouse_Sub_Category_Id__WareHouse_Sub_Category_Id'],
                                                  plantId:
                                                      individualWarehouseDetails[
                                                          'WareHouse_Plant_Id'],
                                                ),
                                            direction: AxisDirection.right);
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            'Edit Detail',
                                            style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 18,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          // const Icon(
                                          //   Icons.arrow_drop_down_outlined,
                                          //   size: 25,
                                          //   color: Colors.black,
                                          // )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0, left: 30),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text('User Details',
                                  style: baseHeadingStyle())),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40.0, top: 14),
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    getHeadingContainer('WareHouse Code'),
                                    const SizedBox(
                                      width: 49,
                                    ),
                                    getDataContainer(
                                        individualWarehouseDetails.isEmpty
                                            ? ''
                                            : individualWarehouseDetails[
                                                'WareHouse_Code']),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    getHeadingContainer('WareHouse Name'),
                                    const SizedBox(
                                      width: 49,
                                    ),
                                    getDataContainer(
                                      individualWarehouseDetails.isEmpty
                                          ? ''
                                          : individualWarehouseDetails[
                                              'WareHouse_Name'],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    getHeadingContainer('Plant Name'),
                                    const SizedBox(
                                      width: 49,
                                    ),
                                    getDataContainer(
                                      individualWarehouseDetails.isEmpty
                                          ? ''
                                          : individualWarehouseDetails[
                                                  'WareHouse_Plant_Id__Plant_Name']
                                              .toString(),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    getHeadingContainer('Description'),
                                    const SizedBox(
                                      width: 49,
                                    ),
                                    getDataContainer(
                                        individualWarehouseDetails.isEmpty
                                            ? ''
                                            : individualWarehouseDetails[
                                                    'Description'] ??
                                                ''),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0, left: 30),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text('WareHouse Category',
                                  style: baseHeadingStyle())),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40.0, top: 14),
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    getHeadingContainer('WareHouse Category'),
                                    const SizedBox(
                                      width: 49,
                                    ),
                                    getDataContainer(
                                      individualWarehouseDetails.isEmpty
                                          ? ''
                                          : individualWarehouseDetails[
                                                  'WareHouse_Category_Id__WareHouse_Category_Name']
                                              .toString(),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    getHeadingContainer('Description'),
                                    const SizedBox(
                                      width: 49,
                                    ),
                                    getDataContainer(individualWarehouseDetails
                                            .isEmpty
                                        ? ''
                                        : individualWarehouseDetails[
                                            'WareHouse_Category_Id__Description']),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0, left: 30),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text('WareHouse Sub Category',
                                  style: baseHeadingStyle())),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40.0, top: 14),
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    getHeadingContainer(
                                        'WareHouse Sub Category'),
                                    const SizedBox(
                                      width: 49,
                                    ),
                                    getDataContainer(
                                      individualWarehouseDetails.isEmpty
                                          ? ''
                                          : individualWarehouseDetails[
                                              'WareHouse_Sub_Category_Id__WareHouse_Sub_Category_Name'],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    getHeadingContainer('Description'),
                                    const SizedBox(
                                      width: 49,
                                    ),
                                    getDataContainer(
                                      individualWarehouseDetails.isEmpty
                                          ? ''
                                          : individualWarehouseDetails[
                                              'WareHouse_Sub_Category_Id__Description'],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0, left: 30),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Row(
                                children: [
                                  Text('Sections', style: baseHeadingStyle()),
                                  SizedBox(
                                    width: width / 4,
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        showGlobalDrawer(
                                          context: context,
                                          builder: (ctx) => AddWareHouseDetails(
                                            update: refresh,
                                            index: 2,
                                            id: _wareHouseId,
                                            wareHouseCode:
                                                individualWarehouseDetails[
                                                    'WareHouse_Code'],
                                          ),
                                          direction: AxisDirection.right,
                                        );
                                      },
                                      icon: const Icon(Icons.add)),
                                  IconButton(
                                      onPressed: () {
                                        if (sectionCodeList.isNotEmpty) {
                                          showGlobalDrawer(
                                              context: context,
                                              builder: (ctx) =>
                                                  EditWareHouseSectionDialog(
                                                    reFresh: refresh,
                                                    sectionCodes:
                                                        sectionCodeList,
                                                  ),
                                              direction: AxisDirection.right);
                                        } else {
                                          alertSnackBar(
                                              'please select the section to edit');
                                        }
                                      },
                                      icon: const Icon(Icons.edit)),
                                  IconButton(
                                      onPressed: () {
                                        deleteSections();
                                      },
                                      icon: const Icon(Icons.delete))
                                ],
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0, top: 28),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(right: 65.0),
                                          child: Text(''),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 170.0),
                                          child: Text(
                                            'Section ID',
                                            style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Line Count',
                                          style: GoogleFonts.roboto(
                                            textStyle: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 1),
                                                fontSize: 16),
                                          ),
                                        ),
                                        // Text(
                                        //   'Lines',
                                        //   style: headingStyle(),
                                        // )
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      width: width / 2.5,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            wareHouseSectionDetailsList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return DisplaySectionDetails(
                                            fetch: refresh,
                                            width: width,
                                            key: UniqueKey(),
                                            index: index,
                                            sectionDetailsList:
                                                wareHouseSectionDetailsList,
                                            update: edit,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class DisplaySectionDetails extends StatefulWidget {
  const DisplaySectionDetails({
    Key? key,
    required this.width,
    required this.sectionDetailsList,
    required this.index,
    required this.update,
    required this.fetch,
  }) : super(key: key);

  final double width;
  final List sectionDetailsList;
  final int index;
  final ValueChanged<Map<String, dynamic>> update;
  final ValueChanged<int> fetch;

  @override
  State<DisplaySectionDetails> createState() => _DisplaySectionDetailsState();
}

class _DisplaySectionDetailsState extends State<DisplaySectionDetails> {
  bool isOpened = false;
  ScrollController controller = ScrollController();

  List selectedSectionLine = [];

  var _selected = false;
  var selected = false;

  void fetch(int data) {
    widget.fetch(100);
  }

  void add(data) {
    if (selectedSectionLine.isEmpty) {
      selectedSectionLine.add(data);
    } else {
      if (selectedSectionLine.contains(data) == true) {
        selectedSectionLine.remove(data);
      } else {
        selectedSectionLine.add(data);
      }
    }
  }

  void deleteSectionLine() {
    if (selectedSectionLine.isNotEmpty) {
      List temp = [];
      for (var data in selectedSectionLine) {
        temp.add(data['warehouse_section_line__WareHouse_Section_Line_Id']);
      }
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<InfrastructureApis>(context, listen: false)
            .deleteWareHouseSectionLineDetails(temp, token)
            .then((value1) {
          if (value1 == 204 || value1 == 201) {
            successSnackbar('Successfully deleted the section line details');
            fetch(100);
          } else {
            failureSnackbar(
                'Something went wrong unable to delete section line');
          }
        });

        // Provider.of<InfrastructureApis>(context, listen: false)
        //     .getPlantDetails(token)
        //     .then((value1) {});
      });
    } else {
      alertSnackBar('Please select the section line');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      elevation: 0,
      children: [
        ExpansionPanel(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            headerBuilder: (context, isOpened) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 35.0),
                    child: Checkbox(
                        activeColor: Theme.of(context).backgroundColor,
                        value: selected,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              widget.update({
                                'Selected': true,
                                'Section_Code':
                                    widget.sectionDetailsList[widget.index]
                                        ['WareHouse_Section_Code'],
                                'index': widget.index,
                                'WareHouse_Section_Id':
                                    widget.sectionDetailsList[widget.index]
                                        ['WareHouse_Section_Id'],
                              });
                            } else {
                              widget.update({
                                'Selected': false,
                                'Section_Code':
                                    widget.sectionDetailsList[widget.index]
                                        ['WareHouse_Section_Code'],
                                'index': widget.index,
                              });
                            }

                            selected = value!;
                          });
                        }),
                  ),
                  widget.sectionDetailsList[widget.index]
                              ['WareHouse_Section_Code'] ==
                          null
                      ? const Expanded(child: Text('Name'))
                      : Expanded(
                          child: Text(widget.sectionDetailsList[widget.index]
                              ['WareHouse_Section_Code']),
                        ),
                  Expanded(
                    child: Text(widget
                        .sectionDetailsList[widget.index]['Section_Details']
                        .length
                        .toString()),
                  ),
                ],
              );
            },
            isExpanded: isOpened,
            // canTapOnHeader: true,
            body: Align(
              alignment: Alignment.topLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            showGlobalDrawer(
                                context: context,
                                builder: (ctx) => AddWareHouseSectionLineDialog(
                                      reFresh: fetch,
                                      sectionCode: widget
                                              .sectionDetailsList[widget.index]
                                          ['WareHouse_Section_Code'],
                                      addedLineCount: widget
                                          .sectionDetailsList[widget.index]
                                              ['Section_Details']
                                          .length,
                                      sectionId: widget
                                              .sectionDetailsList[widget.index]
                                          ['WareHouse_Section_Id'],
                                    ),
                                direction: AxisDirection.right);
                          },
                          icon: const Icon(Icons.add)),
                      IconButton(
                          onPressed: () {
                            if (selectedSectionLine.isNotEmpty) {
                              showGlobalDrawer(
                                  context: context,
                                  builder: (ctx) => EditSectionLineDialog(
                                        reFresh: fetch,
                                        lineData: selectedSectionLine,
                                      ),
                                  direction: AxisDirection.right);
                            } else {
                              alertSnackBar(
                                  'Please select the section lines to edit');
                            }
                          },
                          icon: const Icon(Icons.edit)),
                      IconButton(
                          onPressed: () {
                            deleteSectionLine();
                          },
                          icon: const Icon(Icons.delete)),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: DataTable(
                      columnSpacing: 10,
                      headingTextStyle: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Color.fromRGBO(0, 0, 0, 1),
                        ),
                      ),
                      columns: const <DataColumn>[
                        DataColumn(
                            label: Text(
                          'Line Id',
                          textAlign: TextAlign.left,
                        )),
                        DataColumn(label: Text('Box Count')),
                        DataColumn(label: Text('Max Box Capacity')),
                        DataColumn(
                          label: Text('Box Dimensions'),
                        ),
                      ],
                      rows: <DataRow>[
                        const DataRow(cells: [
                          DataCell(Text('')),
                          DataCell(Text('')),
                          DataCell(Text('')),
                          DataCell(Text(' H    B    L'))
                        ]),
                        for (var data in widget.sectionDetailsList[widget.index]
                            ['Section_Details'])
                          // for(var data in displayData)
                          DataRow(
                            selected: data['isSelected'],
                            onSelectChanged: (value) {
                              setState(() {
                                data['isSelected'] = value;
                                add(data);
                              });
                            },
                            cells: <DataCell>[
                              DataCell(
                                TextButton(
                                  onPressed: () async {},
                                  child: Text(
                                    data[
                                        'warehouse_section_line__WareHouse_Section_Line_Code'],
                                    style: GoogleFonts.roboto(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Color.fromRGBO(68, 68, 68, 1),
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                data['warehouse_section_line__WareHouse_Section_Line_Number_Of_Boxes'] ==
                                        null
                                    ? const Text('0')
                                    : Text(
                                        data['warehouse_section_line__WareHouse_Section_Line_Number_Of_Boxes']
                                            .toString(),
                                      ),
                              ),
                              DataCell(
                                data['warehouse_section_line__WareHouse_Section_Line_Maximum_Box_Capacity'] ==
                                        null
                                    ? const Text('0')
                                    : Text(
                                        data['warehouse_section_line__WareHouse_Section_Line_Maximum_Box_Capacity']
                                            .toString(),
                                      ),
                              ),
                              DataCell(Row(
                                children: [
                                  Text(
                                      '${data['warehouse_section_line__WareHouse_Section_Line_Box_Height']}, '),
                                  Text(
                                      '${data['warehouse_section_line__WareHouse_Section_Line_Box_Breadth']}, '),
                                  Text(
                                      '${data['warehouse_section_line__WareHouse_Section_Line_Box_Length']}, '),
                                  const Text('Inches')
                                ],
                              ))
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ],
      expansionCallback: (i, isOpen) => setState(
        () {
          isOpened = !isOpen;
        },
      ),
    );
  }
}

// class DisplayWareHouseDetails extends StatefulWidget {
//   const DisplayWareHouseDetails(
//       {Key? key, required this.wareHouseDetails, required this.index})
//       : super(key: key);
//   final List wareHouseDetails;
//   final int index;

//   @override
//   _DisplayWareHouseDetailsState createState() =>
//       _DisplayWareHouseDetailsState();
// }

// class _DisplayWareHouseDetailsState extends State<DisplayWareHouseDetails> {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 10,
//       child: ListTile(
//         title: Text(
//           widget.wareHouseDetails[widget.index]['WareHouse_Code'],
//         ),
//         // subtitle: Text(wareHouseCategoryDetails[index]['Plant_Code']),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(
//               onPressed: () {
//                 // Navigator.of(context).pushNamed(AddWareHouseDetails.routeName,
//                 //     arguments: widget.wareHouseDetails[widget.index]);
//                 Get.toNamed(AddWareHouseDetails.routeName,
//                     arguments: widget.wareHouseDetails[widget.index]);
//               },
//               icon: const Icon(Icons.edit),
//             ),
//             IconButton(
//               onPressed: () {
//                 Provider.of<Apicalls>(context, listen: false)
//                     .tryAutoLogin()
//                     .then((value) {
//                   var token =
//                       Provider.of<Apicalls>(context, listen: false).token;
//                   Provider.of<InfrastructureApis>(context, listen: false)
//                       .deleteWareHouseDetails(
//                           widget.wareHouseDetails[widget.index]['WareHouse_Id'],
//                           token)
//                       .then((value) {
//                     if (value == 200 || value == 204) {
//                       showDialog(
//                           context: context,
//                           builder: (ctx) => SuccessDialog(
//                               title: 'Success',
//                               subTitle:
//                                   'SuccessFully Added Ware House Details'));
//                     } else {
//                       showDialog(
//                           context: context,
//                           builder: (ctx) => FailureDialog(
//                               title: 'Failed',
//                               subTitle:
//                                   'Something Went Wrong Please Try Again'));
//                     }
//                   });
//                 });
//               },
//               icon: const Icon(Icons.delete),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
