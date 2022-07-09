import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/breed_info/providers/breed_info_apicalls.dart';
import 'package:provider/provider.dart';

class BirdReferenceData extends StatefulWidget {
  BirdReferenceData({Key? key}) : super(key: key);
  static const routeName = '/BirdReferenceData';

  @override
  _BirdReferenceDataState createState() => _BirdReferenceDataState();
}

class _BirdReferenceDataState extends State<BirdReferenceData> {
  List birdReferenceData = [];
  @override
  void initState() {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<BreedInfoApis>(context, listen: false)
          .getBirdReferenceData(token)
          .then((value1) {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    birdReferenceData = Provider.of<BreedInfoApis>(context).birdReferenceDetail;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bird Reference Data'),
        actions: [
          IconButton(
              onPressed: () {
                // Get.toNamed(AddBirdReferenceData.routeName);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          child: ListView.builder(
            itemCount: birdReferenceData.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 5,
                child: ListTile(
                  title: Text(
                    birdReferenceData[index]['Day'].toString(),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      height: 80,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Body Weight:'),
                                  Text(
                                    birdReferenceData[index]['Body_Weight']
                                        .toString(),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Feed_Consumption:'),
                                  Text(
                                    birdReferenceData[index]['Feed_Consumption']
                                        .toString(),
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text('Egg Production Rate:'),
                                  Text(
                                    birdReferenceData[index]
                                            ['Egg_Production_Rate']
                                        .toString(),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text('Mortality:'),
                                  Text(
                                    birdReferenceData[index]['Mortality']
                                        .toString(),
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  //trailing: Text(breedVersion[index]['Vendor']),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
