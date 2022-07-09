import 'package:flutter/material.dart';

// part '../../packages/customer_sales_record/lib/screens/customer_info.dart';
// part '../../packages/customer_sales_record/lib/screens/sales_record.dart';
// part '../../packages/customer_sales_record/lib/widgets/add_customer_info.dart';
// part '../../packages/customer_sales_record/lib/widgets/add_sales_record.dart';

class CustomerSalesRecord extends StatefulWidget {
  CustomerSalesRecord({Key? key}) : super(key: key);

  static const routeName = '/CustomerSalesRecord';

  @override
  _CustomerSalesRecordState createState() => _CustomerSalesRecordState();
}

class _CustomerSalesRecordState extends State<CustomerSalesRecord> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: CustomerSalesRecordDefaultPage(),
//       routes: {

//       },
//     );
//   }
// }

// class CustomerSalesRecordDefaultPage extends StatefulWidget {
//   CustomerSalesRecordDefaultPage({Key? key}) : super(key: key);

//   @override
//   _CustomerSalesRecordDefaultPageState createState() =>
//       _CustomerSalesRecordDefaultPageState();
// }

// class _CustomerSalesRecordDefaultPageState
//     extends State<CustomerSalesRecordDefaultPage> {
  List<bool> _isOpen = [false];
  bool isOpened = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('Welcome'),
                ],
              ),
            ),
            const Divider(color: Colors.black),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Record'),
      ),
      body: const Center(
        child: Text('Record Default Page'),
      ),
    );
  }
}
