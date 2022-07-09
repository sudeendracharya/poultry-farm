import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/items/providers/items_apis.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/failure_dialog.dart';
import '../../widgets/success_dialog.dart';

class AddItemSubCategory extends StatefulWidget {
  AddItemSubCategory({Key? key}) : super(key: key);
  static const routeName = '/AddItemSubCategory';

  @override
  _AddItemSubCategoryState createState() => _AddItemSubCategoryState();
}

class _AddItemSubCategoryState extends State<AddItemSubCategory> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(left: 8.0);
  }

  var choosenValue;
  List itemCategoryData = [];
  var isLoading = true;
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    getItemCategoryName();

    super.initState();
  }

  Map<String, dynamic> ItemSubCategory = {
    'Item_Category_Id': null,
    'Item_Sub_Category_Name': '',
  };

  void getItemCategoryName() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('ItemCategoryName')) {
      return;
    }
    final extratedUserData =
        //we should use dynamic as a another value not a Object
        json.decode(prefs.getString('ItemCategoryName')!)
            as Map<String, dynamic>;
    ItemSubCategory['Item_Category_Id'] = extratedUserData['Id'];
    controller.text = extratedUserData['Name'];

    setState(() {
      isLoading = false;
    });
  }

  void save() {
    var isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    print(ItemSubCategory);

    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<ItemApis>(context, listen: false)
          .addItemSubCategoryData(ItemSubCategory, token, '')
          .then((value) {
        if (value == 200 || value == 201) {
          showDialog(
              context: context,
              builder: (ctx) => SuccessDialog(
                  title: 'Success',
                  subTitle: 'SuccessFully Added Item Sub Category Data'));
        } else {
          showDialog(
              context: context,
              builder: (ctx) => FailureDialog(
                  title: 'Failed',
                  subTitle: 'Something Went Wrong Please Try Again'));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item Sub-category'),
      ),
      body: Form(
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
                    const Text('Choose Category Name'),
                    SizedBox(
                      width: 400,
                      child: TextFormField(
                        controller: controller,
                        enabled: false,
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
                    const Text('Item Sub Category Name'),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          ItemSubCategory['Item_Sub_Category_Name'] = value!;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25.0),
                child: ElevatedButton(
                  onPressed: save,
                  child: const Text('Save'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
