import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/widgets/modular_widgets.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../providers/apicalls.dart';
import '../providers/journal_api.dart';

class AddCustomer extends StatefulWidget {
  AddCustomer(
      {Key? key,
      required this.editData,
      required this.update,
      required this.customerType})
      : super(key: key);

  final Map<String, dynamic> editData;
  final ValueChanged<int> update;
  final String customerType;
  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  var selectedCustomerType;

  TextEditingController companyNameController = TextEditingController();
  TextEditingController panNumberController = TextEditingController();
  TextEditingController companyStreetController = TextEditingController();
  TextEditingController companyPincodeController = TextEditingController();
  TextEditingController companyContactPersonNameController =
      TextEditingController();
  TextEditingController companyContactPersonDesignationController =
      TextEditingController();
  TextEditingController companyContactNumberController =
      TextEditingController();
  TextEditingController individualNameController = TextEditingController();
  TextEditingController individualPanNumberController = TextEditingController();
  TextEditingController individualCityController = TextEditingController();
  TextEditingController individualStreetController = TextEditingController();
  TextEditingController individualPincodeController = TextEditingController();
  TextEditingController individualContactNumberController =
      TextEditingController();
  TextEditingController individualEmailIdController = TextEditingController();

  String? countryValue;

  String? stateValue;

  String? cityValue;

  bool customerTypevalidation = true;
  bool countryValidation = true;
  bool stateValidation = true;
  bool cityValidation = true;
  bool companyNameValidation = true;
  bool companyPanValidation = true;
  bool companyStreetValidation = true;
  bool companyPincodeValidation = true;
  bool companyContactPersonNameValidation = true;
  bool companyContactPersonDesignationValidation = true;
  bool companyContactNumberValidation = true;
  bool individualNameValidation = true;
  bool individualPanNumberValidation = true;

  bool individualStreetValidation = true;
  bool individualPincodeValidation = true;
  bool individualContactNumberValidation = true;
  bool individualEmailIdValidation = true;

  String customerTypevalidationMessage = '';
  String countryValidationMessage = '';
  String stateValidationMessage = '';
  String cityValidationMessage = '';
  String companyNameValidationMessage = '';
  String companyPanValidationMessage = '';
  String companyStreetValidationMessage = '';
  String companyPincodeValidationMessage = '';
  String companyContactPersonNameValidationMessage = '';
  String companyContactPersonDesignationValidationMessage = '';
  String companyContactNumberValidationMessage = '';
  String individualNameValidationMessage = '';
  String individualPanNumberValidationMessage = '';
  String individualCityValidationMessage = '';
  String individualStreetValidationMessage = '';
  String individualPincodeValidationMessage = '';
  String individualContactNumberValidationMessage = '';
  String individualEmailIdValidationMessage = '';
  var customerId;
  var companyId;

  var individualCustomerId;

  var individualCompanyId;

  @override
  void initState() {
    super.initState();
    selectedCustomerType = widget.customerType;
    if (widget.editData.isNotEmpty && selectedCustomerType == 'Individual') {
      customerId = widget.editData['Customer_Id'];
      individualCustomerId = widget.editData['Individual_Customer_Id'];
      individualNameController.text = widget.editData['Customer_Name'];
      individualPanNumberController.text =
          widget.editData['Customer_Permanent_Account_Number'];
      countryValue = widget.editData['Country'];
      stateValue = widget.editData['State'];
      cityValue = widget.editData['City'];
      individualStreetController.text = widget.editData['Street'];
      individualPincodeController.text = widget.editData['Pincode'].toString();
      individualContactNumberController.text =
          widget.editData['Contact_Number'].toString();
      individualEmailIdController.text = widget.editData['Email_Id'];
    } else if (widget.editData.isNotEmpty &&
        selectedCustomerType == 'Company') {
      individualCompanyId = widget.editData['Individual_Company_Id'];
      companyId = widget.editData['Company_Id'];
      companyNameController.text = widget.editData['Company_Name'];
      panNumberController.text =
          widget.editData['Company_Permanent_Account_Number'];
      countryValue = widget.editData['Country'];
      stateValue = widget.editData['State'];
      cityValue = widget.editData['City'];
      companyStreetController.text = widget.editData['Street'];
      companyPincodeController.text = widget.editData['Pincode'];
      companyContactPersonNameController.text =
          widget.editData['Contact_Person_Name'];

      companyContactPersonDesignationController.text =
          widget.editData['Contact_Person_Designation'];

      companyContactNumberController.text = widget.editData['Contact_Number'];
    }
  }

  bool validate() {
    if (selectedCustomerType == null) {
      customerTypevalidation = false;
      customerTypevalidationMessage = 'Select the customer type';
    } else {
      customerTypevalidation = true;
    }

    if (countryValue == null) {
      countryValidation = false;
      countryValidationMessage = 'Select the country';
    } else {
      countryValidation = true;
    }

    if (stateValue == null) {
      stateValidation = false;
      stateValidationMessage = 'Select the state';
    } else {
      stateValidation = true;
    }

    if (cityValue == null) {
      cityValidation = false;
      cityValidationMessage = 'Select the city';
    } else {
      cityValidation = true;
    }

    if (companyNameController.text.startsWith(RegExp(r'[A-Za-z]')) != true) {
      companyNameValidation = false;
      companyNameValidationMessage = 'Company name Should start with alphabets';
    } else if (companyNameController.text == '') {
      companyNameValidation = false;
      companyNameValidationMessage = 'Company name cannot be empty';
    } else {
      companyNameValidation = true;
    }

    if (panNumberController.text == '') {
      companyPanValidation = false;
      companyPanValidationMessage = 'Pan Number cannot be empty';
    } else {
      bool panValid =
          RegExp(r"^[A-Z]+[0-9]+[A-Z]").hasMatch(panNumberController.text);
      if (!panValid) {
        companyPanValidationMessage = 'Enter a valid Pan Card Number';
        companyPanValidation = false;
      } else if (panNumberController.text.length != 10) {
        companyPanValidationMessage = 'Enter a valid Pan Card Number';
        companyPanValidation = false;
      } else {
        companyPanValidation = true;
      }
    }

    if (companyStreetController.text == '') {
      companyStreetValidation = false;
      companyStreetValidationMessage = 'Street cannot be empty';
    } else {
      companyStreetValidation = true;
    }
    if (companyPincodeController.text.isNumericOnly != true) {
      companyPincodeValidation = false;
      companyPincodeValidationMessage = 'Enter a valid pincode';
    } else if (companyPincodeController.text == '') {
      companyPincodeValidation = false;
      companyPincodeValidationMessage = 'Pin-code cannot be empty';
    } else {
      companyPincodeValidation = true;
    }

    if (companyContactPersonNameController.text == '') {
      companyContactPersonNameValidation = false;
      companyContactPersonNameValidationMessage =
          'Contact person name cannot be empty';
    } else {
      companyContactPersonNameValidation = true;
    }
    if (companyContactPersonDesignationController.text == '') {
      companyContactPersonDesignationValidation = false;
      companyContactPersonDesignationValidationMessage =
          'Contact person designation cannot be empty';
    } else {
      companyContactPersonDesignationValidation = true;
    }
    if (companyContactNumberController.text.length != 10) {
      companyContactNumberValidation = false;
      companyContactNumberValidationMessage = 'Enter a valid contact number';
    } else if (companyContactNumberController.text.isNumericOnly != true) {
      companyContactNumberValidation = false;
      companyContactNumberValidationMessage = 'Enter a valid contact number';
    } else if (companyContactNumberController.text == '') {
      companyContactNumberValidation = false;
      companyContactNumberValidationMessage =
          'Contact person Number cannot be empty';
    } else {
      companyContactNumberValidation = true;
    }

    if (individualNameController.text == '') {
      individualNameValidation = false;
      individualNameValidationMessage = 'person name cannot be empty';
    } else {
      individualNameValidation = true;
    }

    if (individualPanNumberController.text == '') {
      individualPanNumberValidation = false;
      individualPanNumberValidationMessage = 'Pan number cannot be empty';
    } else {
      bool panValid = RegExp(r"^[A-Z]+[0-9]+[A-Z]")
          .hasMatch(individualPanNumberController.text);
      if (!panValid) {
        individualPanNumberValidationMessage = 'Enter a valid Pan Card Number';
        individualPanNumberValidation = false;
      } else if (individualPanNumberController.text.length != 10) {
        individualPanNumberValidationMessage = 'Enter a valid Pan Card Number';
        individualPanNumberValidation = false;
      } else {
        individualPanNumberValidation = true;
      }
    }
    if (individualStreetController.text == '') {
      individualStreetValidation = false;
      individualStreetValidationMessage = 'Street address cannot be empty';
    } else {
      individualStreetValidation = true;
    }
    if (individualPincodeController.text.isNumericOnly != true) {
      individualPincodeValidation = false;
      individualPincodeValidationMessage = 'Enter a valid pincode';
    } else if (individualPincodeController.text == '') {
      individualPincodeValidation = false;
      individualPincodeValidationMessage = 'Pincode cannot be empty';
    } else {
      individualPincodeValidation = true;
    }
    if (individualContactNumberController.text.isNumericOnly != true) {
      individualContactNumberValidation = false;
      individualContactNumberValidationMessage = 'Enter a valid contact number';
    } else if (individualContactNumberController.text.length > 10) {
      individualContactNumberValidation = false;
      individualContactNumberValidationMessage = 'Enter a valid contact number';
    } else if (individualContactNumberController.text == '') {
      individualContactNumberValidation = false;
      individualContactNumberValidationMessage =
          'Contact number cannot be empty';
    } else {
      individualContactNumberValidation = true;
    }
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(individualEmailIdController.text);
    if (emailValid != true) {
      individualEmailIdValidation = false;
      individualEmailIdValidationMessage = 'Enter a valid email address';
    } else if (individualEmailIdController.text == '') {
      individualEmailIdValidation = false;
      individualEmailIdValidationMessage = 'Email id cannot be empty';
    } else {
      individualEmailIdValidation = true;
    }

    if (selectedCustomerType != null) {
      if (selectedCustomerType == 'Company') {
        if (countryValidation == true &&
            stateValidation == true &&
            cityValidation == true &&
            companyNameValidation == true &&
            companyPanValidation == true &&
            companyStreetValidation == true &&
            companyPincodeValidation == true &&
            companyContactPersonNameValidation == true &&
            companyContactPersonDesignationValidation == true &&
            companyContactNumberValidation == true) {
          return true;
        } else {
          return false;
        }
      } else {
        if (individualNameValidation == true &&
            individualPanNumberValidation == true &&
            countryValidation == true &&
            stateValidation == true &&
            cityValidation == true &&
            individualStreetValidation == true &&
            individualPincodeValidation == true &&
            individualContactNumberValidation == true &&
            individualContactNumberValidation == true) {
          return true;
        } else {
          return false;
        }
      }
    } else {
      return false;
    }
  }

  Padding formDesign(
    double formWidth,
    String formName,
    TextEditingController controller,
    String hintText,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: formWidth,
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(formName),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: hintText, border: InputBorder.none),
                controller: controller,
                // onSaved: (value) {
                //   salesJournal['Sale_Code'] = value!;
                // },
              ),
            ),
          ),
        ],
      ),
    );
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

  void save() {
    bool validateForm = validate();
    if (validateForm != true) {
      setState(() {});
      return;
    }
    Map<String, dynamic> addCustomer = {};
    if (selectedCustomerType == 'Company') {
      addCustomer = {
        'Customer_Type': selectedCustomerType,
        'Permanent_Account_Number': panNumberController.text,
        'Country': countryValue.toString(),
        'State': stateValue.toString(),
        'City': cityValue.toString(),
        'Street': companyStreetController.text,
        'Pincode': companyPincodeController.text,
        'Contact_Number': companyContactNumberController.text,
        'Company_Customer': {
          'Company_Name': companyNameController.text,
          'Contact_Person_Name': companyContactPersonNameController.text,
          'Contact_Person_Designation':
              companyContactPersonDesignationController.text,
        }
      };
      fetchCredientials().then((token) {
        Provider.of<JournalApi>(context, listen: false)
            .addCompanyInfo(addCustomer, token)
            .then((value) {
          if (value == 200 || value == 201) {
            widget.update(100);
            Get.back();
            successSnackbar('Successfully added company data');
          } else {
            failureSnackbar('Unable to add data something went wrong');
          }
        });
      });
    } else {
      addCustomer = {
        'Customer_Type': selectedCustomerType,
        'Permanent_Account_Number': individualPanNumberController.text,
        'Country': countryValue.toString(),
        'State': stateValue.toString(),
        'City': cityValue.toString(),
        'Street': individualStreetController.text,
        'Pincode': individualPincodeController.text,
        'Contact_Number': individualContactNumberController.text,
        'Individual_Customer': {
          'Individual_Customer_Name': individualNameController.text,
          'Email_Id': individualEmailIdController.text,
        },
      };

      fetchCredientials().then((token) {
        Provider.of<JournalApi>(context, listen: false)
            .addCustomerInfo(addCustomer, token)
            .then((value) {
          if (value == 200 || value == 201) {
            widget.update(100);
            Get.back();
            successSnackbar('Successfully added customer data');
          } else {
            failureSnackbar('Unable to add data something went wrong');
          }
        });
      });
    }
  }

  void update() {
    Map<String, dynamic> addCustomer = {};
    if (selectedCustomerType == 'Company') {
      addCustomer = {
        'Company_Id': companyId,
        'Company_Type': selectedCustomerType,
        'Company_Permanent_Account_Number': panNumberController.text,
        'Country': countryValue.toString(),
        'State': stateValue.toString(),
        'City': cityValue.toString(),
        'Street': companyStreetController.text,
        'Pincode': companyPincodeController.text,
        'Contact_Number': companyContactNumberController.text,
        'Company_Customer': {
          'Company_Id': individualCompanyId,
          'Company_Name': companyNameController.text,
          'Contact_Person_Name': companyContactPersonNameController.text,
          'Contact_Person_Designation':
              companyContactPersonDesignationController.text,
        }
      };
      fetchCredientials().then((token) {
        Provider.of<JournalApi>(context, listen: false)
            .updateCompanyInfo(companyId, addCustomer, token)
            .then((value) {
          if (value == 200 || value == 202) {
            widget.update(100);
            Get.back();
            successSnackbar('Successfully updated company data');
          } else {
            failureSnackbar('Unable to add data something went wrong');
          }
        });
      });
    } else {
      addCustomer = {
        'Customer_Id': customerId,
        'Customer_Type': selectedCustomerType,
        'Customer_Permanent_Account_Number': individualPanNumberController.text,
        'Country': countryValue.toString(),
        'State': stateValue.toString(),
        'City': cityValue.toString(),
        'Street': individualStreetController.text,
        'Pincode': individualPincodeController.text,
        'Contact_Number': individualContactNumberController.text,
        'Individual_Customer': {
          'Individual_Customer_Id': individualCustomerId,
          'Individual_Customer_Name': individualNameController.text,
          'Email_Id': individualEmailIdController.text,
        },
      };

      fetchCredientials().then((token) {
        Provider.of<JournalApi>(context, listen: false)
            .updateCustomerInfo(customerId, addCustomer, token)
            .then((value) {
          if (value == 200 || value == 202) {
            widget.update(100);
            Get.back();
            successSnackbar('Successfully updated customer data');
          } else {
            failureSnackbar('Unable to add data something went wrong');
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double formWidth = size.width * 0.25;

    return Container(
      width: size.width * 0.3,
      height: size.height,
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
                        'Customers',
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
                                'Add Customers',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 18),
                              )
                            : const Text(
                                'Update Customers',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 18),
                              )
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
                          child: const Text('Customer Type'),
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
                                onTap: () {},
                                value: selectedCustomerType,
                                items: ['Individual', 'Company']
                                    .map<DropdownMenuItem<String>>((e) {
                                  return DropdownMenuItem(
                                    enabled: false,
                                    value: e,
                                    child: Text(e),
                                  );
                                }).toList(),
                                hint: const Text('Select'),
                                onChanged: (value) {
                                  setState(() {
                                    selectedCustomerType = value as String;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  customerTypevalidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, customerTypevalidationMessage),
                  selectedCustomerType == 'Company'
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            formDesign(formWidth, 'Company Name',
                                companyNameController, 'Company name'),
                            companyNameValidation == true
                                ? const SizedBox()
                                : ModularWidgets.validationDesign(
                                    size, companyNameValidationMessage),
                            formDesign(formWidth, 'Pan Number',
                                panNumberController, 'Pan number'),
                            companyPanValidation == true
                                ? const SizedBox()
                                : ModularWidgets.validationDesign(
                                    size, companyPanValidationMessage),
                            Padding(
                              padding: const EdgeInsets.only(top: 24.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 100,
                                      child: CSCPicker(
                                        showStates: true,
                                        showCities: true,
                                        countrySearchPlaceholder: "Country",
                                        stateSearchPlaceholder: "State",
                                        citySearchPlaceholder: "City",
                                        flagState: CountryFlag.DISABLE,

                                        ///labels for dropdown
                                        countryDropdownLabel: "*Country",
                                        stateDropdownLabel: "*State",
                                        cityDropdownLabel: "*City",
                                        onCountryChanged: (value) {
                                          setState(() {
                                            ///store value in country variable
                                            countryValue = value;
                                          });
                                        },

                                        ///triggers once state selected in dropdown
                                        onStateChanged: (value) {
                                          setState(() {
                                            ///store value in state variable
                                            stateValue = value;
                                          });
                                        },

                                        ///triggers once city selected in dropdown
                                        onCityChanged: (value) {
                                          setState(() {
                                            ///store value in city variable
                                            cityValue = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            countryValidation == true
                                ? const SizedBox()
                                : ModularWidgets.validationDesign(
                                    size, countryValidationMessage),
                            stateValidation == true
                                ? const SizedBox()
                                : ModularWidgets.validationDesign(
                                    size, stateValidationMessage),
                            cityValidation == true
                                ? const SizedBox()
                                : ModularWidgets.validationDesign(
                                    size, cityValidationMessage),
                            formDesign(formWidth, 'Street',
                                companyStreetController, 'Street address'),
                            companyStreetValidation == true
                                ? const SizedBox()
                                : ModularWidgets.validationDesign(
                                    size, companyStreetValidationMessage),
                            formDesign(formWidth, 'Pin Code',
                                companyPincodeController, 'Pin code'),
                            companyPincodeValidation == true
                                ? const SizedBox()
                                : ModularWidgets.validationDesign(
                                    size, companyPincodeValidationMessage),
                            formDesign(
                                formWidth,
                                'Contact Person Name',
                                companyContactPersonNameController,
                                'Contact person name'),
                            companyContactPersonNameValidation == true
                                ? const SizedBox()
                                : ModularWidgets.validationDesign(size,
                                    companyContactPersonNameValidationMessage),
                            formDesign(
                                formWidth,
                                'Contact Person Designation',
                                companyContactPersonDesignationController,
                                'Contact person designation'),
                            companyContactPersonDesignationValidation == true
                                ? const SizedBox()
                                : ModularWidgets.validationDesign(size,
                                    companyContactPersonDesignationValidationMessage),
                            formDesign(
                                formWidth,
                                'Contact Number',
                                companyContactNumberController,
                                'Contact number'),
                            companyContactNumberValidation == true
                                ? const SizedBox()
                                : ModularWidgets.validationDesign(size,
                                    companyContactNumberValidationMessage),
                          ],
                        )
                      : const SizedBox(),
                  selectedCustomerType != 'Individual'
                      ? const SizedBox()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            formDesign(formWidth, 'Customer Name',
                                individualNameController, 'Customer name'),
                            individualNameValidation == true
                                ? const SizedBox()
                                : ModularWidgets.validationDesign(
                                    size, individualNameValidationMessage),
                            formDesign(
                                formWidth,
                                'Pan Number',
                                individualPanNumberController,
                                'Pan card number'),
                            individualPanNumberValidation == true
                                ? const SizedBox()
                                : ModularWidgets.validationDesign(
                                    size, individualPanNumberValidationMessage),
                            Padding(
                              padding: const EdgeInsets.only(top: 24.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 100,
                                      child: CSCPicker(
                                        showStates: true,
                                        showCities: true,
                                        countrySearchPlaceholder: "Country",
                                        stateSearchPlaceholder: "State",
                                        citySearchPlaceholder: "City",
                                        flagState: CountryFlag.DISABLE,

                                        ///labels for dropdown
                                        countryDropdownLabel: "*Country",
                                        stateDropdownLabel: "*State",
                                        cityDropdownLabel: "*City",
                                        onCountryChanged: (value) {
                                          setState(() {
                                            ///store value in country variable
                                            countryValue = value;
                                          });
                                        },

                                        ///triggers once state selected in dropdown
                                        onStateChanged: (value) {
                                          setState(() {
                                            ///store value in state variable
                                            stateValue = value;
                                          });
                                        },

                                        ///triggers once city selected in dropdown
                                        onCityChanged: (value) {
                                          setState(() {
                                            ///store value in city variable
                                            cityValue = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            countryValidation == true
                                ? const SizedBox()
                                : ModularWidgets.validationDesign(
                                    size, countryValidationMessage),
                            stateValidation == true
                                ? const SizedBox()
                                : ModularWidgets.validationDesign(
                                    size, stateValidationMessage),
                            cityValidation == true
                                ? const SizedBox()
                                : ModularWidgets.validationDesign(
                                    size, cityValidationMessage),
                            formDesign(formWidth, 'Street',
                                individualStreetController, 'Street address'),
                            individualStreetValidation == true
                                ? const SizedBox()
                                : ModularWidgets.validationDesign(
                                    size, individualStreetValidationMessage),
                            formDesign(formWidth, 'Pin Code',
                                individualPincodeController, 'Pin code'),
                            individualPincodeValidation == true
                                ? const SizedBox()
                                : ModularWidgets.validationDesign(
                                    size, individualPincodeValidationMessage),
                            formDesign(
                                formWidth,
                                'Contact Number',
                                individualContactNumberController,
                                'Contact number'),
                            individualContactNumberValidation == true
                                ? const SizedBox()
                                : ModularWidgets.validationDesign(size,
                                    individualContactNumberValidationMessage),
                            formDesign(formWidth, 'Email',
                                individualEmailIdController, 'email id'),
                            individualEmailIdValidation == true
                                ? const SizedBox()
                                : ModularWidgets.validationDesign(
                                    size, individualEmailIdValidationMessage),
                          ],
                        ),
                  widget.editData.isEmpty
                      ? ModularWidgets.globalAddDetailsDialog(size, save)
                      : ModularWidgets.globalUpdateDetailsDialog(size, update),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
