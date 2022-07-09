import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/infrastructure/providers/infrastructure_apicalls.dart';
import 'package:poultry_login_signup/widgets/failure_dialog.dart';
import 'package:poultry_login_signup/widgets/success_dialog.dart';
import 'package:provider/provider.dart';

import '../widgets/add_warehouse_section_line.dart';

// import '/widgets/add_warehouse_section_line.dart';

class WarehouseSectionLine extends StatefulWidget {
  WarehouseSectionLine({Key? key}) : super(key: key);
  static const routeName = '/WarehouseSectionLine';
  @override
  _WarehouseSectionLineState createState() => _WarehouseSectionLineState();
}

class _WarehouseSectionLineState extends State<WarehouseSectionLine> {
  List wareHouseSectionLine = [];
  @override
  void initState() {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<InfrastructureApis>(context, listen: false)
          .getWareHouseSectionLineDetails(token)
          .then((value1) {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    wareHouseSectionLine = Provider.of<InfrastructureApis>(
      context,
    ).warehouseSectionLine;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ware House Section Line'),
        actions: [
          IconButton(
              onPressed: () {
                // Navigator.of(context)
                //     .pushNamed(AddWareHouseSectionLine.routeName);
                Get.toNamed(
                  AddWareHouseSectionLine.routeName,
                );
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          child: ListView.builder(
            itemCount: wareHouseSectionLine.length,
            itemBuilder: (BuildContext context, int index) {
              return DisplayWareHouseSectionLines(
                wareHouseSectionLine: wareHouseSectionLine,
                index: index,
                key: UniqueKey(),
              );
            },
          ),
        ),
      ),
    );
  }
}

class DisplayWareHouseSectionLines extends StatefulWidget {
  DisplayWareHouseSectionLines(
      {Key? key, required this.wareHouseSectionLine, required this.index})
      : super(key: key);
  final List wareHouseSectionLine;
  final int index;

  @override
  _DisplayWareHouseSectionLinesState createState() =>
      _DisplayWareHouseSectionLinesState();
}

class _DisplayWareHouseSectionLinesState
    extends State<DisplayWareHouseSectionLines> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: ListTile(
        title: Text(widget.wareHouseSectionLine[widget.index]
            ['WareHouse_Section_Line_Code']),
        // subtitle: Text(
        //     wareHouseSectionLine[index]['Inventory_Adjustment_Date']),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () {
                  // Navigator.of(context).pushNamed(
                  //     AddWareHouseSectionLine.routeName,
                  //     arguments: widget.wareHouseSectionLine[widget.index]);
                  Get.toNamed(AddWareHouseSectionLine.routeName,
                      arguments: widget.wareHouseSectionLine[widget.index]);
                },
                icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  Provider.of<Apicalls>(context, listen: false)
                      .tryAutoLogin()
                      .then((value) {
                    var token =
                        Provider.of<Apicalls>(context, listen: false).token;
                    Provider.of<InfrastructureApis>(context, listen: false)
                        .deleteWareHouseSectionLineDetails(
                            widget.wareHouseSectionLine[widget.index]
                                ['WareHouse_Section_Line_Id'],
                            token)
                        .then((value) {
                      if (value == 200 || value == 204) {
                        showDialog(
                            context: context,
                            builder: (ctx) => SuccessDialog(
                                title: 'Success',
                                subTitle:
                                    'SuccessFully Added Ware House Section Line'));
                      } else {
                        showDialog(
                            context: context,
                            builder: (ctx) => FailureDialog(
                                title: 'Failed',
                                subTitle:
                                    'Something Went Wrong Please Try Again'));
                      }
                    });
                  });
                },
                icon: const Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }
}
