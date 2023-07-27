import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_ordering_application/api/api_service.dart';
import 'package:food_ordering_application/user/profilePage.dart';
import 'package:food_ordering_application/utilities/sizeConfig.dart';

// This class handles the Page to edit the Email Section of the User Profile.
class EditAdminPasswordFormPage extends StatefulWidget {
  const EditAdminPasswordFormPage({Key? key}) : super(key: key);

  @override
  EditAdminPasswordFormPageState createState() =>
      EditAdminPasswordFormPageState();
}

class EditAdminPasswordFormPageState extends State<EditAdminPasswordFormPage> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  void updateUserValue() async {
    int data =
        (await (ApiService().updateAdminPassword(passwordController.text)));

    if (data != 404) {
      Fluttertoast.showToast(
        msg: 'Successfully Update Admin Password',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyProfilePage2(),
        ),
      );
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Failed to Update Admin Password',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text("Change Admin Password"),
          elevation: 0,
          toolbarHeight: 50,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyProfilePage2()))),
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
                              return 'Please enter new admin password.';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              labelText: 'New admin password'),
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
                                updateUserValue();
                              }
                            },
                            child: const Text(
                              'Update',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        )))
              ]),
        )));
  }
}
