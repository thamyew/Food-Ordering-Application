import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_ordering_application/user/profilePage.dart';
import 'package:food_ordering_application/user/saveLogin.dart';
import 'package:food_ordering_application/api/api_service.dart';

enum Gender { male, female }

// This class handles the Page to edit the Email Section of the User Profile.
class EditGenderFormPage extends StatefulWidget {
  const EditGenderFormPage({Key? key}) : super(key: key);

  @override
  EditGenderFormPageState createState() => EditGenderFormPageState();
}

class EditGenderFormPageState extends State<EditGenderFormPage> {
  Gender gender = Gender.male;

  void updateUserValue() async {
    String genderSelected;
    if (gender == Gender.male) {
      genderSelected = "male";
    } else {
      genderSelected = "female";
    }

    int data = (await (ApiService()
        .updateGender(SaveLogin().getUsername(), genderSelected)));

    if (data != 404) {
      Fluttertoast.showToast(
        msg: 'Successfully Update Gender',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyProfilePage(),
        ),
      );
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Failed to Update Gender',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text("Change Your Gender"),
          elevation: 0,
          toolbarHeight: 50,
        ),
        body: SingleChildScrollView(
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
                      "Please Select Your Gender",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    )),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: ListTile(
                    title: const Text('Male'),
                    leading: Radio(
                      value: Gender.male,
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value!;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: ListTile(
                    title: const Text('Female'),
                    leading: Radio(
                      value: Gender.female,
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value!;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 150),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: 320,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              updateUserValue();
                            },
                            child: const Text(
                              'Update',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        )))
              ]),
        ));
  }
}
