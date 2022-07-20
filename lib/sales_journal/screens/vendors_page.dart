import 'package:flutter/material.dart';
import 'package:poultry_login_signup/sales_journal/screens/company_vendors.dart';
import 'package:poultry_login_signup/sales_journal/screens/individual_vendors.dart';

class VendorsPage extends StatefulWidget {
  VendorsPage({Key? key}) : super(key: key);

  @override
  State<VendorsPage> createState() => _VendorsPageState();
}

class _VendorsPageState extends State<VendorsPage> {
  var selectedVendorType;

  @override
  Widget build(BuildContext context) {
    double formWidth = MediaQuery.of(context).size.width * 0.15;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: formWidth,
                padding: const EdgeInsets.only(bottom: 12),
                child: const Text('Vendor Type'),
              ),
              Container(
                width: formWidth,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  border: Border.all(color: Colors.black26),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      onTap: () {},
                      value: selectedVendorType,
                      items: ['Individual', 'Company']
                          .map<DropdownMenuItem<String>>((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        );
                      }).toList(),
                      hint: const Text('Select'),
                      onChanged: (value) {
                        setState(() {
                          selectedVendorType = value as String;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        selectedVendorType == 'Individual'
            ? IndividualVendors()
            : const SizedBox(),
        selectedVendorType == 'Company' ? CompanyVendors() : const SizedBox()
      ],
    );
  }
}
