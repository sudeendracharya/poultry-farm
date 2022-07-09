import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/admin/widgets/add_user_roles.dart';
import 'package:poultry_login_signup/admin/widgets/edit_user_roles.dart';
import 'package:poultry_login_signup/screens/main_dash_board.dart';
import 'package:poultry_login_signup/screens/main_drawer_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/apicalls.dart';
import '../../screens/global_app_bar.dart';
import '../../screens/secondary_dashboard_screen.dart';
import '../providers/admin_apis.dart';

class RolesDetailsPage extends StatefulWidget {
  RolesDetailsPage({Key? key}) : super(key: key);

  static const routeName = '/RolesDetailsPage';

  @override
  State<RolesDetailsPage> createState() => _RolesDetailsPageState();
}

class _RolesDetailsPageState extends State<RolesDetailsPage> {
  var _roleId;
  ScrollController controller = ScrollController();

  String query = '';

  Map<String, dynamic> individualUserRoles = {};

  Future<String> fetchCredientials() async {
    bool data =
        await Provider.of<Apicalls>(context, listen: false).tryAutoLogin();
    if (data != false) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      return token;
    } else {
      return '';
    }
  }

  @override
  void initState() {
    getRoleId().then((value) {
      if (_roleId != null) {
        fetchCredientials().then((token) {
          Provider.of<AdminApis>(context, listen: false)
              .getIndividualUserRoles(token, _roleId);
        });
      }
    });
    super.initState();
  }

  Future<void> getRoleId() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('Role_Id')) {
      var extratedData =
          json.decode(prefs.getString('Role_Id')!) as Map<String, dynamic>;
      // print(extratedData);
      _roleId = extratedData['Role_Id'].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final breadCrumpsStyle = Theme.of(context).textTheme.headline4;
    individualUserRoles = Provider.of<AdminApis>(context).individualUserRoles;

    return Scaffold(
      drawer: MainDrawer(controller: controller),
      appBar: GlobalAppBar(query: query, appbar: AppBar()),
      body: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 43, vertical: 18),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.offNamed(MainDashBoardScreen.routeName);
                      },
                      child: Text('Dashboard', style: breadCrumpsStyle),
                    ),
                    const Icon(
                      Icons.arrow_back_ios_new,
                      size: 15,
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text('Users', style: breadCrumpsStyle),
                    ),
                    const Icon(
                      Icons.arrow_back_ios_new,
                      size: 15,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Roles',
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: const Color.fromRGBO(0, 0, 0, 0.5)),
                      ),
                    ),
                    // const Icon(
                    //   Icons.arrow_back_ios_new,
                    //   size: 15,
                    // ),
                    // TextButton(
                    //   onPressed: () {
                    //     Get.offNamed(OperationsScreen.routeName, arguments: 0);
                    //   },
                    //   child: Text(
                    //     'Planning',
                    //     style: breadCrumpsStyle,
                    //   ),
                    // ),
                    // const Icon(
                    //   Icons.arrow_back_ios_new,
                    //   size: 15,
                    // ),
                    // TextButton(
                    //   onPressed: () {},
                    //   child: Text(
                    //     _activityId.toString(),
                    //     style: GoogleFonts.roboto(
                    //         fontWeight: FontWeight.w500,
                    //         fontSize: 18,
                    //         color: const Color.fromRGBO(0, 0, 0, 0.5)),
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                individualUserRoles.isEmpty
                    ? const SizedBox()
                    : EditUserRoles(
                        reFresh: (value) {},
                        userRoles: individualUserRoles,
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
