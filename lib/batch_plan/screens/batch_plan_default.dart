import 'package:flutter/material.dart';

// part '../../packages/batch_plan/lib/screens/batchplandetails.dart';
// part '../../packages/batch_plan/lib/screens/batchplanmapping.dart';
// part '../../packages/batch_plan/lib/widgets/addbatchplandetails.dart';
// part '../../packages/batch_plan/lib/widgets/addbatchplanmapping.dart';

class BatchPlan extends StatefulWidget {
  BatchPlan({Key? key}) : super(key: key);

  static const routeName = '/BatchPlan';

  @override
  _BatchPlanState createState() => _BatchPlanState();
}

class _BatchPlanState extends State<BatchPlan> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: BatchPlanDefaultPage(),
//       routes: {},
//     );
//   }
// }

// class BatchPlanDefaultPage extends StatefulWidget {
//   BatchPlanDefaultPage({Key? key}) : super(key: key);

//   @override
//   _BatchPlanDefaultPageState createState() => _BatchPlanDefaultPageState();
// }

// class _BatchPlanDefaultPageState extends State<BatchPlanDefaultPage> {
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
        title: const Text('Batch Plan'),
      ),
      body: const Center(
        child: Text('Batch Plan Default Page'),
      ),
    );
  }
}
