library infrastructure;

import 'package:flutter/material.dart';
import 'package:poultry_login_signup/infrastructure/screens/plant_details_screen.dart';
import 'package:poultry_login_signup/infrastructure/screens/warehouse_category_screen.dart';
import 'package:poultry_login_signup/infrastructure/screens/warehouse_details_screen.dart';
import 'package:poultry_login_signup/infrastructure/screens/warehouse_section_line.dart';
import 'package:poultry_login_signup/infrastructure/screens/warehouse_section_screen.dart';
import 'package:poultry_login_signup/infrastructure/screens/warehouse_sub_category_screen.dart';

import 'firm_details_screen.dart';

// part '../../packages/infrastructure/lib/screens/firm_details_screen.dart';
// part '../../packages/infrastructure/lib/screens/plant_details_screen.dart';
// part '../../packages/infrastructure/lib/screens/warehouse_category_screen.dart';
// part '../../packages/infrastructure/lib/screens/warehouse_details_screen.dart';
// part '../../packages/infrastructure/lib/screens/warehouse_section_line.dart';
// part '../../packages/infrastructure/lib/screens/warehouse_section_screen.dart';
// part '../../packages/infrastructure/lib/screens/warehouse_sub_category_screen.dart';
// part '../../packages/infrastructure/lib/widgets/add_firm_details.dart';
// part '../../packages/infrastructure/lib/widgets/add_plant_details.dart';
// part '../../packages/infrastructure/lib/widgets/add_warehouse_category.dart';
// part '../../packages/infrastructure/lib/widgets/add_warehouse_details.dart';
// part '../../packages/infrastructure/lib/widgets/add_warehouse_section.dart';
// part '../../packages/infrastructure/lib/widgets/add_warehouse_section_line.dart';
// part '../../packages/infrastructure/lib/widgets/add_warehouse_subcategory.dart';

class InfraStructureScreen extends StatefulWidget {
  InfraStructureScreen({Key? key}) : super(key: key);

  static const routeName = '/InfraStructureScreen';

  @override
  _InfraStructureScreenState createState() => _InfraStructureScreenState();
}

class _InfraStructureScreenState extends State<InfraStructureScreen> {
  @override
  void initState() {
    super.initState();
    // Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
    //   var token = Provider.of<Apicalls>(context, listen: false).token;
    //   Provider.of<InfrastructureApis>(context, listen: false)
    //       .getPlantDetails(token)
    //       .then((value1) {});
    // });
  }
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Poultry Farm',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const InfraStructureHomePage(title: 'Infrastructure'),
//       routes: {

//       },
//     );
//   }
// }

// class InfraStructureHomePage extends StatefulWidget {
//   const InfraStructureHomePage({Key? key, required this.title})
//       : super(key: key);

//   final String title;

//   @override
//   State<InfraStructureHomePage> createState() => _InfraStructureHomePageState();
// }

// class _InfraStructureHomePageState extends State<InfraStructureHomePage> {
//   @override
//   void initState() {
//     super.initState();
//   }

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
            ExpansionPanelList(
              children: [
                ExpansionPanel(
                    headerBuilder: (context, isOpened) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Infrastructure Management'),
                        ],
                      );
                    },
                    isExpanded: isOpened,
                    canTapOnHeader: true,
                    body: Column(
                      children: [
                        ListTile(
                          title: const Text('Firm Details'),
                          onTap: () {},
                        ),
                        ListTile(
                          title: const Text('Plant Details'),
                          onTap: () {
                            // Modular.to.navigate(PlantDetailsScreen.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text('Ware House Category'),
                          onTap: () {
                            // Modular.to
                            //     .navigate(WarehouseCategoryScreen.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text('Ware House Sub Category'),
                          onTap: () {
                            // Modular.to
                            //     .navigate(WarehouseSubCategoryScreen.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text('Ware House Details'),
                          onTap: () {
                            // Modular.to
                            //     .navigate(WareHouseDetailsScreen.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text('Ware House Section'),
                          onTap: () {
                            // Modular.to
                            //     .navigate(WareHouseSectionScreen.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text('Ware House Section Line'),
                          onTap: () {
                            // Modular.to.navigate(WarehouseSectionLine.routeName);
                          },
                        ),
                      ],
                    ))
              ],
              expansionCallback: (i, isOpen) => setState(
                () {
                  isOpened = !isOpen;
                },
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Infrastructure'),
      ),
    );
  }
}
