import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:poultry_login_signup/sales_journal/providers/journal_api.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart';

import '../../colors.dart';
import '../../infrastructure/providers/infrastructure_apicalls.dart';
import '../../inventory/providers/inventory_api.dart';
import '../../items/providers/items_apis.dart';
import '../../main.dart';
import '../../providers/apicalls.dart';
import '../../widgets/modular_widgets.dart';

class AddSalesJournal extends StatefulWidget {
  AddSalesJournal(
      {Key? key,
      required this.reFresh,
      required this.editData,
      required this.customerType,
      required this.id,
      required this.name})
      : super(key: key);
  final ValueChanged<int> reFresh;
  final Map<String, dynamic> editData;
  final String customerType;
  final String id;
  final String name;

  @override
  State<AddSalesJournal> createState() => _AddSalesJournalState();
}

class _AddSalesJournalState extends State<AddSalesJournal>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();

  var activityId;
  var collectionStatusId;
  var IsClearedSelected;
  List batchPlanDetails = [];
  bool batchPlanValidation = true;
  String batchPlanValidationMessage = '';
  TextEditingController unitController = TextEditingController();
  TextEditingController saleCodeController = TextEditingController();
  bool saleCodeValidation = true;
  String saleCodeValidationMessage = '';
  TextEditingController customerNameController = TextEditingController();
  bool customerNameValidation = true;

  String customerNameValidationMessage = '';

  TextEditingController priceController = TextEditingController();

  bool rateValidation = true;

  String rateValidationMessage = '';

  TextEditingController itemController = TextEditingController();

  bool itemValidation = true;

  String itemValidationMessage = '';

  var itemCategoryId;

  bool itemCategoryValidation = true;

  String itemCategoryValidationMessage = '';

  List firmsList = [];

  List plantList = [];
  var firmId;
  var plantId;

  String firmIdValidationMessage = '';

  bool firmIdValidation = true;

  bool plantIdValidation = true;

  String plantIdValidationMessage = '';

  List itemSubCategory = [];
  var itemSubCategoryId;

  List productList = [];
  var productId;

  String itemSubCategoryValidationMessage = '';

  bool itemSubCategoryValidation = true;

  bool productValidation = true;

  String productValidationMessage = '';

  var unitId;

  List unitDetails = [];

  var cwUnitId = 'Kgs';

  var customerId;

  FocusNode customerNameFocus = FocusNode();

  bool customerFieldSelected = false;

  var selectedCustomerType;

  void _onCustomerFocusChange() {
    // if (customerNameFocus.hasFocus == false) {
    //   setState(() {
    //     customerFieldSelected = false;
    //   });
    // }
  }

  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(left: 8.0);
  }

  late AnimationController controller;
  late Animation<Offset> offset;

  var itemId;
  var batchId;
  var wareHouseId;
  List wareHouseDetails = [];
  var breedName;
  List plantDetails = [];
  var plantName;
  List birdAgeGroup = [];
  var birdName;

  List breedInfo = [];
  List activityHeaderData = [];
  var ActivityId;
  List medicationHeaderData = [];
  var medicationId;
  List vaccinationHeaderData = [];
  var vaccinationId;
  List breedVersion = [];
  var breedVersionId;
  List itemCategoryDetails = [];

  TextEditingController dateController = TextEditingController();
  TextEditingController shippingDateController = TextEditingController();
  TextEditingController eggGradingCodeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController cwQuantityController = TextEditingController();
  TextEditingController cwUnitController = TextEditingController();
  TextEditingController requiredQuantityController = TextEditingController();

  Map<String, dynamic> salesJournal = {};

  bool eggGradingCodeValidation = true;
  bool requiredQuantityValidation = true;
  bool quantityValidation = true;
  bool cwQuantityValidation = true;
  bool wareHouseIdValidation = true;
  bool breedIdValidation = true;
  bool cwUnitValidation = true;
  bool unitValidation = true;
  bool IsClearedValidation = true;
  bool vaccinationPlanIdValidation = true;
  bool requiredDateOfDeliveryValidation = true;
  bool shippingDateValidation = true;

  String requiredQuantityValidationMessage = '';
  String eggGradingCodeValidationMessage = '';
  String quantityValidationMessage = '';
  String cwQuantityValidationMessage = '';
  String wareHouseIdValidationMessage = '';
  String breedIdValidationMessage = '';
  String cwUnitValidationMessage = '';
  String unitValidationMessage = '';
  String IsClearedValidationMessage = '';
  String vaccinationPlanIdValidationMessage = '';
  String shippingDateValidationMessage = '';

  String requiredDateOfDeliveryValidationMessage = '';

  bool validate() {
    // if (eggGradingCodeController.text == '') {
    //   eggGradingCodeValidationMessage = 'Grading code cannot be empty';
    //   eggGradingCodeValidation = false;
    // } else {
    //   eggGradingCodeValidation = true;
    // }
    // // if (requiredQuantityController.text == '') {
    //   requiredQuantityValidationMessage = 'Required quantity cannot be empty';
    //   requiredQuantityValidation = false;
    // } else {
    //   requiredQuantityValidation = true;
    // }

    if (saleCodeController.text == '') {
      saleCodeValidationMessage = 'Sale code cannot be Empty';
      saleCodeValidation = false;
    } else {
      saleCodeValidation = true;
    }
    if (customerNameController.text.length > 18) {
      customerNameValidationMessage =
          'Customer name cannot be Greater then 18 Characters';
      customerNameValidation = false;
    } else if (customerNameController.text == '') {
      customerNameValidationMessage = 'Customer name cannot be Empty';
      customerNameValidation = false;
    } else {
      customerNameValidation = true;
    }
    if (priceController.text.isNum != true) {
      rateValidationMessage = 'Enter a valid price';
      rateValidation = false;
    } else if (priceController.text == '') {
      rateValidationMessage = 'Price cannot be Empty';
      rateValidation = false;
    } else {
      rateValidation = true;
    }
    if (batchId == null) {
      batchPlanValidationMessage = 'Batch Code Cannot be empty';
      batchPlanValidation = false;
    } else {
      batchPlanValidation = true;
    }
    if (itemCategoryId == null) {
      itemCategoryValidationMessage = 'Select item category';
      itemCategoryValidation = false;
    } else {
      itemCategoryValidation = true;
    }
    if (firmId == null) {
      firmIdValidationMessage = 'Select Firm';
      firmIdValidation = false;
    } else {
      firmIdValidation = true;
    }

    if (plantId == null) {
      plantIdValidationMessage = 'Select Plant';
      plantIdValidation = false;
    } else {
      plantIdValidation = true;
    }

    if (itemSubCategoryId == null) {
      itemSubCategoryValidationMessage = 'Select item sub category';
      itemSubCategoryValidation = false;
    } else {
      itemSubCategoryValidation = true;
    }
    if (productId == null) {
      itemValidationMessage = 'item name cannot be Empty';
      itemValidation = false;
    } else {
      itemValidation = true;
    }
    if (quantityController.text.isNum != true) {
      quantityValidationMessage = 'Enter a valid Quantity';
      quantityValidation = false;
    } else if (quantityController.text == '') {
      quantityValidationMessage = 'Quantity cannot be Empty';
      quantityValidation = false;
    } else {
      quantityValidation = true;
    }
    if (cwQuantityController.text == '') {
      cwQuantityValidationMessage = 'CW Quantity cannot be null';
      cwQuantityValidation = false;
    } else {
      cwQuantityValidation = true;
    }
    if (wareHouseId == null) {
      wareHouseIdValidationMessage = 'Select the warehouse';
      wareHouseIdValidation = false;
    } else {
      wareHouseIdValidation = true;
    }

    if (cwUnitId == '') {
      cwUnitValidationMessage = 'CW unit cannot be Empty';
      cwUnitValidation = false;
    } else {
      cwUnitValidation = true;
    }
    if (unitId == null) {
      unitValidationMessage = 'Unit cannot be Empty';
      unitValidation = false;
    } else {
      unitValidation = true;
    }
    // if (IsClearedSelected == null) {
    //   IsClearedValidationMessage = 'Select is cleared';
    //   IsClearedValidation = false;
    // } else {
    //   IsClearedValidation = true;
    // }

    if (shippingDateController.text == '') {
      shippingDateValidationMessage = 'Select Grading date';
      shippingDateValidation = false;
    } else {
      shippingDateValidation = true;
    }

    if (itemValidation == true &&
        itemCategoryValidation == true &&
        batchPlanValidation == true &&
        rateValidation == true &&
        customerNameValidation == true &&
        saleCodeValidation == true &&
        eggGradingCodeValidation == true &&
        quantityValidation == true &&
        cwQuantityValidation == true &&
        wareHouseIdValidation == true &&
        cwUnitValidation == true &&
        itemSubCategoryValidation == true &&
        unitValidation == true &&
        shippingDateValidation == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> getFirmList() async {
    await Provider.of<Apicalls>(context, listen: false)
        .tryAutoLogin()
        .then((value) async {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      await Provider.of<InfrastructureApis>(context, listen: false)
          .getFirmDetails(token)
          .then((value1) {});
    });
  }

  Future<void> getPlantList(var id) async {
    await Provider.of<Apicalls>(context, listen: false)
        .tryAutoLogin()
        .then((value) async {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      await Provider.of<InfrastructureApis>(context, listen: false)
          .getPlantDetails(token, id)
          .then((value1) {
        // setState(() {
        //   firmSelected = true;
        //   selectedFirmName = e['Firm_Name'];
        //   selectedFirmId = e['Firm_Id'];
        // });
      });
    });
  }

  Future<void> getWarehouseDetails(var id) async {
    await Provider.of<Apicalls>(context, listen: false)
        .tryAutoLogin()
        .then((value) async {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<InfrastructureApis>(context, listen: false)
          .getWarehouseDetails(id, token)
          .then((value1) {});
    });
  }

  void _datePicker() {
    showDatePicker(
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: ProjectColors.themecolor, // header background color
                onPrimary: Colors.black, // header text color
                onSurface: Colors.green, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.red, // button text color
                ),
              ),
            ),
            child: child!);
      },
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      // _startDate = pickedDate.millisecondsSinceEpoch;
      shippingDateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      salesJournal['Shipped_Date'] =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(pickedDate);

      setState(() {});
    });
  }

  // void _datePicker() {
  //   showDatePicker(
  //     builder: (context, child) {
  //       return Theme(
  //           data: Theme.of(context).copyWith(
  //             colorScheme: ColorScheme.light(
  //               primary: ProjectColors.themecolor, // header background color
  //               onPrimary: Colors.black, // header text color
  //               onSurface: Colors.green, // body text color
  //             ),
  //             textButtonTheme: TextButtonThemeData(
  //               style: TextButton.styleFrom(
  //                 primary: Colors.red, // button text color
  //               ),
  //             ),
  //           ),
  //           child: child!);
  //     },
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2021),
  //     lastDate: DateTime(2025),
  //   ).then((pickedDate) {
  //     if (pickedDate == null) {
  //       return;
  //     }
  //     // _startDate = pickedDate.millisecondsSinceEpoch;
  //     dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
  //     eggGradingDetails['Required_Date_Of_Delivery'] =
  //         DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(pickedDate);

  //     setState(() {});
  //   });
  // }

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

  @override
  void initState() {
    super.initState();
    // customerNameFocus.addListener(_onCustomerFocusChange);
    if (widget.editData.isEmpty) {
      saleCodeController.text = getRandom(4, 'INV-');
    }

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    //scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.linear);
    offset = Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
        .animate(controller);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
    if (widget.editData.isNotEmpty) {
      shippingDateController.text = widget.editData['Shipped_Date'];
      salesJournal['Shipped_Date'] = widget.editData['Shipped_Date'];
      quantityController.text = widget.editData['Quantity'].toString();
      salesJournal['Quantity'] = widget.editData['Quantity'];
      cwQuantityController.text = widget.editData['CW_Quantity'].toString();
      salesJournal['CW_Quantity'] = widget.editData['CW_Quantity'];
      cwUnitController.text = widget.editData['CW_Unit'];
      salesJournal['CW_Unit'] = widget.editData['CW_Unit'];
      unitController.text = widget.editData['Quantity_Unit'].toString();
      salesJournal['Quantity_Unit'] = widget.editData['Quantity_Unit'];
      itemController.text = widget.editData['Item'];
      salesJournal['Item'] = widget.editData['Item'];
      customerNameController.text = widget.editData['Customer_Name'];
      salesJournal['Customer_Name'] = widget.editData['Customer_Name'];
      saleCodeController.text = widget.editData['Sale_Code'];
      salesJournal['Sale_Code'] = widget.editData['Sale_Code'];
      priceController.text = widget.editData['Rate'].toString();
      salesJournal['Rate'] = widget.editData['Rate'];
    }

    selectedCustomerType = widget.customerType;
    customerNameController.text = widget.name;
    customerId = widget.id;

    Provider.of<Apicalls>(context, listen: false)
        .tryAutoLogin()
        .then((value) async {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      var platId = await fetchPlant();

      Provider.of<InventoryApi>(context, listen: false).getBatch(token);

      Provider.of<ItemApis>(context, listen: false)
          .getItemCategory(token)
          .then((value1) {});
      Provider.of<Apicalls>(context, listen: false)
          .getStandardUnitValues(token);
    });
  }

  @override
  void dispose() {
    customerNameFocus.removeListener(_onCustomerFocusChange);
    customerNameFocus.dispose();
    super.dispose();
  }

  void getItemSubCategory(var id) {
    Provider.of<Apicalls>(context, listen: false)
        .tryAutoLogin()
        .then((value) async {
      var token = Provider.of<Apicalls>(context, listen: false).token;

      Provider.of<ItemApis>(context, listen: false)
          .getItemSubCategory(token, id)
          .then((value1) {});
    });
  }

  void getProducts(var subCategoryId) {
    fetchCredientials().then((token) {
      Provider.of<ItemApis>(context, listen: false)
          .getproductlist(token, subCategoryId);
    });
  }

  var isValid = true;
  List itemList = [];

  void edit(int index) {
    setState(() {
      itemSubCategoryId = itemList[index]['Item_SubCategory'];
      itemCategoryId = itemList[index]['Item_Category'];
      wareHouseId = itemList[index]['WarehouseCode'];
      productId = itemList[index]['Item'];
      batchId = itemList[index]['Batch_Code'];
      priceController.text = itemList[index]['Price'];
      quantityController.text = itemList[index]['Quantity'];
      unitId = itemList[index]['Unit'];
      cwQuantityController.text = itemList[index]['CW_Quantity'];
      cwUnitId = itemList[index]['CW_Unit'];

      itemList.removeAt(index);
    });
  }

  void delete(int index) {
    setState(() {
      itemList.removeAt(index);
    });
  }

  void addItems() {
    isValid = validate();
    if (!isValid) {
      setState(() {});
      return;
    }
    String total = (double.parse(quantityController.text) *
            double.parse(priceController.text))
        .toStringAsFixed(2);
    itemList.add({
      'WarehouseCode': wareHouseId,
      'Item': productId,
      'Batch_Code': batchId,
      'Price': priceController.text,
      'Quantity': quantityController.text,
      'Unit': unitId,
      'CW_Quantity': cwQuantityController.text,
      'CW_Unit': cwUnitId,
      'Item_Category': itemCategoryId,
      'Item_SubCategory': itemSubCategoryId,
      'Total': total,
    });
    setState(() {
      itemSubCategoryId = null;
      itemCategoryId = null;
      wareHouseId = null;
      productId = null;
      batchId = null;
      priceController.text = '';
      quantityController.text = '';
      unitId = null;
      cwQuantityController.text = '';
      cwUnitId = 'Kgs';
    });
  }

  void save() {
    if (itemList.isEmpty) {
      Get.defaultDialog(
          titleStyle: const TextStyle(color: Colors.black),
          title: 'Alert',
          middleText: 'Please Add Items to the table..',
          confirm: TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Ok')));
      return;
    }
    _formKey.currentState!.save();

    salesJournal['Customer_Type'] = selectedCustomerType;

    if (selectedCustomerType == 'Individual') {
      salesJournal['Customer_Id'] = customerId;
    } else {
      salesJournal['Company_Id'] = customerId;
    }

    salesJournal['Item_Details'] = itemList;

    print(salesJournal.toString());

    // if (widget.editData.isNotEmpty) {
    //   Provider.of<Apicalls>(context, listen: false)
    //       .tryAutoLogin()
    //       .then((value) {
    //     var token = Provider.of<Apicalls>(context, listen: false).token;
    //     Provider.of<JournalApi>(context, listen: false)
    //         .updateCustomerSalesJournalInfo(
    //             salesJournal, widget.editData['Sale_Id'], token)
    //         .then((value) {
    //       if (value == 202 || value == 201) {
    //         widget.reFresh(100);
    //         Get.back();
    //         successSnackbar('Successfully updated sales data');
    //       } else {
    //         failureSnackbar('Unable to update data something went wrong');
    //       }
    //     });
    //   });
    // } else {
    //   if (selectedCustomerType == 'Individual') {
    //     Provider.of<Apicalls>(context, listen: false)
    //         .tryAutoLogin()
    //         .then((value) {
    //       var token = Provider.of<Apicalls>(context, listen: false).token;
    //       Provider.of<JournalApi>(context, listen: false)
    //           .addCustomerSalesJournalInfo(salesJournal, token)
    //           .then((value) {
    //         if (value == 200 || value == 201) {
    //           widget.reFresh(100);
    //           Get.back();
    //           successSnackbar('Successfully added sales data');
    //         } else {
    //           failureSnackbar('Unable to add data something went wrong');
    //         }
    //       });
    //     });
    //   } else {
    //     Provider.of<Apicalls>(context, listen: false)
    //         .tryAutoLogin()
    //         .then((value) {
    //       var token = Provider.of<Apicalls>(context, listen: false).token;
    //       Provider.of<JournalApi>(context, listen: false)
    //           .addCompanySalesJournalInfo(salesJournal, token)
    //           .then((value) {
    //         if (value == 200 || value == 201) {
    //           widget.reFresh(100);
    //           Get.back();
    //           successSnackbar('Successfully added sales data');
    //         } else {
    //           failureSnackbar('Unable to add data something went wrong');
    //         }
    //       });
    //     });
    //   }
    // }
  }

  Container headerContainer(String name) {
    return Container(
      width: 100,
      child: Text(
        name,
        style: headerStyle(),
      ),
    );
  }

  void searchCustomers(String name) {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<JournalApi>(context, listen: false)
          .searchCustomerInfo(name, token)
          .then((value) {
        if (value == 200 || value == 201) {
          // widget.reFresh(100);
          // Get.back();
          // successSnackbar('Successfully added sales data');
        } else {
          // failureSnackbar('Unable to add data something went wrong');
        }
      });
    });
  }

  void searchCompany(String name) {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<JournalApi>(context, listen: false)
          .searchCompanyInfo(name, token)
          .then((value) {
        if (value == 200 || value == 201) {
          // widget.reFresh(100);
          // Get.back();
          // successSnackbar('Successfully added sales data');
        } else {
          // failureSnackbar('Unable to add data something went wrong');
        }
      });
    });
  }

  double columnWidth = 40;

  TextStyle headerStyle() {
    return GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.w600);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double formWidth = size.width * 0.1;
    double formGap = size.width * 0.03;

    wareHouseDetails = Provider.of<InfrastructureApis>(
      context,
    ).warehouseDetails;

    batchPlanDetails = Provider.of<InventoryApi>(context).batchDetails;
    itemCategoryDetails = Provider.of<ItemApis>(context).itemcategory;
    firmsList = Provider.of<InfrastructureApis>(context).firmDetails;
    plantList = Provider.of<InfrastructureApis>(context).plantDetails;
    itemSubCategory = Provider.of<ItemApis>(context).itemSubCategory;
    productList = Provider.of<ItemApis>(context).productList;
    unitDetails = Provider.of<Apicalls>(context).standardUnitList;

    return Container(
      width: size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(color: Colors.black26),
      ),
      child: Drawer(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 20),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    customerFieldSelected = false;
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Sales Journal',
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                  color: Theme.of(context).backgroundColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 36)),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 36.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text(
                            'Add Sales Journal',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: formWidth,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('Sale Code'),
                              ),
                              Container(
                                width: formWidth,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        hintText: 'Enter Sale code',
                                        border: InputBorder.none),
                                    controller: saleCodeController,
                                    onSaved: (value) {
                                      salesJournal['Sale_Code'] = value!;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // SizedBox(
                          //   width: formGap,
                          // ),
                          // Column(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   children: [
                          //     Container(
                          //       width: formWidth,
                          //       padding: const EdgeInsets.only(bottom: 12),
                          //       child: const Text('Customer Type'),
                          //     ),
                          //     Container(
                          //       width: formWidth,
                          //       height: 36,
                          //       decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(8),
                          //         color: Colors.white,
                          //         border: Border.all(color: Colors.black26),
                          //       ),
                          //       child: Padding(
                          //         padding: const EdgeInsets.symmetric(
                          //             horizontal: 12, vertical: 6),
                          //         child: DropdownButtonHideUnderline(
                          //           child: DropdownButton(
                          //             onTap: () {},
                          //             value: selectedCustomerType,
                          //             items: ['Individual', 'Company']
                          //                 .map<DropdownMenuItem<String>>((e) {
                          //               return DropdownMenuItem(
                          //                 enabled: false,
                          //                 value: e,
                          //                 child: Text(e),
                          //               );
                          //             }).toList(),
                          //             hint: const Text('Select'),
                          //             onChanged: (value) {
                          //               setState(() {
                          //                 selectedCustomerType =
                          //                     value as String;
                          //               });
                          //             },
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          SizedBox(
                            width: formGap,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: formWidth,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('Customer Name'),
                              ),
                              Container(
                                width: formWidth,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: TextFormField(
                                    enabled: false,
                                    onTap: () {
                                      setState(() {
                                        customerFieldSelected = true;
                                      });
                                    },
                                    // focusNode: customerNameFocus,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter Customer name',
                                      border: InputBorder.none,
                                    ),
                                    controller: customerNameController,
                                    onChanged: (value) {
                                      if (value.length >= 2) {
                                        if (selectedCustomerType != null) {
                                          if (selectedCustomerType ==
                                              'Individual') {
                                            searchCustomers(value);
                                          } else {
                                            searchCompany(value);
                                          }
                                        } else {
                                          alertSnackBar(
                                              'Select the customer type first');
                                        }
                                      }
                                    },
                                    onSaved: (value) {
                                      salesJournal['Customer_Name'] = value!;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: formGap,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: formWidth,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('Firm Name'),
                              ),
                              Container(
                                width: formWidth,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      value: firmId,
                                      items: firmsList
                                          .map<DropdownMenuItem<String>>((e) {
                                        return DropdownMenuItem(
                                          value: e['Firm_Name'],
                                          onTap: () {
                                            // firmId = e['Firm_Code'];
                                            plantId = null;
                                            getPlantList(e['Firm_Id']);
                                            //print(warehouseCategory);
                                          },
                                          child: Text(e['Firm_Name']),
                                        );
                                      }).toList(),
                                      hint: const Text('Select'),
                                      onChanged: (value) {
                                        setState(() {
                                          firmId = value as String;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: formGap,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: formWidth,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('Plant Name'),
                              ),
                              Container(
                                width: formWidth,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      value: plantId,
                                      items: plantList
                                          .map<DropdownMenuItem<String>>((e) {
                                        return DropdownMenuItem(
                                          value: e['Plant_Name'],
                                          onTap: () {
                                            // firmId = e['Firm_Code'];
                                            wareHouseId = null;
                                            getWarehouseDetails(e['Plant_Id']);
                                            //print(warehouseCategory);
                                          },
                                          child: Text(e['Plant_Name']),
                                        );
                                      }).toList(),
                                      hint: const Text('Select'),
                                      onChanged: (value) {
                                        setState(() {
                                          plantId = value as String;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: formGap,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: formWidth,
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: const Text('Shipped Date'),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: formWidth,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                      border: Border.all(color: Colors.black26),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      child: TextFormField(
                                        controller: shippingDateController,
                                        decoration: const InputDecoration(
                                            hintText: 'Choose Shipped date',
                                            border: InputBorder.none),
                                        enabled: false,
                                        // onSaved: (value) {
                                        //   batchPlanDetails[
                                        //       'Required_Date_Of_Delivery'] = value!;
                                        // },
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: _datePicker,
                                      icon: Icon(
                                        Icons.date_range_outlined,
                                        color: ProjectColors.themecolor,
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Row(
                      children: [
                        saleCodeValidation == true
                            ? SizedBox(
                                width: size.width * 0.1,
                              )
                            : ModularWidgets.salesValidationDesign(
                                size, saleCodeValidationMessage),
                        SizedBox(
                          width: formGap,
                        ),
                        customerNameValidation == true
                            ? SizedBox(
                                width: size.width * 0.1,
                              )
                            : ModularWidgets.salesValidationDesign(
                                size, customerNameValidationMessage),
                        SizedBox(
                          width: formGap,
                        ),
                        firmIdValidation == true
                            ? SizedBox(
                                width: size.width * 0.1,
                              )
                            : ModularWidgets.salesValidationDesign(
                                size, firmIdValidationMessage),
                        SizedBox(
                          width: formGap,
                        ),
                        plantIdValidation == true
                            ? SizedBox(
                                width: size.width * 0.1,
                              )
                            : ModularWidgets.salesValidationDesign(
                                size, plantIdValidationMessage),
                        SizedBox(
                          width: formGap,
                        ),
                        shippingDateValidation == true
                            ? SizedBox(
                                width: size.width * 0.1,
                              )
                            : ModularWidgets.salesValidationDesign(
                                size, shippingDateValidationMessage),
                      ],
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.only(top: 24.0),
                    //   child: Column(
                    //     children: [
                    //       customerFieldSelected == true &&
                    //               selectedCustomerType == 'Individual'
                    //           ? Padding(
                    //               padding: const EdgeInsets.only(top: 8.0),
                    //               child: Container(
                    //                   width: formWidth,
                    //                   height: 300,
                    //                   child: Column(
                    //                     mainAxisAlignment:
                    //                         MainAxisAlignment.start,
                    //                     crossAxisAlignment:
                    //                         CrossAxisAlignment.start,
                    //                     children: [
                    //                       Consumer<JournalApi>(
                    //                         builder: (context, value, child) {
                    //                           return Expanded(
                    //                             child: ListView.builder(
                    //                               itemCount: value
                    //                                   .customerSearchResult
                    //                                   .length,
                    //                               itemBuilder:
                    //                                   (BuildContext context,
                    //                                       int index) {
                    //                                 return ListTile(
                    //                                     onTap: () {
                    //                                       customerNameController
                    //                                           .text = value
                    //                                                   .customerSearchResult[
                    //                                               index]
                    //                                           ['Customer_Name'];
                    //                                       customerId =
                    //                                           value.customerSearchResult[
                    //                                                   index][
                    //                                               'Customer_Id'];
                    //                                       setState(() {
                    //                                         customerFieldSelected =
                    //                                             false;
                    //                                       });
                    //                                       // setState(() {});
                    //                                     },
                    //                                     title: Text(
                    //                                       value.customerSearchResult[
                    //                                               index]
                    //                                           ['Customer_Name'],
                    //                                     ));
                    //                               },
                    //                             ),
                    //                           );
                    //                         },
                    //                       ),
                    //                       Consumer<JournalApi>(
                    //                         builder: (context, value, child) {
                    //                           return Expanded(
                    //                             child: ListView.builder(
                    //                               itemCount: value
                    //                                   .companySearchResultData
                    //                                   .length,
                    //                               itemBuilder:
                    //                                   (BuildContext context,
                    //                                       int index) {
                    //                                 return ListTile(
                    //                                     onTap: () {
                    //                                       customerNameController
                    //                                               .text =
                    //                                           value.companySearchResultData[
                    //                                                   index][
                    //                                               'Company_Name'];
                    //                                       customerId =
                    //                                           value.companySearchResultData[
                    //                                                   index][
                    //                                               'Company_Id'];
                    //                                       setState(() {
                    //                                         customerFieldSelected =
                    //                                             false;
                    //                                       });
                    //                                       // setState(() {});
                    //                                     },
                    //                                     title: Text(
                    //                                       value.companySearchResultData[
                    //                                               index]
                    //                                           ['Company_Name'],
                    //                                     ));
                    //                               },
                    //                             ),
                    //                           );
                    //                         },
                    //                       ),
                    //                     ],
                    //                   )),
                    //             )
                    //           : customerFieldSelected == true &&
                    //                   selectedCustomerType == 'Company'
                    //               ? Padding(
                    //                   padding: const EdgeInsets.only(top: 8.0),
                    //                   child: Container(
                    //                       width: formWidth,
                    //                       height: 300,
                    //                       child: Consumer<JournalApi>(
                    //                         builder: (context, value, child) {
                    //                           return Expanded(
                    //                             child: ListView.builder(
                    //                               itemCount: value
                    //                                   .companySearchResultData
                    //                                   .length,
                    //                               itemBuilder:
                    //                                   (BuildContext context,
                    //                                       int index) {
                    //                                 return ListTile(
                    //                                     onTap: () {
                    //                                       customerNameController
                    //                                               .text =
                    //                                           value.companySearchResultData[
                    //                                                   index][
                    //                                               'Company_Name'];
                    //                                       customerId =
                    //                                           value.companySearchResultData[
                    //                                                   index][
                    //                                               'Company_Id'];
                    //                                       setState(() {
                    //                                         customerFieldSelected =
                    //                                             false;
                    //                                       });
                    //                                       // setState(() {});
                    //                                     },
                    //                                     title: Text(
                    //                                       value.companySearchResultData[
                    //                                               index]
                    //                                           ['Company_Name'],
                    //                                     ));
                    //                               },
                    //                             ),
                    //                           );
                    //                         },
                    //                       )),
                    //                 )
                    //               : const SizedBox(),
                    //     ],
                    //   ),
                    // ),

                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Container(
                        width: size.width * 0.95,
                        height: size.height * 0.5,
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 150,
                                    child: Text(
                                      'WareHouse Code',
                                      style: headerStyle(),
                                    ),
                                  ),
                                  SizedBox(
                                    width: columnWidth,
                                  ),
                                  headerContainer('Item'),
                                  SizedBox(
                                    width: columnWidth,
                                  ),
                                  headerContainer('Batch Code'),
                                  SizedBox(
                                    width: columnWidth,
                                  ),
                                  headerContainer('Quantity'),
                                  SizedBox(
                                    width: columnWidth,
                                  ),
                                  Container(
                                    width: 60,
                                    child: Text(
                                      'Price',
                                      style: headerStyle(),
                                    ),
                                  ),
                                  SizedBox(
                                    width: columnWidth,
                                  ),
                                  Container(
                                    width: 60,
                                    child: Text(
                                      'Unit',
                                      style: headerStyle(),
                                    ),
                                  ),
                                  SizedBox(
                                    width: columnWidth,
                                  ),
                                  headerContainer('CW Quantity'),
                                  SizedBox(
                                    width: columnWidth,
                                  ),
                                  headerContainer('CW Unit'),
                                  SizedBox(
                                    width: columnWidth,
                                  ),
                                  headerContainer('Total'),
                                ],
                              ),
                              const Divider(),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: itemList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Row(
                                      key: UniqueKey(),
                                      children: [
                                        Container(
                                          width: 150,
                                          child: Text(
                                            itemList[index]['WarehouseCode'],
                                            style: headerStyle(),
                                          ),
                                        ),
                                        SizedBox(
                                          width: columnWidth,
                                        ),
                                        headerContainer(
                                            itemList[index]['Item']),
                                        SizedBox(
                                          width: columnWidth,
                                        ),
                                        headerContainer(
                                          itemList[index]['Batch_Code'],
                                        ),
                                        SizedBox(
                                          width: columnWidth,
                                        ),
                                        headerContainer(
                                          itemList[index]['Quantity']
                                              .toString(),
                                        ),
                                        SizedBox(
                                          width: columnWidth,
                                        ),
                                        Container(
                                          width: 60,
                                          child: Text(
                                            itemList[index]['Price'].toString(),
                                            style: headerStyle(),
                                          ),
                                        ),
                                        SizedBox(
                                          width: columnWidth,
                                        ),
                                        Container(
                                          width: 60,
                                          child: Text(
                                            itemList[index]['Unit'],
                                            style: headerStyle(),
                                          ),
                                        ),
                                        SizedBox(
                                          width: columnWidth,
                                        ),
                                        headerContainer(itemList[index]
                                                ['CW_Quantity']
                                            .toString()),
                                        SizedBox(
                                          width: columnWidth,
                                        ),
                                        headerContainer(
                                            itemList[index]['CW_Unit']),
                                        SizedBox(
                                          width: columnWidth,
                                        ),
                                        headerContainer(
                                            itemList[index]['Total']),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        TextButton.icon(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        ProjectColors
                                                            .themecolor)),
                                            icon: const Icon(Icons.edit,
                                                color: Colors.white),
                                            onPressed: () {
                                              edit(index);
                                            },
                                            label: const Text(
                                              'Edit',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        TextButton.icon(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        ProjectColors
                                                            .themecolor)),
                                            icon: const Icon(Icons.delete,
                                                color: Colors.white),
                                            onPressed: () {
                                              delete(index);
                                            },
                                            label: const Text(
                                              'Delete',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: formWidth,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('Ware house Code'),
                              ),
                              Container(
                                width: formWidth,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      value: wareHouseId,
                                      items: wareHouseDetails
                                          .map<DropdownMenuItem<String>>((e) {
                                        return DropdownMenuItem(
                                          value: e['WareHouse_Code'],
                                          onTap: () {
                                            // firmId = e['Firm_Code'];
                                            salesJournal['WareHouse_Id'] =
                                                e['WareHouse_Id'];
                                            //print(warehouseCategory);
                                          },
                                          child: Text(e['WareHouse_Code']),
                                        );
                                      }).toList(),
                                      hint: const Text('Select'),
                                      onChanged: (value) {
                                        setState(() {
                                          wareHouseId = value as String;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: formGap,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: formWidth,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('Item Category'),
                              ),
                              Container(
                                width: formWidth,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      value: itemCategoryId,
                                      items: itemCategoryDetails
                                          .map<DropdownMenuItem<String>>((e) {
                                        return DropdownMenuItem(
                                          value: e['Product_Category_Name'],
                                          onTap: () {
                                            // firmId = e['Firm_Code'];
                                            salesJournal[
                                                    'Product_Category_Id'] =
                                                e['Product_Category_Id'];

                                            getItemSubCategory(
                                                e['Product_Category_Id']);
                                            //print(warehouseCategory);
                                          },
                                          child:
                                              Text(e['Product_Category_Name']),
                                        );
                                      }).toList(),
                                      hint: const Text('Select'),
                                      onChanged: (value) {
                                        setState(() {
                                          itemCategoryId = value as String;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: formGap,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: formWidth,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('Item Sub Category'),
                              ),
                              Container(
                                width: formWidth,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      value: itemSubCategoryId,
                                      items: itemSubCategory
                                          .map<DropdownMenuItem<String>>((e) {
                                        return DropdownMenuItem(
                                          value: e['Product_Sub_Category_Name'],
                                          onTap: () {
                                            // firmId = e['Firm_Code'];
                                            salesJournal['Item_Sub_Category'] =
                                                e['Product_Sub_Category_Id'];

                                            getProducts(
                                                e['Product_Sub_Category_Id']);
                                            //print(warehouseCategory);
                                          },
                                          child: Text(
                                              e['Product_Sub_Category_Name']),
                                        );
                                      }).toList(),
                                      hint: const Text('Select'),
                                      onChanged: (value) {
                                        setState(() {
                                          itemSubCategoryId = value as String;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: formGap,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: formWidth,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('Product'),
                              ),
                              Container(
                                width: formWidth,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      value: productId,
                                      items: productList
                                          .map<DropdownMenuItem<String>>((e) {
                                        return DropdownMenuItem(
                                          value: e['Product_Name'],
                                          onTap: () {
                                            // firmId = e['Firm_Code'];
                                            salesJournal['Product_Id'] =
                                                e['Product_Id'];
                                            unitId =
                                                e['Unit_Of_Measure__Unit_Name'];
                                            salesJournal['Quantity_Unit'] =
                                                e['Unit_Of_Measure__Unit_Id'];
                                            //print(warehouseCategory);
                                          },
                                          child: Text(e['Product_Name']),
                                        );
                                      }).toList(),
                                      hint: const Text('Select'),
                                      onChanged: (value) {
                                        setState(() {
                                          productId = value as String;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: formGap,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: formWidth,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('Batch Code'),
                              ),
                              Container(
                                width: formWidth,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      value: batchId,
                                      items: batchPlanDetails
                                          .map<DropdownMenuItem<String>>((e) {
                                        return DropdownMenuItem(
                                          value: e['Batch_Plan_Code'],
                                          onTap: () {
                                            // firmId = e['Firm_Code'];
                                            salesJournal['Batch_Plan_Id'] =
                                                e['Batch_Plan_Id'];
                                            //print(warehouseCategory);
                                          },
                                          child: Text(e['Batch_Plan_Code']),
                                        );
                                      }).toList(),
                                      hint: const Text('Select'),
                                      onChanged: (value) {
                                        setState(() {
                                          batchId = value as String;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: formGap,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        wareHouseIdValidation == true
                            ? SizedBox(
                                width: size.width * 0.1,
                              )
                            : ModularWidgets.salesValidationDesign(
                                size, wareHouseIdValidationMessage),
                        SizedBox(
                          width: formGap,
                        ),
                        itemCategoryValidation == true
                            ? SizedBox(
                                width: size.width * 0.1,
                              )
                            : ModularWidgets.salesValidationDesign(
                                size, itemCategoryValidationMessage),
                        SizedBox(
                          width: formGap,
                        ),
                        itemSubCategoryValidation == true
                            ? SizedBox(
                                width: size.width * 0.1,
                              )
                            : ModularWidgets.salesValidationDesign(
                                size, itemSubCategoryValidationMessage),
                        SizedBox(
                          width: formGap,
                        ),
                        itemValidation == true
                            ? SizedBox(
                                width: size.width * 0.1,
                              )
                            : ModularWidgets.salesValidationDesign(
                                size, itemValidationMessage),
                        SizedBox(
                          width: formGap,
                        ),
                        batchPlanValidation == true
                            ? SizedBox(
                                width: size.width * 0.1,
                              )
                            : ModularWidgets.salesValidationDesign(
                                size, batchPlanValidationMessage),
                      ],
                    ),

                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     Container(
                    //       width: formWidth,
                    //       padding: const EdgeInsets.only(bottom: 12),
                    //       child: const Text('Product'),
                    //     ),
                    //     Container(
                    //       width: formWidth,
                    //       height: 36,
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(8),
                    //         color: Colors.white,
                    //         border: Border.all(color: Colors.black26),
                    //       ),
                    //       child: Padding(
                    //         padding: const EdgeInsets.symmetric(
                    //             horizontal: 12, vertical: 6),
                    //         child: DropdownButtonHideUnderline(
                    //           child: DropdownButton(
                    //             value: productId,
                    //             items: productList
                    //                 .map<DropdownMenuItem<String>>((e) {
                    //               return DropdownMenuItem(
                    //                 child: Text(e['Product_Name']),
                    //                 value: e['Product_Name'],
                    //                 onTap: () {
                    //                   // firmId = e['Firm_Code'];
                    //                   salesJournal['Product_Id'] =
                    //                       e['Product_Id'];
                    //                   unitId = e['Unit_Of_Measure__Unit_Name'];
                    //                   salesJournal['Quantity_Unit'] =
                    //                       e['Unit_Of_Measure__Unit_Id'];
                    //                   //print(warehouseCategory);
                    //                 },
                    //               );
                    //             }).toList(),
                    //             hint: const Text('Select'),
                    //             onChanged: (value) {
                    //               setState(() {
                    //                 productId = value as String;
                    //               });
                    //             },
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: formWidth,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('Price'),
                              ),
                              Container(
                                width: formWidth,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        hintText: 'Enter Price',
                                        border: InputBorder.none),
                                    controller: priceController,
                                    onSaved: (value) {
                                      salesJournal['Rate'] = value!;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: formGap,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: formWidth,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('Quantity'),
                              ),
                              Container(
                                width: formWidth,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: const InputDecoration(
                                        hintText: 'Enter Quantity',
                                        border: InputBorder.none),
                                    controller: quantityController,
                                    onSaved: (value) {
                                      salesJournal['Quantity'] = value!;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: formGap,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: formWidth,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('Unit'),
                              ),
                              Container(
                                width: formWidth,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      value: unitId,
                                      items: unitDetails
                                          .map<DropdownMenuItem<String>>((e) {
                                        return DropdownMenuItem(
                                          value: e['Unit_Name'],
                                          onTap: () {
                                            // firmId = e['Firm_Code'];
                                            salesJournal['Quantity_Unit'] =
                                                e['Unit_Id'];

                                            //print(warehouseCategory);
                                          },
                                          child: Text(e['Unit_Name']),
                                        );
                                      }).toList(),
                                      hint: const Text('Select'),
                                      onChanged: (value) {
                                        setState(() {
                                          unitId = value as String;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: formGap,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: formWidth,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('CW Quantity'),
                              ),
                              Container(
                                width: formWidth,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        hintText: 'Enter cw quantity',
                                        border: InputBorder.none),
                                    controller: cwQuantityController,
                                    onSaved: (value) {
                                      salesJournal['CW_Quantity'] = value!;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: formGap,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: formWidth,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('CW Unit'),
                              ),
                              Container(
                                width: formWidth,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      value: cwUnitId,
                                      items: unitDetails
                                          .map<DropdownMenuItem<String>>((e) {
                                        return DropdownMenuItem(
                                          value: e['Unit_Name'],
                                          onTap: () {
                                            // firmId = e['Firm_Code'];
                                            salesJournal['CW_Unit'] =
                                                e['Unit_Id'];

                                            //print(warehouseCategory);
                                          },
                                          child: Text(e['Unit_Name']),
                                        );
                                      }).toList(),
                                      hint: const Text('Please Choose Unit'),
                                      onChanged: (value) {
                                        setState(() {
                                          cwUnitId = value as String;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: formGap,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: const SizedBox()),
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              ProjectColors.themecolor),
                                    ),
                                    onPressed: addItems,
                                    child: const Text('Add')),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        rateValidation == true
                            ? SizedBox(
                                width: size.width * 0.1,
                              )
                            : ModularWidgets.salesValidationDesign(
                                size, rateValidationMessage),
                        SizedBox(
                          width: formGap,
                        ),
                        quantityValidation == true
                            ? SizedBox(
                                width: size.width * 0.1,
                              )
                            : ModularWidgets.salesValidationDesign(
                                size, quantityValidationMessage),
                        SizedBox(
                          width: formGap,
                        ),
                        unitValidation == true
                            ? SizedBox(
                                width: size.width * 0.1,
                              )
                            : ModularWidgets.salesValidationDesign(
                                size, unitValidationMessage),
                        SizedBox(
                          width: formGap,
                        ),
                        cwQuantityValidation == true
                            ? SizedBox(
                                width: size.width * 0.1,
                              )
                            : ModularWidgets.salesValidationDesign(
                                size, cwQuantityValidationMessage),
                        SizedBox(
                          width: formGap,
                        ),
                        cwUnitValidation == true
                            ? SizedBox(
                                width: size.width * 0.1,
                              )
                            : ModularWidgets.salesValidationDesign(
                                size, cwUnitValidationMessage),
                      ],
                    ),

                    Consumer<JournalApi>(builder: (context, value, child) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: value.salesException.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ModularWidgets.exceptionDesign(
                              MediaQuery.of(context).size,
                              value.salesException[index][0]);
                        },
                      );
                    }),
                    widget.editData.isEmpty
                        ? ModularWidgets.globalAddDetailsDialog(size, save)
                        : ModularWidgets.globalUpdateDetailsDialog(size, save),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
