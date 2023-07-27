import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_ordering_application/api/api_service.dart';
import 'package:food_ordering_application/model/status_msg_model.dart';
import 'package:food_ordering_application/user/resetPassword.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class MyForgetPasswordVerificationCode extends StatefulWidget {
  final String email;
  const MyForgetPasswordVerificationCode({Key? key, required this.email})
      : super(key: key);

  @override
  _MyForgetPasswordVerificationCode createState() =>
      _MyForgetPasswordVerificationCode();
}

class _MyForgetPasswordVerificationCode
    extends State<MyForgetPasswordVerificationCode> {
  late List<StatusMsgModel> _model;

  Future checkPassKey(passKey) async {
    _model = (await (ApiService().checkPassKey(passKey, widget.email)))!;
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));

    if (_model[0].statusCode != 404) {
      String userEmail = widget.email;
      Fluttertoast.showToast(
        msg: _model[0].statusMsg,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyResetPassword(email: userEmail)));
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: _model[0].statusMsg,
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/register.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 35, top: 30),
              child: const Text(
                'Enter 6-Digit Code',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 35, top: 80),
              child: const Text(
                'A 6-Digit Code Has Been Sent to Your Email',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          PinCodeTextField(
                            autoFocus: true,
                            appContext: context,
                            length: 6,
                            onChanged: (passKey) {},
                            pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(5),
                                fieldHeight: 50,
                                fieldWidth: 40,
                                inactiveColor: Colors.grey,
                                activeColor: Colors.blue[100],
                                selectedColor: Colors.blue),
                            onCompleted: (passKey) {
                              checkPassKey(passKey);
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
