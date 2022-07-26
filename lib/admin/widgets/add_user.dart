import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';

import 'package:provider/provider.dart';

import '../../colors.dart';
import '../../main.dart';
import '../../transfer_journal/providers/transfer_journal_apis.dart';
import '../../widgets/modular_widgets.dart';
import '../providers/admin_apis.dart';

class AddUser extends StatefulWidget {
  AddUser({Key? key, required this.reFresh, required this.editData})
      : super(key: key);
  static const routeName = '/AddUser';
  final ValueChanged<int> reFresh;
  final Map<String, dynamic> editData;
  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();

  List batchPlanDetails = [];

  bool batchPlanValidation = true;

  String batchPlanValidationMessage = '';

  TextEditingController userNameController = TextEditingController();

  TextEditingController firstNameController = TextEditingController();

  bool firstNameValidation = true;

  String firstNameValidationMessage = '';

  TextEditingController itemCategoryController = TextEditingController();

  bool itemCategoryNameValidation = true;

  String itemCategoryNameValidationMessage = '';

  TextEditingController statusController = TextEditingController();

  bool passwordValidation = true;

  String passwordValidationMessage = '';

  TextEditingController itemController = TextEditingController();

  bool itemValidation = true;

  String itemValidationMessage = '';

  var warehouseToCategoryId;

  bool warehouseToValidation = true;

  String warehouseToValidationMessage = '';

  TextEditingController receivedDateController = TextEditingController();

  bool receivedDateValidation = true;

  String receivedDateValidationMessage = '';

  bool collectionStatusValidation = true;

  String collectionStatusValidationMessage = '';

  var _shippedDate;

  var _receivedDate;

  var itemCategoryId;

  List itemSubCategoryDetails = [];

  var itemSubCategoryId;

  List productlist = [];

  var productId;

  TextEditingController passwordController = TextEditingController();

  TextEditingController ConfirmPasswordController = TextEditingController();

  bool ConfirmPasswordValidation = true;

  String ConfirmPasswordValidationMessage = '';

  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(left: 8.0);
  }

  late AnimationController controller;
  late Animation<Offset> offset;

  var batchId;
  var roleId;
  List roleDetails = [];

  List itemCategoryDetails = [];

  TextEditingController dateController = TextEditingController();
  TextEditingController joiningDateController = TextEditingController();
  TextEditingController eggGradingCodeController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController requiredQuantityController = TextEditingController();

  Map<String, dynamic> user = {
    'Received_Date': '',
    'Shipped_Date': '',
  };

  bool eggGradingCodeValidation = true;
  bool requiredQuantityValidation = true;
  bool lastNameValidation = true;
  bool emailValidation = true;
  bool roleIdValidation = true;
  bool breedIdValidation = true;
  bool mobileNumberValidation = true;
  bool userNameValidation = true;
  bool IsClearedValidation = true;
  bool vaccinationPlanIdValidation = true;
  bool requiredDateOfDeliveryValidation = true;
  bool shippingDateValidation = true;

  String requiredQuantityValidationMessage = '';
  String eggGradingCodeValidationMessage = '';
  String lastNameValidationMessage = '';
  String emailValidationMessage = '';
  String roleIdValidationMessage = '';
  String breedIdValidationMessage = '';
  String mobileNumberValidationMessage = '';
  String userNameValidationMessage = '';
  String IsClearedValidationMessage = '';
  String vaccinationPlanIdValidationMessage = '';
  String shippingDateValidationMessage = '';

  String requiredDateOfDeliveryValidationMessage = '';

  bool validate() {
    if (firstNameController.text.length > 27) {
      firstNameValidationMessage =
          'first name cannot be greater then 27 characters';
      firstNameValidation = false;
    } else if (firstNameController.text == '') {
      firstNameValidationMessage = 'first name cannot be empty';
      firstNameValidation = false;
    } else {
      firstNameValidation = true;
    }
    if (lastNameController.text.length > 27) {
      lastNameValidationMessage =
          'Last name cannot be greater then 27 characters';
      lastNameValidation = false;
    } else if (lastNameController.text == '') {
      lastNameValidationMessage = 'Last Name cannot be empty';
      lastNameValidation = false;
    } else {
      lastNameValidation = true;
    }

    if (roleId == null) {
      roleIdValidationMessage = 'Select the Role';
      roleIdValidation = false;
    } else {
      roleIdValidation = true;
    }
    if (mobileNumberController.text.isPhoneNumber == false) {
      mobileNumberValidationMessage = 'Enter a valid Mobile Number';
      mobileNumberValidation = false;
    } else if (mobileNumberController.text.startsWith('0')) {
      mobileNumberValidationMessage = 'Mobile Number cannot start with 0';
      mobileNumberValidation = false;
    } else if (mobileNumberController.text.length != 10) {
      mobileNumberValidationMessage =
          'Mobile Number Should Contain 10 Characters';
      mobileNumberValidation = false;
    } else if (mobileNumberController.text == '') {
      mobileNumberValidationMessage = 'Mobile Number cannot be empty';
      mobileNumberValidation = false;
    } else {
      mobileNumberValidation = true;
    }

    if (userNameController.text == '') {
      userNameValidationMessage = 'User name cannot be empty';
      userNameValidation = false;
    } else {
      userNameValidation = true;
    }

    if (joiningDateController.text == '') {
      shippingDateValidationMessage = 'Select Joining date';
      shippingDateValidation = false;
    } else {
      shippingDateValidation = true;
    }
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailController.text);
    if (emailValid != true) {
      emailValidationMessage = 'Provide A Valid Email Address';
      emailValidation = false;
    } else if (emailController.text == '') {
      emailValidationMessage = 'Email id cannot be empty';
      emailValidation = false;
    } else {
      emailValidation = true;
    }
    bool passwordValid =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{9,}$')
            .hasMatch(passwordController.text);
    if (passwordValid != true) {
      passwordValidationMessage = 'Password does not satisfy above crieteria';
      passwordValidation = false;
    } else if (passwordController.text == '') {
      passwordValidationMessage = 'Password cannot be empty';
      passwordValidation = false;
    } else {
      passwordValidation = true;
    }
    if (passwordController.text != ConfirmPasswordController.text) {
      ConfirmPasswordValidationMessage =
          'Password and Confirm Password are Not Equal';
      ConfirmPasswordValidation = false;
    } else if (ConfirmPasswordController.text == '') {
      ConfirmPasswordValidationMessage = 'Confirm Password cannot be empty';
      ConfirmPasswordValidation = false;
    } else {
      ConfirmPasswordValidation = true;
    }

    if (firstNameValidation == true &&
        lastNameValidation == true &&
        roleIdValidation == true &&
        userNameValidation == true &&
        shippingDateValidation == true &&
        emailValidation == true &&
        ConfirmPasswordValidation == true &&
        passwordValidation == true) {
      return true;
    } else {
      return false;
    }
  }

  void _datePicker(TextEditingController controller, int value) {
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
      controller.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      if (value == 1) {
        user['Received_Date'] =
            DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(pickedDate);
      } else {
        user['Joining_Date'] =
            DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(pickedDate);
      }

      setState(() {});
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

  @override
  void initState() {
    super.initState();
    clearTransferException(context);
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
      joiningDateController.text = DateFormat('dd-MM-yyyy')
          .format(DateTime.parse(widget.editData['Joining_Date']));
      user['Joining_Date'] = widget.editData['Joining_Date'];
      lastNameController.text = widget.editData['Last_Name'].toString();
      user['Last_Name'] = widget.editData['Last_Name'];
      roleId = widget.editData['Role_Id__Role_Name'];
      user['Role_Id'] = widget.editData['Role_Id'];
      emailController.text = widget.editData['email'];
      user['email'] = widget.editData['email'];
      mobileNumberController.text = widget.editData['Mobile_Number'];
      user['Mobile_Number'] = widget.editData['Mobile_Number'];
      // cwQuantityController.text = widget.editData['CW_Quantity'].toString();
      // transferOut['CW_Quantity'] = widget.editData['CW_Quantity'];
      // cwUnitController.text = widget.editData['CW_Unit'];
      // transferOut['CW_Unit'] = widget.editData['CW_Unit'];
      userNameController.text = widget.editData['username'].toString();
      user['username'] = widget.editData['username'];
      // itemController.text = widget.editData['Item'];
      // transferOut['Item'] = widget.editData['Item'];
      // itemCategoryController.text = widget.editData['Customer_Name'];
      // transferOut['Customer_Name'] = widget.editData['Customer_Name'];
      firstNameController.text = widget.editData['First_Name'];
      user['First_Name'] = widget.editData['First_Name'];
      // statusController.text = widget.editData['Rate'].toString();
      // transferOut['Rate'] = widget.editData['Rate'];
    }

    Provider.of<Apicalls>(context, listen: false)
        .tryAutoLogin()
        .then((value) async {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<AdminApis>(context, listen: false).getUserRoles(token);
    });
  }

  void save() {
    bool isValid = validate();
    if (!isValid) {
      debugPrint(isValid.toString());
      setState(() {});
      // return;
    } else {
      _formKey.currentState!.save();
      // user['had_Access'] = true;

      if (widget.editData.isNotEmpty) {
        Provider.of<Apicalls>(context, listen: false)
            .tryAutoLogin()
            .then((value) {
          var token = Provider.of<Apicalls>(context, listen: false).token;
          Provider.of<AdminApis>(context, listen: false)
              .updateUser(
            user,
            token,
            widget.editData['id'],
          )
              .then((value) {
            if (value['Status_Code'] == 202 || value['Status_Code'] == 201) {
              widget.reFresh(100);
              Get.back();
              successSnackbar('Successfully updated user data');
            } else {
              failureSnackbar('Unable to update data something went wrong');
            }
          });
        });
      } else {
        Provider.of<Apicalls>(context, listen: false)
            .tryAutoLogin()
            .then((value) {
          var token = Provider.of<Apicalls>(context, listen: false).token;
          Provider.of<AdminApis>(context, listen: false)
              .addUser(user, token)
              .then((value) {
            if (value == 200 || value == 201) {
              widget.reFresh(100);
              Get.back();
              successSnackbar('Successfully added User');
            } else {
              failureSnackbar('Unable to add User something went wrong');
            }
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double formWidth = size.width * 0.25;

    roleDetails = Provider.of<AdminApis>(
      context,
    ).userRoles;

    // batchPlanDetails = Provider.of<InventoryApi>(context).batchDetails;
    // itemCategoryDetails = Provider.of<ItemApis>(context).itemcategory;
    // itemSubCategoryDetails = Provider.of<ItemApis>(context).itemSubCategory;
    // productlist = Provider.of<ItemApis>(context).productList;
    return Container(
      width: size.width * 0.3,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'User',
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
                      children: [
                        widget.editData.isEmpty
                            ? const Text(
                                'Add User',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 18),
                              )
                            : const Text(
                                'Update User',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 18),
                              ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('First Name'),
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
                                  hintText: 'Enter first name',
                                  border: InputBorder.none),
                              controller: firstNameController,
                              onSaved: (value) {
                                user['First_Name'] = value!;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  firstNameValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, firstNameValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('Last Name'),
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
                                  hintText: 'Enter last name',
                                  border: InputBorder.none),
                              controller: lastNameController,
                              onSaved: (value) {
                                user['Last_Name'] = value!;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  lastNameValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, lastNameValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('Email Id'),
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
                                  hintText: 'Enter email id',
                                  border: InputBorder.none),
                              controller: emailController,
                              onSaved: (value) {
                                user['email'] = value!;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  emailValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, emailValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('Mobile Number'),
                        ),
                        Container(
                          width: formWidth,
                          height: 54,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            border: Border.all(color: Colors.black26),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: TextFormField(
                              maxLength: 10,
                              enableSuggestions: false,
                              decoration: const InputDecoration(
                                  hintText: 'Enter mobile number',
                                  border: InputBorder.none),
                              controller: mobileNumberController,
                              onSaved: (value) {
                                user['Mobile_Number'] = value!;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  mobileNumberValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, mobileNumberValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('User Name'),
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
                                  hintText: 'Enter user name',
                                  border: InputBorder.none),
                              controller: userNameController,
                              onSaved: (value) {
                                user['username'] = value!;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  userNameValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, userNameValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('Password'),
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
                                  hintText: 'Enter password',
                                  border: InputBorder.none),
                              controller: passwordController,
                              onSaved: (value) {
                                user['password'] = value!;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: formWidth,
                          child: const Text(
                              'Min. 9 characters. \nOne upper case letter. \nOne special character. \nOne number. '),
                        )
                      ],
                    ),
                  ),
                  passwordValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, passwordValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('Confirm Password'),
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
                                  hintText: 'Enter Confirm password',
                                  border: InputBorder.none),
                              controller: ConfirmPasswordController,
                              onSaved: (value) {
                                user['password2'] = value!;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ConfirmPasswordValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, ConfirmPasswordValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('Role'),
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
                                value: roleId,
                                items: roleDetails
                                    .map<DropdownMenuItem<String>>((e) {
                                  return DropdownMenuItem(
                                    value: e['Role_Name'],
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      user['Role_Id'] = e['Role_Id'];
                                      //print(warehouseCategory);
                                    },
                                    child: Text(e['Role_Name']),
                                  );
                                }).toList(),
                                hint: const Text('Select'),
                                onChanged: (value) {
                                  setState(() {
                                    roleId = value as String;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  roleIdValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, roleIdValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: formWidth,
                              padding: const EdgeInsets.only(bottom: 12),
                              child: const Text('Joining Date'),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: size.width * 0.23,
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
                                  controller: joiningDateController,
                                  decoration: const InputDecoration(
                                      hintText: 'DD/MM/YYYY',
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
                                onPressed: () =>
                                    _datePicker(joiningDateController, 2),
                                icon: Icon(
                                  Icons.date_range_outlined,
                                  color: ProjectColors.themecolor,
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                  shippingDateValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, shippingDateValidationMessage),
                  Consumer<TransferJournalApi>(
                      builder: (context, value, child) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: value.transferException.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ModularWidgets.exceptionDesign(
                            MediaQuery.of(context).size,
                            value.transferException[index]);
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
    );
  }
}
