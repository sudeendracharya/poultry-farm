import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/customer_sales_record/providers/cust_sales_api.dart';
import 'package:provider/provider.dart';

import '../widgets/add_sales_record.dart';

class SalesRecord extends StatefulWidget {
  SalesRecord({Key? key}) : super(key: key);

  static const routeName = '/salesRecord';

  @override
  _SalesRecordState createState() => _SalesRecordState();
}

class _SalesRecordState extends State<SalesRecord> {
  List salesInfo = [];
  @override
  // void initState() {
  //   Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
  //     var token = Provider.of<Apicalls>(context, listen: false).token;
  //     Provider.of<CustomerSalesApis>(context, listen: false)
  //         .getSalesInfo(token)
  //         .then((value1) {});
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    salesInfo =
        Provider.of<CustomerSalesApis>(context, listen: false).salesInfo;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Record Details'),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(AddSalesRecord.routeName);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
    );
  }
}
