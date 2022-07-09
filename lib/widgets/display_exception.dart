import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/exception_handle.dart';

class DisplayException extends StatelessWidget {
  const DisplayException({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Consumer<ExceptionHandle>(builder: (context, value, child) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: value.exception.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(
                children: [
                  Text(value.exceptionData[index]['Key'] ?? ''),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(value.exceptionData[index]['Value'] ?? '')
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
