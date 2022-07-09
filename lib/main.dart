import 'dart:convert';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/admin/providers/admin_apis.dart';
import 'package:poultry_login_signup/admin/screens/roles_details_page.dart';
import 'package:poultry_login_signup/batch_plan/providers/batch_plan_apis.dart';
import 'package:poultry_login_signup/breed_info/providers/breed_info_apicalls.dart';
import 'package:poultry_login_signup/colors.dart';
import 'package:poultry_login_signup/customer_sales_record/providers/cust_sales_api.dart';
import 'package:poultry_login_signup/egg_collection/providers/egg_collection_apis.dart';
import 'package:poultry_login_signup/grading/providers/grading_apis.dart';
import 'package:poultry_login_signup/infrastructure/providers/infrastructure_apicalls.dart';
import 'package:poultry_login_signup/inventory/providers/inventory_api.dart';
import 'package:poultry_login_signup/inventory/screens/inventory_screen.dart';
import 'package:poultry_login_signup/inventory_adjustment/providers/inventory_adjustement_apis.dart';
import 'package:poultry_login_signup/items/providers/items_apis.dart';
import 'package:poultry_login_signup/items/screens/product_management_secondary.dart';
import 'package:poultry_login_signup/items/screens/product_management_secondary_bar.dart';
import 'package:poultry_login_signup/items/screens/productmanagement_primary_bar.dart';
import 'package:poultry_login_signup/logs/providers/logs_api.dart';
import 'package:poultry_login_signup/logs/screens/activity_logs_screen.dart';
import 'package:poultry_login_signup/logs/screens/medication_logs_screen.dart';
import 'package:poultry_login_signup/logs/screens/vaccination_logs_screen.dart';
import 'package:poultry_login_signup/planning/screens/activity_plan_details_page.dart';
import 'package:poultry_login_signup/planning/screens/batch_plan_details_page.dart';
import 'package:poultry_login_signup/planning/screens/medication_plan_details_page.dart';
import 'package:poultry_login_signup/planning/screens/vaccination_plan_details_page.dart';
import 'package:poultry_login_signup/planning/widgets/add_activity_plan.dart';
import 'package:poultry_login_signup/planning/widgets/add_medication_plan.dart';
import 'package:poultry_login_signup/planning/widgets/add_vaccination_plan.dart';
import 'package:poultry_login_signup/providers/exception_handle.dart';
import 'package:poultry_login_signup/sales_journal/screens/company_details_page.dart';
import 'package:poultry_login_signup/sales_journal/screens/customers_details_page.dart';
import 'package:poultry_login_signup/sales_journal/screens/sales_details_page.dart';
import 'package:poultry_login_signup/screens/dashboard_default_screen.dart';
import 'package:poultry_login_signup/screens/dashboard_screen.dart';
import 'package:poultry_login_signup/screens/firm_and_plant_selection_page.dart';
import 'package:poultry_login_signup/screens/main_dash_board.dart';
import 'package:poultry_login_signup/screens/notifications_page.dart';
import 'package:poultry_login_signup/screens/operations_screen.dart';
import 'package:poultry_login_signup/screens/password_reset.dart';
import 'package:poultry_login_signup/screens/production_dashboard.dart';
import 'package:poultry_login_signup/screens/sales_screen.dart';
import 'package:poultry_login_signup/screens/secondary_dashboard_screen.dart';
import 'package:poultry_login_signup/screens/sign_up.dart';
import 'package:poultry_login_signup/splash_screen.dart';
import 'package:poultry_login_signup/transfer_journal/providers/transfer_journal_apis.dart';
import 'package:poultry_login_signup/transfer_journal/screens/transfers_screen.dart';
// import 'dart:html' as html;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart';
import 'admin/screens/admin.dart';
import 'admin/screens/module.dart';
import 'admin/screens/permision.dart';
import 'admin/screens/user.dart';
import 'admin/screens/user_credentials.dart';
import 'admin/screens/user_roles.dart';
import 'admin/widgets/add_module.dart';
import 'admin/widgets/add_permission.dart';
import 'admin/widgets/add_user_credentials.dart';
import 'batch_plan/screens/batchplandetails.dart';
import 'batch_plan/screens/batchplanmapping.dart';
import 'batch_plan/widgets/addbatchplanmapping.dart';
import 'breed_info/screens/bird_age_group.dart';
import 'breed_info/screens/bird_reference_data.dart';
import 'breed_info/screens/breed_info.dart';
import 'breed_info/screens/breed_version.dart';
import 'breed_info/widgets/add_bird_age_group_dialog.dart';
import 'customer_sales_record/screens/customer_info.dart';
import 'customer_sales_record/screens/sales_record.dart';
import 'customer_sales_record/widgets/add_customer_info.dart';
import 'customer_sales_record/widgets/add_sales_record.dart';
import 'egg_collection/screens/egg_collection_data.dart';
import 'egg_collection/screens/grading.dart';
import 'egg_collection/screens/mortality.dart';
import 'egg_collection/widgets/add_egg_collection_data.dart';
import 'egg_collection/widgets/add_grading.dart';
import 'grading/screens/egg_grading.dart';
import 'infrastructure/screens/firm_details_page.dart';
import 'infrastructure/screens/firm_details_screen.dart';
import 'infrastructure/screens/firms_page.dart';
import 'infrastructure/screens/plant_dashboard_screen.dart';
import 'infrastructure/screens/plant_details_screen.dart';
import 'infrastructure/screens/user_detail_page.dart';
import 'infrastructure/screens/warehouse_category_screen.dart';
import 'infrastructure/screens/warehouse_details_screen.dart';
import 'infrastructure/screens/warehouse_section_line.dart';
import 'infrastructure/screens/warehouse_section_screen.dart';
import 'infrastructure/screens/warehouse_sub_category_screen.dart';
import 'infrastructure/widgets/add_firm_details.dart';
import 'infrastructure/widgets/add_warehouse_category.dart';
import 'infrastructure/widgets/add_warehouse_details.dart';
import 'infrastructure/widgets/add_warehouse_section.dart';
import 'infrastructure/widgets/add_warehouse_section_line.dart';
import 'infrastructure/widgets/add_warehouse_subcategory.dart';
import 'inventory/screens/inventory_batch_details_page.dart';
import 'inventory/screens/inventory_batch_screen.dart';
import 'inventory_adjustment/screens/bird_grading_page.dart';
import 'inventory_adjustment/widgets/add_mortality.dart';
import 'items/screens/inventory.dart';
import 'items/screens/inventory_adjustment.dart';
import 'items/screens/product_details.dart';
import 'items/screens/product_management.dart';
import 'items/screens/product_sub_type.dart';
import 'items/screens/product_type.dart';
import 'items/widgets/add_inventory.dart';
import 'items/widgets/add_inventory_adjustment.dart';
import 'items/widgets/add_item_category.dart';
import 'items/widgets/add_item_details.dart';
import 'items/widgets/add_item_sub_category.dart';
import 'planning/providers/activity_plan_apis.dart';
import 'providers/apicalls.dart';
import 'providers/dashboard_apicalls.dart';
import 'sales_journal/providers/journal_api.dart';
import 'sales_journal/screens/company_sales_details_page.dart';
import 'widgets/modular_widgets.dart';
// import 'widgets/batch_plan/addbatchplandetails.dart';

void relogin() {
  Get.defaultDialog();
}

String getRandom(int length, String name) {
  const ch = '1234567890abcdefghijklmnopqrstuvwxyz';
  Random r = Random();
  return name +
      String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => ch.codeUnitAt(
            r.nextInt(ch.length),
          ),
        ),
      );
}

void successSnackbar(String message) {
  Get.showSnackbar(GetSnackBar(
    title: 'Success',
    message: message,
    duration: const Duration(seconds: 5),
  ));
}

void failureSnackbar(String message) {
  Get.showSnackbar(GetSnackBar(
    title: 'Failed',
    message: message,
    duration: const Duration(seconds: 5),
  ));
}

void alertSnackBar(String message) {
  Get.showSnackbar(GetSnackBar(
    title: 'Alert',
    message: message,
    duration: const Duration(seconds: 5),
  ));
}

void moveToDashboard() {
  Get.offAllNamed(DashBoardDefaultScreen.routeName);
  Get.offAllNamed(
    SecondaryDashBoardScreen.routeName,
    predicate: (route) =>
        route ==
        MaterialPageRoute(
          builder: (BuildContext context) => MainDashBoardScreen(),
        ),
  );
}

Text emptyLists(String data) {
  return Text(
    data,
    style: GoogleFonts.roboto(
      fontWeight: FontWeight.w500,
      fontSize: 18,
    ),
  );
}

Future<String> fetchPlant() async {
  var prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('FirmAndPlantDetails')) {
    var extratedData = json.decode(prefs.getString('FirmAndPlantDetails')!)
        as Map<String, dynamic>;
    debugPrint(extratedData.toString());
    return extratedData['PlantId'].toString();
  } else {
    return '';
  }
}

Center viewPermissionDenied() {
  return const Center(
    child: Text('You don\'t have permission to view this page'),
  );
}

Future<Map<String, dynamic>> getPermission(String key) async {
  final prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey(key)) {
    var extratedinventoryAdjustmentPermissions = {
      'Role_Name': 'Worker',
      'Id': 'Inventory Adjustment Journal',
      'Edit': false,
      'View': false,
      'Create': false,
      'Delete': false
    };
    return extratedinventoryAdjustmentPermissions;
  }
  final extratedUserData =
      //we should use dynamic as a another value not a Object
      json.decode(prefs.getString(key)!) as Map<String, dynamic>;

  var extratedinventoryAdjustmentPermissions = extratedUserData[key];
  // print(extratedinventoryAdjustmentPermissions);

  return extratedinventoryAdjustmentPermissions;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyD3pgykkcZN9LmnUOjw-mU1Wz54soZEogg",
      authDomain: "poultry-farm-572bd.firebaseapp.com",
      projectId: "poultry-farm-572bd",
      storageBucket: "poultry-farm-572bd.appspot.com",
      messagingSenderId: "34824825747",
      appId: "1:34824825747:web:bf1ee87d4ed475ca5e5666",
    ),
  );
  runApp(
    const MyApp(),
    // ModularApp(module: AppModule(), child: MyApp())
  );

  // print('Messaging');
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  // print('User granted permission: ${settings.authorizationStatus}');

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // print('Handling a background message ${message.notification!.title}');
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // print('inside');
    FirebaseMessaging.instance
        .getToken(
            vapidKey:
                'BLWUwuMEv70r8ptiPqaJWYBBL3AizobTwdVSiHHmDybKCdpSxLmFsotosfs5YqDnDLiBWMp_Aqm5n8KjpQF7SU0')
        .then((value) async {
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': value,
        },
      );
      prefs.setString('FCM', userData);
      // print('Token: ${value.toString()}');
    });

    firebaseOnMessage();

    super.initState();
  }

  void onFirebaseOpenedApp() {}

  void paint(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
  }

  void firebaseOnMessage() {
    FirebaseMessaging.onMessage.listen((event) {
      if (event != null) {
        final title = event.notification!.title;
        final body = event.notification!.body;
        // print('Received New Notification');

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Align(
        //       alignment: Alignment.topRight,
        //       child: Container(
        //         width: 200,
        //         height: 100,
        //         decoration: BoxDecoration(
        //           border: Border.all(),
        //         ),
        //       ),
        //     ),
        //   ),
        // );
        var data = MediaQueryData.fromWindow(WidgetsBinding.instance!.window);

        // Size size = WidgetsBinding.instance!.window.physicalSize;
        double width = data.size.width;
        // double height = size.height;

        Get.showSnackbar(GetSnackBar(
          backgroundColor: Colors.white,
          margin: EdgeInsets.only(left: width * 0.85, top: 50),
          leftBarIndicatorColor: Colors.grey,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          maxWidth: 337,
          titleText: Text(
            title!,
            style: GoogleFonts.roboto(
                textStyle: const TextStyle(color: Colors.black)),
          ),

          messageText: Text(
            body!,
            style: GoogleFonts.roboto(
                textStyle: const TextStyle(color: Colors.black)),
          ),

          // snackStyle: SnackStyle.GROUNDED,
          mainButton: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.close)),
        ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      if (event != null) {
        final title = event.notification!.title;
        final body = event.notification!.body;

        Size size = WidgetsBinding.instance!.window.physicalSize;
        double width = size.width;
        double height = size.height;

        Get.showSnackbar(GetSnackBar(
          backgroundColor: Colors.white,
          margin: EdgeInsets.only(left: width * 0.9, top: 50),
          leftBarIndicatorColor: Colors.grey,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 5),
          maxWidth: 200,
          titleText: Text(
            title!,
            style: GoogleFonts.roboto(
                textStyle: const TextStyle(color: Colors.black)),
          ),

          messageText: Text(
            body!,
            style: GoogleFonts.roboto(
                textStyle: const TextStyle(color: Colors.black)),
          ),

          // snackStyle: SnackStyle.GROUNDED,
          mainButton: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.close)),
        ));
      }
    });
  }

  void update(int data) {}

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Apicalls(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => InfrastructureApis(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => DashBoardApicalls(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => BreedInfoApis(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ActivityApis(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => BatchApis(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ItemApis(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => EggCollectionApis(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CustomerSalesApis(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => JournalApi(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => GradingApis(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AdminApis(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => InventoryAdjustemntApis(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => TransferJournalApi(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => BatchApis(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => InventoryApi(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => LogsApi(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ExceptionHandle(),
        ),
      ],
      child: Consumer<Apicalls>(
        builder: (ctx, auth, _) => GetMaterialApp(
          initialRoute: '/',
          getPages: [
            GetPage(
              name: '/',
              page: () => MyApp(),
            ),
            GetPage(
              name: MyHomePage.routeName,
              page: () => MyHomePage(),
            ),
            GetPage(
              name: SignUp.routeName,
              page: () => SignUp(),
            ),

            GetPage(
              name: Admin.routeName,
              page: () => Admin(),
            ),
            GetPage(
              name: ModuleData.routeName,
              page: () => ModuleData(),
            ),
            GetPage(
              name: Permission.routeName,
              page: () => Permission(),
            ),
            GetPage(
              name: UserCredentials.routeName,
              page: () => UserCredentials(),
            ),
            GetPage(
              name: User.routeName,
              page: () => User(),
            ),
            GetPage(
              name: BatchPlanDetails.routeName,
              page: () => BatchPlanDetails(),
            ),
            GetPage(
              name: BirdAgeGroup.routeName,
              page: () => BirdAgeGroup(),
            ),
            GetPage(
              name: BirdReferenceData.routeName,
              page: () => BirdReferenceData(),
            ),

            GetPage(
              name: BreedVersion.routeName,
              page: () => BreedVersion(),
            ),
            GetPage(
              name: CustomerInfo.routeName,
              page: () => CustomerInfo(),
            ),
            GetPage(
              name: SalesRecord.routeName,
              page: () => SalesRecord(),
            ),
            GetPage(
              name: EggCollectionData.routeName,
              page: () => EggCollectionData(),
            ),
            GetPage(
              name: Grading.routeName,
              page: () => Grading(),
            ),
            GetPage(
              name: Mortality.routeName,
              page: () => Mortality(),
            ),
            GetPage(
              name: BirdGrading.routeName,
              page: () => BirdGrading(),
            ),
            GetPage(
              name: EggGrading.routeName,
              page: () => EggGrading(),
            ),
            GetPage(
              name: FirmDetailScreen.routeName,
              page: () => FirmDetailScreen(),
            ),
            GetPage(
              name: PlantDetailsScreen.routeName,
              page: () => PlantDetailsScreen(),
            ),
            GetPage(
                name: WarehouseCategoryScreen.routeName,
                page: () => WarehouseCategoryScreen(),
                participatesInRootNavigator: true,
                maintainState: true),
            GetPage(
              name: WareHouseDetailsScreen.routeName,
              page: () => WareHouseDetailsScreen(),
            ),
            GetPage(
              name: WarehouseSectionLine.routeName,
              page: () => WarehouseSectionLine(),
            ),
            GetPage(
              name: WareHouseSectionScreen.routeName,
              page: () => WareHouseSectionScreen(),
            ),
            GetPage(
              name: WarehouseSubCategoryScreen.routeName,
              page: () => WarehouseSubCategoryScreen(),
            ),
            GetPage(
              name: InventoryAdjustment.routeName,
              page: () => InventoryAdjustment(),
            ),
            GetPage(
              name: Inventory.routeName,
              page: () => Inventory(),
            ),
            GetPage(
              name: ProductDetailsPage.routeName,
              page: () => ProductDetailsPage(),
            ),
            GetPage(
              name: ProductSubCategory.routeName,
              page: () => ProductSubCategory(),
            ),
            GetPage(
              name: ProductTypePage.routeName,
              page: () => ProductTypePage(),
            ),

            GetPage(
              name: DashBoardDefaultScreen.routeName,
              page: () => DashBoardDefaultScreen(),
            ),
            GetPage(
              name: DashBoardScreen.routeName,
              page: () => DashBoardScreen(),
            ),
            GetPage(
              name: PasswordReset.routeName,
              page: () => PasswordReset(),
            ),
            GetPage(
              name: SignUp.routeName,
              page: () => SignUp(),
            ),

            GetPage(
              name: AddActivityPlan.routeName,
              page: () => AddActivityPlan(),
            ),

            GetPage(
              name: AddMedicationPlan.routeName,
              page: () => AddMedicationPlan(),
            ),

            GetPage(
              name: AddVaccinationPlan.routeName,
              page: () => AddVaccinationPlan(),
            ),
            GetPage(
              name: AddModule.routeName,
              page: () => AddModule(),
            ),
            GetPage(
              name: AddPermission.routeName,
              page: () => AddPermission(),
            ),
            GetPage(
              name: AddUserCredentials.routeName,
              page: () => AddUserCredentials(),
            ),
            // GetPage(
            //   name: AddUser.routeName,
            //   page: () => AddUser(),
            // ),
            // GetPage(
            //   name: AddBatchPlanDetails.routeName,
            //   page: () => AddBatchPlanDetails(),
            // ),
            GetPage(
              name: AddBirdAgeGroup.routeName,
              page: () => AddBirdAgeGroup(
                reFresh: (int value) {},
              ),
            ),

            GetPage(
              name: AddCustomerInfo.routeName,
              page: () => AddCustomerInfo(),
            ),
            GetPage(
              name: AddSalesRecord.routeName,
              page: () => AddSalesRecord(),
            ),
            GetPage(
              name: AddEggCollectionData.routeName,
              page: () => AddEggCollectionData(),
            ),
            GetPage(
              name: AddGrading.routeName,
              page: () => AddGrading(),
            ),
            GetPage(
              name: AddMortality.routeName,
              page: () => AddMortality(editData: {}, reFresh: (value) {}),
            ),
            GetPage(
              name: AddFirmDetails.routeName,
              page: () => AddFirmDetails(),
            ),
            // GetPage(
            //   name: AddPlantDetails.routeName,
            //   page: () => AddPlantDetails(),
            // ),
            GetPage(
              name: AddWarehouseCategory.routeName,
              page: () => AddWarehouseCategory(),
              participatesInRootNavigator: true,
              maintainState: true,
            ),
            GetPage(
                name: AddWareHouseDetails.routeName,
                page: () => AddWareHouseDetails(
                      update: update,
                    )),
            GetPage(
              name: AddWareHouseSectionLine.routeName,
              page: () => AddWareHouseSectionLine(),
            ),
            GetPage(
              name: AddWareHouseSection.routeName,
              page: () => AddWareHouseSection(),
            ),
            GetPage(
              name: AddWareHouseSubCategory.routeName,
              page: () => AddWareHouseSubCategory(),
            ),
            GetPage(
              name: AddInventoryAdjustment.routeName,
              page: () => AddInventoryAdjustment(),
            ),
            GetPage(
              name: AddInventory.routeName,
              page: () => AddInventory(),
            ),
            GetPage(
              name: AddItemCategory.routeName,
              page: () => AddItemCategory(),
            ),
            GetPage(
              name: AddItemDetails.routeName,
              page: () => AddItemDetails(),
            ),
            GetPage(
              name: AddItemSubCategory.routeName,
              page: () => AddItemSubCategory(),
            ),

            GetPage(
              name: BreedInfoData.routeName,
              page: () => BreedInfoData(),
            ),
            GetPage(
              name: BatchPlanMapping.routeName,
              page: () => BatchPlanMapping(),
            ),
            GetPage(
              name: AddBatchPlanMapping.routeName,
              page: () => AddBatchPlanMapping(),
            ),
            GetPage(
              name: NotificationPage.routeName,
              page: () => NotificationPage(),
            ),
            GetPage(
              name: UserRoles.routeName,
              page: () => UserRoles(),
            ),

            GetPage(
              name: InventoryBatchScreen.routeName,
              page: () => InventoryBatchScreen(),
            ),
            GetPage(
              name: InventoryBatchDetailScreen.routeName,
              page: () => InventoryBatchDetailScreen(),
            ),
            GetPage(
              name: FirmDetailsPage.routeName,
              page: () => FirmDetailsPage(),
            ),
            GetPage(
              name: UserDetailPage.routeName,
              page: () => UserDetailPage(),
            ),
            GetPage(
              name: PlantDashBoardScreen.routeName,
              page: () => PlantDashBoardScreen(),
            ),
            GetPage(
              name: FirmPlantSelectionPage.routeName,
              page: () => FirmPlantSelectionPage(),
            ),
            GetPage(
              name: ProductionDashBoardScreen.routeName,
              page: () => ProductionDashBoardScreen(),
            ),
            GetPage(
              name: MainDashBoardScreen.routeName,
              page: () => MainDashBoardScreen(),
            ),
            GetPage(
              name: FirmsPage.routeName,
              page: () => FirmsPage(),
            ),
            GetPage(
              name: ProductManagementPage.routeName,
              page: () => ProductManagementPage(),
            ),
            GetPage(
              name: SecondaryDashBoardScreen.routeName,
              page: () => SecondaryDashBoardScreen(),
            ),
            GetPage(
              name: OperationsScreen.routeName,
              page: () => OperationsScreen(),
            ),
            GetPage(
              name: ActivityPlanDetailsPage.routeName,
              page: () => ActivityPlanDetailsPage(),
            ),
            GetPage(
              name: VaccinationPlanDetails.routeName,
              page: () => VaccinationPlanDetails(),
            ),
            GetPage(
              name: MedicationPlanDetails.routeName,
              page: () => MedicationPlanDetails(),
            ),
            GetPage(
              name: BatchPlanDetailsPage.routeName,
              page: () => BatchPlanDetailsPage(),
            ),
            GetPage(
              name: SalesDetailsPage.routeName,
              page: () => SalesDetailsPage(
                id: 0,
              ),
            ),
            GetPage(
              name: InventoryScreen.routeName,
              page: () => InventoryScreen(),
            ),
            GetPage(
              name: SalesDisplayScreen.routeName,
              page: () => SalesDisplayScreen(),
            ),
            GetPage(
              name: ProductManagementSecondary.routeName,
              page: () => ProductManagementSecondary(),
            ),
            GetPage(
              name: ActivityLogsScreen.routeName,
              page: () => ActivityLogsScreen(),
            ),
            GetPage(
              name: VaccinationLogsScreen.routeName,
              page: () => VaccinationLogsScreen(),
            ),
            GetPage(
              name: MedicationLogsScreen.routeName,
              page: () => MedicationLogsScreen(),
            ),
            GetPage(
              name: RolesDetailsPage.routeName,
              page: () => RolesDetailsPage(),
            ),
            GetPage(
              name: ProductManagementPrimaryBar.routeName,
              page: () => ProductManagementPrimaryBar(),
            ),
            GetPage(
              name: ProductManagementSecondaryBar.routeName,
              page: () => ProductManagementSecondaryBar(),
            ),
            GetPage(
              name: CustomerDetailsPage.routeName,
              page: () => CustomerDetailsPage(),
            ),
            GetPage(
              name: CompanyDetailsPage.routeName,
              page: () => CompanyDetailsPage(),
            ),
            GetPage(
              name: CompanySalesDetailsPage.routeName,
              page: () => CompanySalesDetailsPage(),
            ),
            GetPage(
              name: TransfersJournelScreen.routeName,
              page: () => TransfersJournelScreen(),
            ),
          ],
          debugShowCheckedModeBanner: false,
          title: 'Poultry Farm',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            backgroundColor: const Color.fromRGBO(44, 96, 154, 1),
            fontFamily: GoogleFonts.roboto().fontFamily,
            accentColor: ProjectColors.themecolor,
            textTheme: TextTheme(
              headline6: GoogleFonts.roboto(
                textStyle: const TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontWeight: FontWeight.w700,
                    fontSize: 18),
              ),
              headline5: GoogleFonts.roboto(
                textStyle: const TextStyle(
                    color: Color.fromRGBO(210, 210, 210, 1),
                    fontWeight: FontWeight.w400,
                    fontSize: 16),
              ),
              headline4: GoogleFonts.roboto(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: const Color.fromRGBO(0, 0, 0, 1)),
            ),
          ),
          home: auth.isAuth
              ? MainDashBoardScreen()
              : FutureBuilder(
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : const MyHomePage(),
                  future: auth.tryAutoLogin(),
                ),
          routes: {},
          builder: EasyLoading.init(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  static const routeName = '/LogInPage';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final Map<String, String> _authData = {
    'Mobile_Number': '',
    'Password': '',
  };

  bool _showPassword = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    try {
      Provider.of<Apicalls>(context, listen: false)
          .authenticate(_authData['Mobile_Number']!, _authData['Password']!)
          .then((value) {
        if (value == 201 || value == 200) {
          Provider.of<Apicalls>(context, listen: false)
              .tryAutoLogin()
              .then((value) {
            var token = Provider.of<Apicalls>(context, listen: false).token;
            Provider.of<Apicalls>(context, listen: false)
                .getUserPermissions(token);
          });
          Get.toNamed(MainDashBoardScreen.routeName);
        } else if (value == 400) {
          // var errorMessage =
          //     Provider.of<Apicalls>(context, listen: false).errorMessage;

          // showDialog(
          //   context: context,
          //   builder: (ctx) => AlertDialog(
          //     title: const Text('LogIn Failed'),
          //     content: Text(errorMessage),
          //     actions: [
          //       FlatButton(
          //         onPressed: () {
          //           Navigator.of(ctx).pop();
          //         },
          //         child: const Text('Verify Email'),
          //       ),
          //       FlatButton(
          //         onPressed: () {
          //           Navigator.of(ctx).pop();
          //         },
          //         child: const Text('Cancel'),
          //       )
          //     ],
          //   ),
          // );
        } else {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('LogIn Failed'),
              content: const Text('Please check your Email and Password'),
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
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Image.asset(
                    'assets/images/Welcome_Image.png',
                    alignment: Alignment.center,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  alignment: Alignment.center,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 427,
                          alignment: Alignment.topLeft,
                          child: Text(
                            ' User Login',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                color: Color.fromRGBO(44, 96, 154, 1),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 113,
                        ),
                        SizedBox(
                          width: 427,
                          child: TextFormField(
                            cursorHeight: 20,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person),
                              hintText: 'User Name',
                              hintStyle: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20)),
                            ),
                            onSaved: (value) {
                              _authData['Mobile_Number'] = value!;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 98,
                        ),
                        Container(
                          width: 427,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey))),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 400,
                                child: TextFormField(
                                  cursorHeight: 20,
                                  obscureText:
                                      _showPassword == true ? false : true,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: const Icon(Icons.lock),
                                    hintText: 'Password',
                                    hintStyle: GoogleFonts.roboto(
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 20)),
                                  ),
                                  onSaved: (value) {
                                    _authData['Password'] = value!;
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 25,
                                height: 25,
                                child: _showPassword == true
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _showPassword = false;
                                          });
                                        },
                                        child: SizedBox(
                                          width: 25,
                                          height: 25,
                                          child: Image.asset(
                                            'assets/images/view.png',
                                            // fit: BoxFit.contain,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _showPassword = true;
                                          });
                                        },
                                        child: SizedBox(
                                          width: 25,
                                          height: 25,
                                          child: Image.asset(
                                            'assets/images/hidden.png',
                                            // fit: BoxFit.contain,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 427,
                          child: Consumer<Apicalls>(
                              builder: (context, value, child) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: value.signupException.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ModularWidgets.exceptionDesign(
                                    MediaQuery.of(context).size,
                                    value.signupException[index][0]);
                              },
                            );
                          }),
                        ),
                        const SizedBox(
                          height: 65,
                        ),
                        Container(
                          width: 426,
                          height: 56,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromRGBO(44, 96, 154, 1))),
                            key: const Key('Log In'),
                            onPressed: _submit,
                            child: Text(
                              'LOGIN',
                              style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24)),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          width: 426,
                          child: TextButton(
                            onPressed: () {
                              window.open(
                                  'https://poultryfarmerp.herokuapp.com/accounts/password/reset/',
                                  '_self');
                            },
                            child: Text(
                              'forgot password?',
                              style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  color: Color.fromRGBO(133, 133, 133, 1),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 96,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 426,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  // Navigator.of(context)
                                  //     .pushNamed(SignUp.routeName);
                                  Get.toNamed(SignUp.routeName);

                                  //  window.open(
                                  //   'https://poultryfarmerp.herokuapp.com/accounts/password/reset/',
                                  //   '_self');
                                },
                                child: Text(
                                  'Create an account',
                                  style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      color: Color.fromRGBO(44, 96, 154, 1),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward,
                                size: 16,
                                color: Color.fromRGBO(44, 96, 154, 1),
                              )
                            ],
                          ),
                        ),
                      ],
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
