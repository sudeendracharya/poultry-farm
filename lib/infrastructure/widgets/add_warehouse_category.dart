import 'package:flutter/material.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/infrastructure/providers/infrastructure_apicalls.dart';
import 'package:provider/provider.dart';

import '../../widgets/failure_dialog.dart';
import '../../widgets/success_dialog.dart';

class AddWarehouseCategory extends StatefulWidget {
  AddWarehouseCategory({Key? key}) : super(key: key);
  static const routeName = '/AddWarehouseCategory';

  @override
  _AddWarehouseCategoryState createState() => _AddWarehouseCategoryState();
}

class _AddWarehouseCategoryState extends State<AddWarehouseCategory> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(left: 8.0);
  }

  var update = false;
  var id;

  var wareHouseCategoryName = {
    'WareHouse_Category_Name': '',
  };

  var initValues = {
    'WareHouse_Category_Name': '',
  };

  @override
  void didChangeDependencies() {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      var data =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      update = true;
      id = data['id'];
      initValues = {
        'WareHouse_Category_Name': data['Category'],
      };
    }
    super.didChangeDependencies();
  }

  Future<void> save() async {
    var isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    try {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<InfrastructureApis>(context, listen: false)
            .addWareHouseCategory(wareHouseCategoryName, token)
            .then((value) {
          if (value == 200 || value == 201) {
            showDialog(
                context: context,
                builder: (ctx) => SuccessDialog(
                    title: 'Success',
                    subTitle: 'SuccessFully Added WareHouse Category'));
            _formKey.currentState!.reset();
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SuccessDialog(title: 'Success', subTitle: 'SuccessFully Added WareHouse Category')
            // );

          } else {
            showDialog(
              context: context,
              builder: (ctx) => FailureDialog(
                  title: 'Failed',
                  subTitle: 'Something Went Wrong Please Try Again'),
            );
          }
        });
      });
    } catch (e) {}
  }

  Future<void> updateData() async {
    var isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    try {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<InfrastructureApis>(context, listen: false)
            .editWareHouseCategory(wareHouseCategoryName, id, token)
            .then((value) {
          if (value == 200 || value == 201) {
            showDialog(
                context: context,
                builder: (ctx) => SuccessDialog(
                    title: 'Success',
                    subTitle: 'SuccessFully Added WareHouse Category'));
            _formKey.currentState!.reset();
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SuccessDialog(title: 'Success', subTitle: 'SuccessFully Added WareHouse Category')
            // );

          } else {
            showDialog(
              context: context,
              builder: (ctx) => FailureDialog(
                  title: 'Failed',
                  subTitle: 'Something Went Wrong Please Try Again'),
            );
          }
        });
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add WareHouse Category Name'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Ware house category name'),
                    Padding(
                      padding: getPadding(),
                      child: Container(
                        width: 400,
                        child: TextFormField(
                          initialValue: initValues['WareHouse_Category_Name'],
                          onSaved: (value) {
                            wareHouseCategoryName['WareHouse_Category_Name'] =
                                value!;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              update == false
                  ? Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: ElevatedButton(
                          onPressed: save, child: const Text('Save')),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: ElevatedButton(
                          onPressed: updateData, child: const Text('update')),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
