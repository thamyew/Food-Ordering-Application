import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_ordering_application/user/saveLogin.dart';
import 'package:food_ordering_application/api/api_service.dart';
import 'package:food_ordering_application/user/editEmail.dart';
import 'package:food_ordering_application/user/editPassword.dart';
import 'package:food_ordering_application/utilities/sizeConfig.dart';

// This class handles the Page to edit the Email Section of the User Profile.
class RecheckPasswordFormPage extends StatefulWidget {
  final String title;
  const RecheckPasswordFormPage({Key? key, required this.title})
      : super(key: key);

  @override
  RecheckPasswordFormPageState createState() => RecheckPasswordFormPageState();
}

class RecheckPasswordFormPageState extends State<RecheckPasswordFormPage> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  void checkPassword() async {
    int data = await (ApiService()
        .checkPassword(SaveLogin().getUsername(), passwordController.text));

    if (data != 404) {
      if (widget.title == "Email") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EditEmailFormPage(),
          ),
        );
      } else if (widget.title == "Password") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EditPasswordFormPage(),
          ),
        );
      }
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Password Entered Incorrect',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text("Recheck Password"),
          elevation: 0,
          toolbarHeight: 50,
        ),
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                    width: 320,
                    child: Text(
                      "What's your password?",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: SizedBox(
                        height: 100,
                        width: SizeConfig.screenWidth -
                            (SizeConfig.safeBlockHorizontal * 20),
                        child: TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(20),
                          ],
                          obscureText: true,
                          // Handles Form Validation
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password.';
                            }
                            return null;
                          },
                          decoration:
                              const InputDecoration(labelText: 'Your password'),
                          controller: passwordController,
                        ))),
                Padding(
                    padding: const EdgeInsets.only(top: 150),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: 320,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              // Validate returns true if the form is valid, or false otherwise.
                              if (_formKey.currentState!.validate()) {
                                checkPassword();
                              }
                            },
                            child: const Text(
                              'Submit',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        )))
              ]),
        )));
  }
}
