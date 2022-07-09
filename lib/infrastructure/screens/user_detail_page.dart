import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/admin/providers/admin_apis.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';

import 'package:provider/provider.dart';

import '../../admin/widgets/add_user_roles.dart';
import '../../search_widget.dart';

class UserDetailPage extends StatefulWidget {
  UserDetailPage({Key? key}) : super(key: key);
  static const routeName = '/UserDetailPage';

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  var query = '';

  void getUserRoles(int data) {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<AdminApis>(context, listen: false).getUserRoles(token);
    });
  }

  TextStyle baseHeadingStyle() {
    return GoogleFonts.roboto(
      fontWeight: FontWeight.w700,
      fontSize: 24,
      color: const Color.fromRGBO(0, 0, 0, 1),
    );
  }

  TextStyle headingStyle() {
    return GoogleFonts.roboto(
      textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
    );
  }

  TextStyle dataStyle() {
    return GoogleFonts.roboto(
      textStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
    );
  }

  Container getHeadingContainer(var data) {
    return Container(
      width: 200,
      height: 25,
      child: Text(
        data,
        style: headingStyle(),
      ),
    );
  }

  Container getDataContainer(var data) {
    return Container(
      width: 200,
      height: 25,
      child: Text(
        data,
        style: dataStyle(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final breadCrumpsStyle = Theme.of(context).textTheme.headline4;
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        backgroundColor: Theme.of(context).backgroundColor,
        actions: [
          Container(
              width: 216,
              height: 36,
              child: SearchWidget(
                  text: query, onChanged: (value) {}, hintText: 'Search')),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          const SizedBox(
            width: 6,
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.person)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 18.0, left: 43),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      //Get.offAllNamed(DashBoardDefaultScreen.routeName);
                    },
                    child: Text('Dashboard', style: breadCrumpsStyle),
                  ),
                  const Icon(
                    Icons.arrow_back_ios_new,
                    size: 15,
                  ),
                  TextButton(
                    onPressed: () {
                      //Get.offAllNamed(DashBoardDefaultScreen.routeName);
                    },
                    child: Text('Infrastructure', style: breadCrumpsStyle),
                  ),
                  const Icon(
                    Icons.arrow_back_ios_new,
                    size: 15,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'User',
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: const Color.fromRGBO(0, 0, 0, 0.5)),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'User Name',
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 36)),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0, left: 30),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('User Details', style: baseHeadingStyle())),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40.0, top: 14),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          getHeadingContainer('User Id'),
                          const SizedBox(
                            width: 49,
                          ),
                          getDataContainer('data'),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          getHeadingContainer('User Name'),
                          const SizedBox(
                            width: 49,
                          ),
                          getDataContainer('data'),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          getHeadingContainer('Phone Number'),
                          const SizedBox(
                            width: 49,
                          ),
                          getDataContainer('data'),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          getHeadingContainer('Email Id'),
                          const SizedBox(
                            width: 49,
                          ),
                          getDataContainer('data'),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0, left: 30),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('Permissions', style: baseHeadingStyle())),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40.0, top: 14),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          getHeadingContainer('Permission 1'),
                          const SizedBox(
                            width: 49,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          getHeadingContainer('Permission 2'),
                          const SizedBox(
                            width: 49,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          getHeadingContainer('Permission 3'),
                          const SizedBox(
                            width: 49,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          getHeadingContainer('Permission 4'),
                          const SizedBox(
                            width: 49,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 30),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('User Roles', style: baseHeadingStyle()),
                        IconButton(
                          onPressed: () {
                            showGlobalDrawer(
                                context: context,
                                builder: (ctx) => AddUserRoles(
                                      reFresh: getUserRoles,
                                    ),
                                direction: AxisDirection.right);
                          },
                          icon: const Icon(Icons.add),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
