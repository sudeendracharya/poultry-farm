import 'package:flutter/material.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:provider/provider.dart';

class PasswordDetailsData extends StatefulWidget {
  PasswordDetailsData({
    Key? key,
    this.uid,
    this.token,
  }) : super(key: key);

  var uid;
  var token;

  static var routeName = '/PasswordReset/:id/:token/';

  @override
  _PasswordDetailsDataState createState() => _PasswordDetailsDataState();
}

class _PasswordDetailsDataState extends State<PasswordDetailsData> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  var password;
  var repeatPassword;

  @override
  void initState() {
    data['Uid'] = widget.uid;
    data['Token'] = widget.token;

    super.initState();
  }

  var data = {
    'Password': '',
    'Repeat_Password': '',
    'Uid': '',
    'Token': '',
  };
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    try {
      Provider.of<Apicalls>(context, listen: false)
          .resetPasswordDetails(data)
          .then((value) {
        if (value == 201 || value == 200) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Success'),
              content:
                  const Text('Your Password Has been Resetted Successfully'),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('ok'),
                )
              ],
            ),
          );

          // html.window.open('http://localhost:58731/#/', '_self');
        } else {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Unsuccessful'),
              content:
                  const Text('Something Went Wrong Please try Again Later'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 25),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('New Password'),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          data['Password'] = value!;
                        },
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Repeat Password'),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          data['Repeat_Password'] = value!;
                        },
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(onPressed: _submit, child: const Text('Submit'))
            ],
          ),
        ),
      ),
    );
  }
}
