import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_ordering_application/api/api_service.dart';
import 'package:food_ordering_application/user/login.dart';
import 'package:food_ordering_application/model/status_msg_model.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

enum Gender { male, female }

class UserRegistration extends StatefulWidget {
  static String tag = 'UserRegistration';
  final String accountType;

  const UserRegistration({super.key, required this.accountType});

  @override
  UserRegistrationState createState() => UserRegistrationState();
}

class UserRegistrationState extends State<UserRegistration> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final adminPasswordController = TextEditingController();
  PhoneNumber phoneNum = PhoneNumber(isoCode: 'MY');
  Gender gender = Gender.male;
  late List<StatusMsgModel> model;

  Future registerUser(accountType) async {
    String genderSelected = "female";
    if (gender == Gender.male) {
      genderSelected = "male";
    }

    if (accountType == "Customer") {
      model = (await (ApiService().registerCustomer(
          usernameController.text,
          passwordController.text,
          emailController.text,
          nameController.text,
          phoneNum.phoneNumber,
          genderSelected,
          addressController.text)))!;
    } else {
      model = (await (ApiService().registerAdministrator(
          "0",
          adminPasswordController.text,
          usernameController.text,
          passwordController.text,
          emailController.text,
          nameController.text,
          phoneNum.phoneNumber,
          genderSelected,
          addressController.text)))!;
    }

    if (model[0].statusCode != 404) {
      Fluttertoast.showToast(
        msg: 'Successfully Register User',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MyLogin(),
        ),
      );
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: model[0].statusMsg,
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = TextFormField(
      controller: emailController,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email.';
        }
        return null;
      },
      //用户名
      keyboardType: TextInputType.emailAddress,
      autofocus: false, //是否自动对焦
      //initialValue: 'Name', //默认输入的类容
      decoration: InputDecoration(
          hintText: 'Email', //提示内容
          contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0) //设置圆角大小
              )),
    );

    final nameOfUser = TextFormField(
      controller: nameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your name.';
        }
        return null;
      },
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
      //用户名
      keyboardType: TextInputType.emailAddress,
      autofocus: false, //是否自动对焦
      //initialValue: 'Name', //默认输入的类容
      decoration: InputDecoration(
          hintText: 'Name', //提示内容
          contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0) //设置圆角大小
              )),
    );

    final username = TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your username.';
        }
        return null;
      },
      controller: usernameController,
      inputFormatters: [
        LengthLimitingTextInputFormatter(20),
      ],
      //用户名
      keyboardType: TextInputType.emailAddress,
      autofocus: false, //是否自动对焦
      //initialValue: 'Name', //默认输入的类容
      decoration: InputDecoration(
          hintText: 'Username', //提示内容
          contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0) //设置圆角大小
              )),
    );

    final genderField = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SizedBox(
          width: 18,
        ),
        const Text(
          "Gender: ",
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
            child: Row(
          children: [
            Radio(
              value: Gender.male,
              groupValue: gender,
              onChanged: (value) {
                setState(() {
                  gender = value!;
                });
              },
            ),
            const Expanded(
              child: Text('Male'),
            ),
            Radio(
              value: Gender.female,
              groupValue: gender,
              onChanged: (value) {
                setState(() {
                  gender = value!;
                });
              },
            ),
            const Expanded(
              child: Text('Female'),
            ),
          ],
        ))
      ],
    );

    final address = TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your address.';
        }
        return null;
      },
      controller: addressController,
      inputFormatters: [
        LengthLimitingTextInputFormatter(100),
      ],
      //用户名
      keyboardType: TextInputType.emailAddress,
      autofocus: false, //是否自动对焦
      //initialValue: 'Name', //默认输入的类容
      decoration: InputDecoration(
          hintText: 'Address', //提示内容
          contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0) //设置圆角大小
              )),
    );

    final phoneNumber = Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            SizedBox(
              width: 18,
            ),
            Text(
              "Phone Number: ",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        InternationalPhoneNumberInput(
          initialValue: PhoneNumber(isoCode: 'MY', dialCode: '+60'),
          onInputChanged: (value) {
            phoneNum = value;
          },
          cursorColor: Colors.black,
          formatInput: true,
          selectorConfig:
              const SelectorConfig(selectorType: PhoneInputSelectorType.DIALOG),
          inputDecoration: InputDecoration(
              contentPadding: const EdgeInsets.only(bottom: 15, left: 0),
              border: InputBorder.none,
              hintText: "Phone Number",
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
        )
      ],
    );

    final password = TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password.';
        }
        return null;
      },
      controller: passwordController,
      inputFormatters: [
        LengthLimitingTextInputFormatter(20),
      ],
      //密码
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
          hintText: 'Password',
          contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final adminPassword = TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter admin password.';
        }
        return null;
      },
      controller: adminPasswordController,
      inputFormatters: [
        LengthLimitingTextInputFormatter(20),
      ],
      //密码
      autofocus: false,
      //initialValue: 'Gender',
      obscureText: true,
      decoration: InputDecoration(
          hintText: 'Admin Password',
          contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final buttonGroup = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16), //上下各添加16像素补白
          child: Material(
            borderRadius: BorderRadius.circular(30.0), // 圆角度
            shadowColor: Colors.lightBlueAccent.shade100, //阴影颜色
            elevation: 5.0,
            child: MaterialButton(
              minWidth: 150.0,
              height: 42.0,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MyLogin()));
              },
              color: Colors.red,
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0), //上下各添加16像素补白
          child: Material(
            borderRadius: BorderRadius.circular(30.0), // 圆角度
            shadowColor: Colors.lightBlueAccent.shade100, //阴影颜色
            elevation: 5.0,
            child: MaterialButton(
              minWidth: 150.0,
              height: 42.0,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  registerUser(widget.accountType);
                }
              },
              color: Colors.green,
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ),
        ),
      ],
    );

    return Scaffold(
        backgroundColor: Colors.white,
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: 10,
                  color: Colors.lightGreen,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                    child: const Text("Register User",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ))),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                    children: <Widget>[
                      const SizedBox(
                        height: 20.0,
                      ),
                      nameOfUser,
                      const SizedBox(
                        height: 8.0,
                      ),
                      genderField,
                      const SizedBox(
                        height: 8.0,
                      ),
                      address,
                      const SizedBox(
                        height: 8.0,
                      ),
                      username,
                      const SizedBox(
                        height: 8.0,
                      ),
                      phoneNumber,
                      const SizedBox(
                        height: 8.0,
                      ),
                      email,
                      const SizedBox(
                        height: 8.0,
                      ),
                      password,
                      if (widget.accountType == "Administrator") ...[
                        const SizedBox(
                          height: 8.0,
                        ),
                        adminPassword,
                      ],
                      const SizedBox(
                        height: 24.0,
                      ),
                      buttonGroup,
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: 10,
                  color: Colors.lightGreen,
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ))));
  }
}
