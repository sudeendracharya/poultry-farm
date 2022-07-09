import 'package:flutter/material.dart';

class AddGrading extends StatefulWidget {
  AddGrading({Key? key}) : super(key: key);
  static const routeName = '/AddGrading';

  @override
  _AddGradingState createState() => _AddGradingState();
}

class _AddGradingState extends State<AddGrading> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(left: 8.0);
  }

  var grading = {
    'Grading_Record_Id': null,
    'Egg_Grading_Date': null,
    'Ware_House_Id': null,
    'Egg_Grading_Location': '',
    'Egg_Grade_From': '',
    'Egg_Grade_To': '',
    'Egg_Grade_Unit': '',
    'Batch_Id': '',
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Grading Details'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 200,
                      child: const Text('Grade Record Id'),
                    ),
                    Container(
                      width: 400,
                      child: TextFormField(
                        validator: (value) {},
                        onSaved: (value) {
                          grading['Grading_Record_Id'] = value!;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Egg Grading Date'),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          grading['Egg_Grading_Date'] = value!;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Ware_House_Id:'),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          grading['Ware_House_Id'] = value!;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Egg Grading Location: '),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          grading['Egg_Grading_Location'] = value!;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Egg Grade From:'),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          grading['Egg_Grade_From'] = value!;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 200,
                      child: const Text('Egg Grade To:'),
                    ),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          grading['Egg_Grade_To'] = value!;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 200,
                      child: const Text('Egg Grade Unit:'),
                    ),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          grading['Egg_Grade_Unit'] = value!;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25.0),
                child:
                    ElevatedButton(onPressed: () {}, child: const Text('Save')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
