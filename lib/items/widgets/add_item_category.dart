import 'package:flutter/material.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/items/providers/items_apis.dart';
import 'package:provider/provider.dart';

import '../../widgets/failure_dialog.dart';
import '../../widgets/success_dialog.dart';

class AddItemCategory extends StatefulWidget {
  AddItemCategory({Key? key}) : super(key: key);
  static const routeName = '/AddItemCategory';

  @override
  _AddItemCategoryState createState() => _AddItemCategoryState();
}

class _AddItemCategoryState extends State<AddItemCategory> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(left: 8.0);
  }

  var ItemCategory = {
    'Item_Category_Name': '',
  };

  void save() {
    var isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<ItemApis>(context, listen: false)
          .addItemCategoryData(ItemCategory, token)
          .then((value) {
        if (value == 200 || value == 201) {
          showDialog(
              context: context,
              builder: (ctx) => SuccessDialog(
                  title: 'Success',
                  subTitle: 'SuccessFully Added Item Category'));
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
        title: const Text('Add Item Category'),
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
                    Container(
                      width: 200,
                      child: const Text('Item Category Name'),
                    ),
                    Container(
                      width: 400,
                      child: TextFormField(
                        validator: (value) {},
                        onSaved: (value) {
                          ItemCategory['Item_Category_Name'] = value!;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25.0),
                child:
                    ElevatedButton(onPressed: save, child: const Text('Save')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
