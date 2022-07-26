import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/main.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/widgets/modular_widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../rps_customer_painter.dart';
import '../styles.dart';

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);

  static const routeName = '/SignUp';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final Map<String, String> _authData = {
    'username': '',
    'email': '',
    'First_Name': '',
    'Last_Name': '',
    'Mobile_Number': '',
    'Roles': 'Admin',
    'password1': '',
    'password2': '',
    'Permissions': '',
  };

  double _dialogWidth = 609;

  double _dialogHeight = 337;

  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool emailValidation = true;
  bool firstNameValidation = true;
  bool lastNameValidation = true;
  bool userNameValidation = true;
  bool mobileNumberValidation = true;
  bool passwordValidation = true;
  bool confirmPasswordValidation = true;

  String emailValidationMessage = '';
  String firstNameValidationMessage = '';
  String lastNameValidationMessage = '';
  String userNameValidationMessage = '';
  String mobileNumberValidationMessage = '';
  String passwordValidationMessage = '';
  String confirmPasswordValidationMessage = '';

  bool validate() {
    if (emailController.text == '') {
      emailValidationMessage = 'Email field cannot be empty';
      emailValidation = false;
    } else {
      emailValidation = true;
    }
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailController.text);

    if (emailValid != true) {
      emailValidationMessage = 'Provide a valid email address';
      emailValidation = false;
    } else {
      emailValidation = true;
    }

    if (firstNameController.text == '') {
      firstNameValidationMessage = 'First name field cannot be empty';
      firstNameValidation = false;
    } else {
      firstNameValidation = true;
    }

    if (lastNameController.text == '') {
      lastNameValidationMessage = 'last name field cannot be empty';
      lastNameValidation = false;
    } else {
      lastNameValidation = true;
    }

    if (userNameController.text == '') {
      userNameValidationMessage = 'User name field cannot be empty';
      userNameValidation = false;
    } else {
      userNameValidation = true;
    }

    if (mobileNumberController.text == '') {
      mobileNumberValidationMessage = 'Mobile Number field cannot be empty';
      mobileNumberValidation = false;
    } else {
      mobileNumberValidation = true;
    }

    if (passwordController.text == '') {
      passwordValidationMessage = 'password field cannot be empty';
      passwordValidation = false;
    } else {
      passwordValidation = true;
    }

    if (confirmPasswordController.text == '') {
      confirmPasswordValidationMessage =
          'Confirm password field cannot be empty';
      confirmPasswordValidation = false;
    } else {
      confirmPasswordValidation = true;
    }

    if (confirmPasswordController.text != passwordController.text) {
      confirmPasswordValidationMessage =
          'Password and Confirm password should be equal';
      confirmPasswordValidation = false;
    } else {
      confirmPasswordValidation = true;
    }

    if (emailValidation == true &&
        firstNameValidation == true &&
        lastNameValidation == true &&
        userNameValidation == true &&
        mobileNumberValidation == true &&
        passwordValidation == true &&
        confirmPasswordValidation == true) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    clearSignupException(context);
    super.initState();
  }

  bool _validate = true;

  Future<void> _submit() async {
    _validate = validate();

    if (_validate != true) {
      setState(() {});
      return;
    }
    _formKey.currentState!.save();
    // print(_authData);
    EasyLoading.show();
    try {
      Provider.of<Apicalls>(context, listen: false)
          .signUp(_authData)
          .then((value) {
        EasyLoading.dismiss();
        if (value == 201 || value == 200) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  insetPadding: const EdgeInsets.all(0),
                  content: Container(
                    width: 520,
                    height: _dialogHeight,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          bottom: _dialogHeight * 0.1,
                          child: CustomPaint(
                            size: Size(
                                _dialogWidth,
                                (_dialogWidth * 0.5833333333333334)
                                    .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                            painter: RPSCustomPainter(),
                          ),
                        ),
                        Positioned(
                          bottom: _dialogHeight * 0.55,
                          child: Container(
                            width: 55,
                            height: 55,
                            child: Image.asset('assets/images/email.png'),
                          ),
                        ),
                        Positioned(
                            child: Text(
                          'Verify your email address',
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color.fromRGBO(68, 68, 68, 1),
                            ),
                          ),
                        )),
                        Positioned(
                            bottom: _dialogHeight * 0.3,
                            child: Container(
                              width: _dialogWidth * 0.7,
                              height: 48,
                              child: Text(
                                'Please click on the link that has been sent your email account to verify your email id ${emailController.text}',
                                style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Color.fromRGBO(68, 68, 68, 1),
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                );
              }).then((value) {
            Get.back();
          });

          // html.window.open('http://localhost:58731/#/', '_self');
        } else {
          if (value != 400) {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('SignUp Failed'),
                content: const Text('Something Went Wrong Please try Again'),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('ok'),
                  )
                ],
              ),
            );
          }
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    print(width);
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            width: width,
            height: height,
            child: Row(
              children: [
                Container(
                  width: width / 2,
                  child: Image.asset(
                    'assets/images/Welcome_Image.png',
                    alignment: Alignment.center,
                  ),
                ),
                Container(
                  width: width / 2,
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(left: width * 0.13),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Row(
                            //   children: [
                            //     Text(
                            //       'SignUp Details',
                            //       style: GoogleFonts.roboto(
                            //           textStyle: TextStyle(
                            //               color: Theme.of(context).backgroundColor,
                            //               fontWeight: FontWeight.w700,
                            //               fontSize: 36)),
                            //     )
                            //   ],
                            // ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 36.0,
                                // left: width * 0.03,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sign Up',
                                    style: GoogleFonts.roboto(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 36,
                                        color: Color.fromRGBO(44, 96, 154, 1),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 440,
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: const Text('First Name'),
                                  ),
                                  Container(
                                    width: 440,
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
                                            hintText: 'Enter First Name',
                                            border: InputBorder.none),
                                        // initialValue: widget.plantCode ?? '',
                                        controller: firstNameController,
                                        onSaved: (value) {
                                          _authData['First_Name'] = value!;
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
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 440,
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: const Text('Last Name'),
                                  ),
                                  Container(
                                    width: 440,
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
                                            hintText: 'Enter Last Name',
                                            border: InputBorder.none),
                                        controller: lastNameController,
                                        onSaved: (value) {
                                          _authData['Last_Name'] = value!;
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
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 440,
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: const Text('User Name'),
                                  ),
                                  Container(
                                    width: 440,
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
                                            hintText: 'Enter User Name',
                                            border: InputBorder.none),
                                        controller: userNameController,
                                        onSaved: (value) {
                                          _authData['username'] = value!;
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
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 440,
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: const Text('Email'),
                                  ),
                                  Container(
                                    width: 440,
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
                                        controller: emailController,
                                        decoration: const InputDecoration(
                                            hintText: 'Enter Email ID',
                                            border: InputBorder.none),
                                        onSaved: (value) {
                                          _authData['email'] = value!;
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
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 440,
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: const Text('Mobile Number'),
                                  ),
                                  Container(
                                    width: 440,
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
                                            hintText: 'Enter Mobile Number',
                                            border: InputBorder.none),
                                        controller: mobileNumberController,
                                        onSaved: (value) {
                                          _authData['Mobile_Number'] = value!;
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
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 440,
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: const Text('Password'),
                                  ),
                                  Container(
                                    width: 440,
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
                                            hintText: 'Enter Password',
                                            border: InputBorder.none),
                                        controller: passwordController,
                                        onSaved: (value) {
                                          _authData['password1'] = value!;
                                        },
                                      ),
                                    ),
                                  ),
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
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 440,
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: const Text('Confirm Password'),
                                  ),
                                  Container(
                                    width: 440,
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
                                            hintText: 'Confirm Password',
                                            border: InputBorder.none),
                                        controller: confirmPasswordController,
                                        onSaved: (value) {
                                          _authData['password2'] = value!;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            confirmPasswordValidation == true
                                ? const SizedBox()
                                : ModularWidgets.validationDesign(
                                    size, confirmPasswordValidationMessage),

                            Consumer<Apicalls>(
                                builder: (context, value, child) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: value.signupException.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ModularWidgets.exceptionDesign(
                                      MediaQuery.of(context).size,
                                      value.signupException[index]);
                                },
                              );
                            }),
                            Padding(
                              padding: const EdgeInsets.only(top: 24.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: width * 0.13,
                                    height: 48,
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            const Color.fromRGBO(
                                                44, 96, 154, 1),
                                          ),
                                        ),
                                        onPressed: _submit,
                                        child: Text(
                                          'Sign Up',
                                          style: GoogleFonts.roboto(
                                            textStyle: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18,
                                              color: Color.fromRGBO(
                                                  255, 254, 254, 1),
                                            ),
                                          ),
                                        )),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      width: width * 0.13,
                                      height: 48,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: const Color.fromRGBO(
                                              44, 96, 154, 1),
                                        ),
                                      ),
                                      child: Text(
                                        'Cancel',
                                        style: ProjectStyles.cancelStyle(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
