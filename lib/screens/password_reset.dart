import 'package:flutter/material.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:provider/provider.dart';

class PasswordReset extends StatefulWidget {
  PasswordReset({Key? key}) : super(key: key);

  static const routeName = '/PasswordReset';

  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  var email;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    try {
      Provider.of<Apicalls>(context, listen: false)
          .resetPassword(email)
          .then((value) {
        if (value == 201 || value == 200) {
          // print('Resetting in');
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Link Sent Successful'),
              content: const Text('Check your Email and Reset your Password '),
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
              content: const Text('Please check your Email'),
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
                    const Text('Email'),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          email = value!;
                        },
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                  onPressed: _submit, child: const Text('Send Reset Link'))
            ],
          ),
        ),
      ),
    );
  }
}
