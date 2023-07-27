import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_application/api/api_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_ordering_application/user/forgetPassword.dart';
import 'package:food_ordering_application/user/profilePage.dart';
import 'package:food_ordering_application/user/saveLogin.dart';
import 'package:food_ordering_application/user/userRegistration.dart';
import 'package:food_ordering_application/utilities/sizeConfig.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  String? fcmToken;
  bool isAutoLogin = true;

  final storage = const FlutterSecureStorage();

  Future<void> storeData(username, password) async {
    await storage.write(key: "KEY_USERNAME", value: username);
    await storage.write(key: "KEY_PASSWORD", value: password);
  }

  Future<void> readData() async {
    fcmToken = await FirebaseMessaging.instance.getToken();
    user.text = await storage.read(key: "KEY_USERNAME") ?? '';
    pass.text = await storage.read(key: "KEY_PASSWORD") ?? '';

    if (user.text != '') {
      int response = await ApiService().autoLoginFCMToken(user.text, fcmToken);
      if (response == 1) {
        login(user.text, pass.text);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    readData();

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isAutoLogin = false;
      });
    });
  }

  Future login(username, password) async {
    int data = await (ApiService().login(username, password));

    if (data != 404) {
      Fluttertoast.showToast(
        msg: 'Login Successful',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );

      storeData(SaveLogin().getUsername(), password);
      if (await (ApiService().checkFCM(username)) == 0) {
        ApiService().addFCMToken(
            SaveLogin().getUsername(), fcmToken, SaveLogin().getLevel());
      } else {
        if (await ApiService().autoLoginFCMToken(user.text, fcmToken) == 0) {
          ApiService().updateFCM(SaveLogin().getUsername(), fcmToken);
        }
      }

      if (SaveLogin().getLevel() == 1) {
        ApiService().checkAchievement(SaveLogin().getUsername());
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MyProfilePage(),
        ),
      );
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Username and password invalid',
        toastLength: Toast.LENGTH_SHORT,
      );
      storage.deleteAll();
    }

    user.text = "";
    pass.text = "";
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/login.png'),
          fit: SizeConfig.screenWidth > 800 ? BoxFit.fill : BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                  left: SizeConfig.safeBlockHorizontal * 7,
                  top: SizeConfig.screenWidth > 800
                      ? SizeConfig.safeBlockVertical * 23
                      : SizeConfig.safeBlockVertical * 21),
              child: const Text(
                'Welcome',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(top: SizeConfig.screenHeight * 0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: SizeConfig.safeBlockHorizontal * 7,
                        right: SizeConfig.safeBlockHorizontal * 7,
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: user,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Username or Email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: SizeConfig.screenHeight / 20,
                          ),
                          TextField(
                            controller: pass,
                            style: const TextStyle(),
                            obscureText: true,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: SizeConfig.screenHeight / 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Sign in',
                                style: TextStyle(
                                    fontSize: 27, fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: const Color(0xff4c505b),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      login(user.text, pass.text);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward,
                                    )),
                              )
                            ],
                          ),
                          SizedBox(
                            height: SizeConfig.screenHeight / 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: const Text('Welcome'),
                                            content: const Text('Sign Up As'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const UserRegistration(
                                                        accountType: "Customer",
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: const Text('Customer'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const UserRegistration(
                                                        accountType:
                                                            "Administrator",
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child:
                                                    const Text('Administrator'),
                                              ),
                                            ],
                                          ));
                                },
                                style: const ButtonStyle(),
                                child: const Text(
                                  'Sign Up',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color.fromARGB(255, 46, 61, 103),
                                      fontSize: 18),
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const MyForgetPassword(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Forgot Password',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color.fromARGB(255, 46, 61, 103),
                                      fontSize: 18,
                                    ),
                                  )),
                            ],
                          )
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
