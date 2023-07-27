import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_ordering_application/user/profilePage.dart';
import 'package:food_ordering_application/user/saveLogin.dart';
import 'package:food_ordering_application/api/api_service.dart';
import 'package:food_ordering_application/model/status_msg_model.dart';
import 'package:food_ordering_application/utilities/sizeConfig.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

// This class handles the Page to edit the Email Section of the User Profile.
class EditPhoneNumberFormPage extends StatefulWidget {
  const EditPhoneNumberFormPage({Key? key}) : super(key: key);

  @override
  EditPhoneNumberFormPageState createState() => EditPhoneNumberFormPageState();
}

class EditPhoneNumberFormPageState extends State<EditPhoneNumberFormPage> {
  final _formKey = GlobalKey<FormState>();
  PhoneNumber phoneNum = PhoneNumber(isoCode: 'MY');
  late List<StatusMsgModel> model;

  void updateUserValue() async {
    model = (await (ApiService().updatePhoneNumber(
        SaveLogin().getUsername(), phoneNum.phoneNumber.toString())))!;

    if (model[0].statusCode != 404) {
      Fluttertoast.showToast(
        msg: 'Successfully Update Phone Number',
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
        msg: 'Phone Number Has Been Used',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text("Change Your Phone Number"),
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
                Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: SizedBox(
                        height: 100,
                        width: SizeConfig.screenWidth -
                            (SizeConfig.safeBlockHorizontal * 20),
                        child: InternationalPhoneNumberInput(
                          initialValue:
                              PhoneNumber(isoCode: 'MY', dialCode: '+60'),
                          onInputChanged: (value) {
                            phoneNum = value;
                          },
                          cursorColor: Colors.black,
                          formatInput: true,
                          selectorConfig: const SelectorConfig(
                              selectorType: PhoneInputSelectorType.DIALOG),
                          inputDecoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.only(bottom: 15, left: 0),
                              border: InputBorder.none,
                              hintText: "Phone Number",
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 16)),
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
                              updateUserValue();
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
