import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/breed_info/providers/breed_info_apicalls.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BreedInfoData extends StatefulWidget {
  BreedInfoData({Key? key}) : super(key: key);
  static const routeName = '/BreedInfoData';

  @override
  _BreedInfoDataState createState() => _BreedInfoDataState();
}

class _BreedInfoDataState extends State<BreedInfoData> {
  List breedInfo = [];
  @override
  void initState() {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<BreedInfoApis>(context, listen: false)
          .getBreedversionInfo(token)
          .then((value1) {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    breedInfo = Provider.of<BreedInfoApis>(context).breedInfo;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Breed Info'),
        actions: [
          // IconButton(
          //     onPressed: () {
          //       Get.toNamed(AddBreedInfo.routeName);
          //     },
          //     icon: const Icon(Icons.add))
        ],
      ),
      body: Center(
        child: Card(
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: ListView.builder(
              itemCount: breedInfo.length,
              itemBuilder: (BuildContext context, int index) {
                return GetBreedVersion(breedInfo: breedInfo, index: index);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class GetBreedVersion extends StatefulWidget {
  GetBreedVersion({Key? key, required this.breedInfo, required this.index})
      : super(key: key);

  final List breedInfo;
  final int index;

  @override
  _GetBreedVersionState createState() => _GetBreedVersionState();
}

class _GetBreedVersionState extends State<GetBreedVersion> {
  bool isOpened = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: ExpansionPanelList(
        key: widget.key,
        children: [
          ExpansionPanel(
              headerBuilder: (context, isOpened) {
                return ListTile(
                    title: Text(
                      widget.breedInfo[widget.index]['Breed_Name'],
                    ),
                    subtitle: Text(widget.breedInfo[widget.index]['Vendor']),
                    trailing: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.edit)));
              },
              isExpanded: isOpened,
              canTapOnHeader: true,
              body: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: IconButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          final userData = json.encode(
                            {
                              'Name': widget.breedInfo[widget.index]
                                  ['Breed_Name'],
                              'Id': widget.breedInfo[widget.index]['Breed_Id'],
                            },
                          );
                          prefs.setString('BreedName', userData);
                        },
                        icon: const Icon(Icons.add)),
                  )
                ],
              ))
        ],
        expansionCallback: (i, isOpen) => setState(
          () {
            isOpened = !isOpen;
          },
        ),
      ),
    );
  }
}
