import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../providers/apicalls.dart';
import '../../widgets/modular_widgets.dart';
import '../providers/journal_api.dart';

class AddVendors extends StatefulWidget {
  AddVendors(
      {Key? key,
      required this.editData,
      required this.update,
      required this.vendorType})
      : super(key: key);
  final Map<String, dynamic> editData;
  final ValueChanged<int> update;
  final String vendorType;
  @override
  State<AddVendors> createState() => _AddVendorsState();
}

class _AddVendorsState extends State<AddVendors> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  var selectedVendorType;

  TextEditingController companyVendorNameController = TextEditingController();
  TextEditingController companyEmailController = TextEditingController();
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
  bool companyVendorNameValidation = true;
  bool companyEmailValidation = true;
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
  String companyVendorNameValidationMessage = '';
  String companyEmailValidationMessage = '';
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
  var vendorId;
  var companyId;

  TextEditingController vendorCodeController = TextEditingController();

  bool vendorCodeValidation = true;

  String vendorCodeValidationMessage = '';

  TextEditingController companyContactPersonEmailController =
      TextEditingController();

  bool companyContactPersonEmailValidation = true;

  String companyContactPersonEmailValidationMessage = '';

  var individualVendorId;

  var companyVendorId;

  @override
  void initState() {
    super.initState();
    selectedVendorType = widget.vendorType;
    if (widget.editData.isNotEmpty && selectedVendorType == 'Individual') {
      vendorId = widget.editData['Vendor'];
      individualVendorId = widget.editData['Individual_Vendor_Id'];
      vendorCodeController.text = widget.editData['Vendor__Vendor_Code'];
      individualNameController.text = widget.editData['Vendor__Vendor_Name'];
      // individualPanNumberController.text =
      //     widget.editData['Customer_Permanent_Account_Number'];
      countryValue = widget.editData['Vendor__Country'];
      stateValue = widget.editData['Vendor__State'];
      cityValue = widget.editData['Vendor__City'];
      individualStreetController.text = widget.editData['Vendor__Street'];
      individualPincodeController.text =
          widget.editData['Vendor__Zip_Code'].toString();
      individualContactNumberController.text =
          widget.editData['Contact_Number'].toString();
      individualEmailIdController.text = widget.editData['Email_Id'];
    } else if (widget.editData.isNotEmpty && selectedVendorType == 'Company') {
      vendorId = widget.editData['Vendor'];
      vendorCodeController.text = widget.editData['Vendor__Vendor_Code'];
      companyVendorId = widget.editData['Company_Vendor_Id'];
      companyVendorNameController.text = widget.editData['Vendor__Vendor_Name'];
      companyEmailController.text = widget.editData['Company_Email_Id'];
      countryValue = widget.editData['Vendor__Country'];
      stateValue = widget.editData['Vendor__State'];
      cityValue = widget.editData['Vendor__City'];
      companyStreetController.text = widget.editData['Vendor__Street'];
      companyPincodeController.text = widget.editData['Vendor__Zip_Code'];
      companyContactPersonNameController.text =
          widget.editData['Contact_Person_Name'];
      companyContactPersonDesignationController.text =
          widget.editData['Designation'];
      companyContactPersonEmailController.text =
          widget.editData['Contact_Email_Id'];
      companyContactNumberController.text = widget.editData['Contact_Number'];
    }
  }

  bool validate() {
    if (selectedVendorType == null) {
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

    if (companyVendorNameController.text.startsWith(RegExp(r'[A-Za-z]')) !=
        true) {
      companyVendorNameValidation = false;
      companyVendorNameValidationMessage =
          'Company name Should start with alphabets';
    } else if (companyVendorNameController.text == '') {
      companyVendorNameValidation = false;
      companyVendorNameValidationMessage = 'Company name cannot be empty';
    } else {
      companyVendorNameValidation = true;
    }

    if (vendorCodeController.text == '') {
      vendorCodeValidation = false;
      vendorCodeValidationMessage = 'Vendor Code cannot be empty';
    } else {
      vendorCodeValidation = true;
    }

    if (companyEmailController.text == '') {
      companyEmailValidation = false;
      companyEmailValidationMessage = 'Email Address cannot be empty';
    } else {
      bool companyEmailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(companyEmailController.text);
      if (!companyEmailValid) {
        companyEmailValidationMessage = 'Enter a valid Email Address';
        companyEmailValidation = false;
      } else {
        companyEmailValidation = true;
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
    bool companyEmailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(companyContactPersonEmailController.text);
    if (companyEmailValid != true) {
      companyContactPersonEmailValidation = false;
      companyContactPersonEmailValidationMessage =
          'Enter a valid email address';
    } else if (companyContactPersonEmailController.text == '') {
      companyContactPersonEmailValidation = false;
      companyContactPersonEmailValidationMessage = 'Email id cannot be empty';
    } else {
      companyContactPersonEmailValidation = true;
    }

    if (selectedVendorType != null) {
      if (selectedVendorType == 'Company') {
        if (countryValidation == true &&
            vendorCodeValidation == true &&
            stateValidation == true &&
            cityValidation == true &&
            companyVendorNameValidation == true &&
            companyEmailValidation == true &&
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
            vendorCodeValidation == true &&
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
    if (selectedVendorType == 'Company') {
      addCustomer = {
        'Vendor_Code': vendorCodeController.text,
        'Vendor_Type': selectedVendorType,
        'Vendor_Name': companyVendorNameController.text,
        'Country': countryValue.toString(),
        'State': stateValue.toString(),
        'City': cityValue.toString(),
        'Street': companyStreetController.text,
        'Zip_Code': companyPincodeController.text,
        'Company_Vendor': {
          'Company_Email_Id': companyEmailController.text,
          'Contact_Person_Name': companyContactPersonNameController.text,
          'Designation': companyContactPersonDesignationController.text,
          'Contact_Number': companyContactNumberController.text,
          'Contact_Email_Id': companyContactPersonEmailController.text,
        }
      };
      print(addCustomer);
      fetchCredientials().then((token) {
        Provider.of<JournalApi>(context, listen: false)
            .addVendorCompanyInfo(addCustomer, token)
            .then((value) {
          if (value == 200 || value == 201) {
            widget.update(100);
            Get.back();
            successSnackbar('Successfully added vendor company data');
          } else {
            failureSnackbar('Unable to add data something went wrong');
          }
        });
      });
    } else {
      addCustomer = {
        'Vendor_Code': vendorCodeController.text,
        'Vendor_Type': selectedVendorType,
        'Vendor_Name': individualNameController.text,
        // 'Vendor_Permanent_Account_Number': individualPanNumberController.text,
        'Country': countryValue.toString(),
        'State': stateValue.toString(),
        'City': cityValue.toString(),
        'Street': individualStreetController.text,
        'Zip_Code': individualPincodeController.text,
        'Individual_Vendor': {
          'Contact_Number': individualContactNumberController.text,
          'Email_Id': individualEmailIdController.text,
        }
      };
      print(addCustomer);

      fetchCredientials().then((token) {
        Provider.of<JournalApi>(context, listen: false)
            .addIndividualVendorsInfo(addCustomer, token)
            .then((value) {
          if (value == 200 || value == 201) {
            widget.update(100);
            Get.back();
            successSnackbar('Successfully added Vendors data');
          } else {
            failureSnackbar('Unable to add data something went wrong');
          }
        });
      });
    }
  }

  void update() {
    Map<String, dynamic> addCustomer = {};
    if (selectedVendorType == 'Company') {
      addCustomer = {
        'Vendor': vendorId,
        'Vendor_Code': vendorCodeController.text,
        'Vendor_Type': selectedVendorType,
        'Vendor_Name': companyVendorNameController.text,
        'Country': countryValue.toString(),
        'State': stateValue.toString(),
        'City': cityValue.toString(),
        'Street': companyStreetController.text,
        'Zip_Code': companyPincodeController.text,
        'Company_Vendor': {
          'Company_Vendor_Id': companyVendorId,
          'Company_Email_Id': companyEmailController.text,
          'Contact_Person_Name': companyContactPersonNameController.text,
          'Designation': companyContactPersonDesignationController.text,
          'Contact_Number': companyContactNumberController.text,
          'Contact_Email_Id': companyContactPersonEmailController.text,
        }
      };
      print('Company Details $addCustomer');
      fetchCredientials().then((token) {
        Provider.of<JournalApi>(context, listen: false)
            .updateVendorCompanyInfo(vendorId, addCustomer, token)
            .then((value) {
          if (value == 200 || value == 202) {
            widget.update(100);
            Get.back();
            successSnackbar('Successfully updated Vendors data');
          } else {
            failureSnackbar('Unable to add data something went wrong');
          }
        });
      });
    } else {
      addCustomer = {
        'vendor': vendorId,
        'Vendor_Code': vendorCodeController.text,
        'Vendor_Type': selectedVendorType,
        'Vendor_Name': individualNameController.text,
        // 'Vendor_Permanent_Account_Number': individualPanNumberController.text,
        'Country': countryValue.toString(),
        'State': stateValue.toString(),
        'City': cityValue.toString(),
        'Street': individualStreetController.text,
        'Zip_Code': individualPincodeController.text,
        'Individual_Vendor': {
          'Individual_Vendor_Id': individualVendorId,
          'Contact_Number': individualContactNumberController.text,
          'Email_Id': individualEmailIdController.text,
        }
      };
      print(addCustomer);

      fetchCredientials().then((token) {
        Provider.of<JournalApi>(context, listen: false)
            .updateVendorInfo(vendorId, addCustomer, token)
            .then((value) {
          if (value == 200 || value == 202) {
            widget.update(100);
            Get.back();
            successSnackbar('Successfully updated Vendors data');
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
                        'Vendors',
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
                                'Add Vendors',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 18),
                              )
                            : const Text(
                                'Update Vendors',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 18),
                              )
                      ],
                    ),
                  ),
                  formDesign(formWidth, 'Vendor Code', vendorCodeController,
                      'Vendor Code'),
                  vendorCodeValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, vendorCodeValidationMessage),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 24.0),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       Container(
                  //         width: formWidth,
                  //         padding: const EdgeInsets.only(bottom: 12),
                  //         child: const Text('Vendor Type'),
                  //       ),
                  //       Container(
                  //         width: formWidth,
                  //         height: 36,
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(8),
                  //           color: Colors.white,
                  //           border: Border.all(color: Colors.black26),
                  //         ),
                  //         child: Padding(
                  //           padding: const EdgeInsets.symmetric(
                  //               horizontal: 12, vertical: 6),
                  //           child: DropdownButtonHideUnderline(
                  //             child: DropdownButton(
                  //               onTap: () {},
                  //               value: selectedVendorType,
                  //               items: ['Individual', 'Company']
                  //                   .map<DropdownMenuItem<String>>((e) {
                  //                 return DropdownMenuItem(
                  //                   enabled: false,
                  //                   value: e,
                  //                   child: Text(e),
                  //                 );
                  //               }).toList(),
                  //               hint: const Text('Select'),
                  //               onChanged: (value) {
                  //                 setState(() {
                  //                   selectedVendorType = value as String;
                  //                 });
                  //               },
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // customerTypevalidation == true
                  //     ? const SizedBox()
                  //     : ModularWidgets.validationDesign(
                  //         size, customerTypevalidationMessage),
                  selectedVendorType == 'Company'
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            formDesign(formWidth, 'Vendor Name',
                                companyVendorNameController, 'Vendor name'),
                            companyVendorNameValidation == true
                                ? const SizedBox()
                                : ModularWidgets.validationDesign(
                                    size, companyVendorNameValidationMessage),
                            formDesign(formWidth, 'Company Email-Id',
                                companyEmailController, 'Email-Id'),
                            companyEmailValidation == true
                                ? const SizedBox()
                                : ModularWidgets.validationDesign(
                                    size, companyEmailValidationMessage),
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
                            formDesign(
                                formWidth,
                                'Email Id',
                                companyContactPersonEmailController,
                                'Email Id'),
                            companyContactPersonEmailValidation == true
                                ? const SizedBox()
                                : ModularWidgets.validationDesign(size,
                                    companyContactPersonEmailValidationMessage),
                          ],
                        )
                      : const SizedBox(),
                  selectedVendorType != 'Individual'
                      ? const SizedBox()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            formDesign(formWidth, 'Vendor Name',
                                individualNameController, 'Vendor name'),
                            individualNameValidation == true
                                ? const SizedBox()
                                : ModularWidgets.validationDesign(
                                    size, individualNameValidationMessage),
                            // formDesign(
                            //     formWidth,
                            //     'Pan Number',
                            //     individualPanNumberController,
                            //     'Pan card number'),
                            // individualPanNumberValidation == true
                            //     ? const SizedBox()
                            //     : ModularWidgets.validationDesign(
                            //         size, individualPanNumberValidationMessage),
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

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Consumer<JournalApi>(
                      builder: (context, value, child) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: value.salesException.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ModularWidgets.exceptionDesign(
                                size, value.salesException[index]);
                          },
                        );
                      },
                    ),
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
