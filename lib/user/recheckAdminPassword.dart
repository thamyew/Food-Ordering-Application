import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_ordering_application/api/api_service.dart';
import 'package:food_ordering_application/user/editAdminPassword.dart';
import 'package:food_ordering_application/utilities/sizeConfig.dart';

// This class handles the Page to edit the Email Section of the User Profile.
class RecheckAdminPasswordFormPage extends StatefulWidget {
  const RecheckAdminPasswordFormPage({Key? key}) : super(key: key);

  @override
  RecheckAdminPasswordFormPageState createState() =>
      RecheckAdminPasswordFormPageState();
}

class RecheckAdminPasswordFormPageState
    extends State<RecheckAdminPasswordFormPage> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  void checkAdminPassword() async {
    int data = await (ApiService().checkAdminPassword(passwordController.text));

    if (data != 404) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const EditAdminPasswordFormPage(),
        ),
      );
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Admin Password Entered Incorrect',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text("Recheck Admin Password"),
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
                      "What's the admin password?",
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
                              return 'Please enter current admin password.';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              labelText: 'Admin password'),
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
                                checkAdminPassword();
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
