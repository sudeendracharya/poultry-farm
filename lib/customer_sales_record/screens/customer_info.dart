import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/customer_sales_record/providers/cust_sales_api.dart';
import 'package:provider/provider.dart';
import '../providers/cust_sales_api.dart';
import '../widgets/add_customer_info.dart';

class CustomerInfo extends StatefulWidget {
  CustomerInfo({Key? key}) : super(key: key);

  static const routeName = '/CustomerInfo';

  @override
  _CustomerInfoState createState() => _CustomerInfoState();
}

class _CustomerInfoState extends State<CustomerInfo> {
  List customerInfo = [];
  @override
  void initState() {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<CustomerSalesApis>(context, listen: false)
          .getCustomerInfo(token)
          .then((value1) {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    customerInfo = Provider.of<CustomerSalesApis>(
      context,
    ).customerInfo;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Info Details'),
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed(AddCustomerInfo.routeName);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Center(
        child: Card(
          child: Container(
            width: MediaQuery.of(context).size.width / 2,
            child: ListView.builder(
              itemCount: customerInfo.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 10,
                  child: ListTile(
                    title: Text(
                      customerInfo[index]['Customer_Name'],
                    ),
                    trailing: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.edit)),
                    subtitle: Text(
                      customerInfo[index]['Customer_Contact_Number'],
                    ),
                    // subtitle: Row(
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     const Text('Notification Prior to activity:'),
                    //     Text(activityPlanData[index]
                    //             ['Notification_Prior_To_Activity']
                    //         .toString())
                    //   ],
                    // ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
