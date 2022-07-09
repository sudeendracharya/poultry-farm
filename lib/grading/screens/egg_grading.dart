import 'package:flutter/material.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/grading/providers/grading_apis.dart';
import 'package:provider/provider.dart';

class EggGrading extends StatefulWidget {
  EggGrading({Key? key}) : super(key: key);

  static const routeName = '/EggGrading';

  @override
  _EggGradingState createState() => _EggGradingState();
}

class _EggGradingState extends State<EggGrading> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController controller = TextEditingController();
  String eggGradeName = '';

  List eggGradeList = [];

  var editName = false;
  var id;

  @override
  void initState() {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<GradingApis>(context, listen: false)
          .getEggGrading(token)
          .then((value1) {});
    });

    super.initState();
  }

  void save() {
    // var isValid = _formKey.currentState!.validate();
    // if (!isValid) {
    //   return;
    // }
    _formKey.currentState!.save;
    // Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
    //   var token = Provider.of<Apicalls>(context, listen: false).token;
    //   Provider.of<GradingApis>(context, listen: false)
    //       .postBirdGrading(birdGradeName, token)
    //       .then((value1) {});
    // });
  }

  void edit(Map<String, dynamic> data) {
    setState(() {
      controller.text = data['Name'];
      id = data['Id'];
      editName = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    eggGradeList = Provider.of<GradingApis>(context).eggGradingList;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Egg Grade'),
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Container(
              height: MediaQuery.of(context).size.height / 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Grade Type:'),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 6,
                        child: TextFormField(
                          controller: controller,
                          onSaved: (value) {
                            eggGradeName = value!;
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      editName == true
                          ? SizedBox()
                          : ElevatedButton(
                              onPressed: () {
                                _formKey.currentState!.save();
                                Provider.of<Apicalls>(context, listen: false)
                                    .tryAutoLogin()
                                    .then((value) {
                                  var token = Provider.of<Apicalls>(context,
                                          listen: false)
                                      .token;
                                  Provider.of<GradingApis>(context,
                                          listen: false)
                                      .postEggGrading(eggGradeName, token)
                                      .then((value1) {
                                    if (value1 == 200 || value1 == 201) {
                                      Provider.of<GradingApis>(context,
                                              listen: false)
                                          .getEggGrading(token)
                                          .then((value) {
                                        if (value == 200 || value == 201) {
                                          setState(() {
                                            _formKey.currentState!.reset();
                                            controller.clear();
                                          });
                                        }
                                      });
                                    }
                                  });
                                });
                              },
                              child: const Text('save')),
                      const SizedBox(
                        width: 25,
                      ),
                      editName == true
                          ? ElevatedButton(
                              onPressed: () {
                                _formKey.currentState!.save();
                                Provider.of<Apicalls>(context, listen: false)
                                    .tryAutoLogin()
                                    .then((value) {
                                  var token = Provider.of<Apicalls>(context,
                                          listen: false)
                                      .token;
                                  Provider.of<GradingApis>(context,
                                          listen: false)
                                      .updateEggGrading(eggGradeName, id, token)
                                      .then((value1) {
                                    if (value1 == 200 || value1 == 201) {
                                      Provider.of<GradingApis>(context,
                                              listen: false)
                                          .getEggGrading(token)
                                          .then((value) {
                                        if (value == 200 || value == 201) {
                                          setState(() {
                                            editName = false;
                                            _formKey.currentState!.reset();
                                            controller.clear();
                                          });
                                        }
                                      });
                                    }
                                  });
                                });
                              },
                              child: const Text('Update'))
                          : SizedBox(),
                    ],
                  )
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.black,
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width / 3.5,
              child: ListView.builder(
                itemCount: eggGradeList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                    child: EggGradingList(
                      eggGradeList: eggGradeList,
                      index: index,
                      key: UniqueKey(),
                      name: edit,
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class EggGradingList extends StatefulWidget {
  EggGradingList(
      {Key? key,
      required this.eggGradeList,
      required this.index,
      required this.name})
      : super(key: key);
  final List eggGradeList;
  final int index;
  ValueChanged<Map<String, dynamic>> name;

  @override
  _EggGradingListState createState() => _EggGradingListState();
}

class _EggGradingListState extends State<EggGradingList> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: ListTile(
        title: Text(
          widget.eggGradeList[widget.index]['Egg_Grade_Name'],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () {
                  widget.name({
                    'Name': widget.eggGradeList[widget.index]['Egg_Grade_Name'],
                    'Id': widget.eggGradeList[widget.index]['Egg_Grade_Id']
                  });
                },
                icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  Provider.of<Apicalls>(context, listen: false)
                      .tryAutoLogin()
                      .then((value) {
                    var token =
                        Provider.of<Apicalls>(context, listen: false).token;
                    Provider.of<GradingApis>(context, listen: false)
                        .deleteEggGrading(
                            widget.eggGradeList[widget.index]['Egg_Grade_Id'],
                            token)
                        .then((value1) {});
                  });
                },
                icon: const Icon(Icons.delete))
          ],
        ),
      ),
    );
  }
}
