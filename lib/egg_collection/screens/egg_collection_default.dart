import 'package:flutter/material.dart';

// part '../../packages/egg_collection/lib/screens/egg_collection_data.dart';
// part '../../packages/egg_collection/lib/screens/grading.dart';
// part '../../packages/egg_collection/lib/screens/mortality.dart';
// part '../../packages/egg_collection/lib/widgets/add_egg_collection_data.dart';
// part '../../packages/egg_collection/lib/widgets/add_grading.dart';
// part '../../packages/egg_collection/lib/widgets/add_mortality.dart';

class EggCollection extends StatefulWidget {
  EggCollection({Key? key}) : super(key: key);
  static const routeName = '/EggCollection';

  @override
  _EggCollectionState createState() => _EggCollectionState();
}

class _EggCollectionState extends State<EggCollection> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: EggCollectionDefaultPage(),
//       routes: {

//       },
//     );
//   }
// }

// class EggCollectionDefaultPage extends StatefulWidget {
//   EggCollectionDefaultPage({Key? key}) : super(key: key);

//   @override
//   _EggCollectionDefaultPageState createState() =>
//       _EggCollectionDefaultPageState();
// }

// class _EggCollectionDefaultPageState extends State<EggCollectionDefaultPage> {
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
        title: const Text('Egg Collection'),
      ),
      body: const Center(
        child: Text('Egg Collection Default Page'),
      ),
    );
  }
}
