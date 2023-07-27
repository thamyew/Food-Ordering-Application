import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_ordering_application/api/api_service.dart';
import 'package:food_ordering_application/user/editAddress.dart';
import 'package:food_ordering_application/user/editGender.dart';
import 'package:food_ordering_application/user/editName.dart';
import 'package:food_ordering_application/user/editPhoneNumber.dart';
import 'package:food_ordering_application/user/editProfilePicture.dart';
import 'package:food_ordering_application/user/login.dart';

import 'package:food_ordering_application/user/recheckAdminPassword.dart';
import 'package:food_ordering_application/user/recheckPassword.dart';
import 'package:food_ordering_application/user/saveLogin.dart';

import 'package:food_ordering_application/model/user_model.dart';
import 'package:food_ordering_application/model/image_model.dart';

import 'package:food_ordering_application/api/api_constant.dart';
import 'package:food_ordering_application/utilities/sizeConfig.dart';
import 'package:food_ordering_application/widgets/displayImageWidget.dart';
import 'package:food_ordering_application/widgets/navBarWidget.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  List<UserModel> userModel = [];
  List<ImageModel> userImageModel = [];
  final username = SaveLogin().getUsername();
  final level = SaveLogin().getLevel();
  bool _isLoading = true;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  String currentPage = 'profile';

  @override
  void initState() {
    super.initState();
    getUserProfile().then((value) => setState(() {
          _isLoading = false;
        }));
  }

  Future getUserProfile() async {
    userModel = (await (ApiService().getUserProfile(username)))!;
    userImageModel =
        (await (ApiService().getUserProfileImage(userModel[0].profilePicId)))!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: NavSideBar(currentPage),
      body: Column(
        children: [
          AppBar(
            backgroundColor: Colors.blue,
            elevation: 0,
            toolbarHeight: 50,
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: const Icon(Icons.more_horiz_rounded),
                onPressed: () => _key.currentState?.openDrawer()),
          ),
          if (_isLoading) ...[
            const Center(
                child: Padding(
              padding: EdgeInsets.only(top: 300),
              child: CircularProgressIndicator(),
            )),
          ] else ...[
            const Center(
                child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      'My Profile',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(64, 105, 225, 1),
                      ),
                    ))),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                navigateSecondPage(
                    EditProfileImageFormPage(imageModel: userImageModel),
                    context);
              },
              child: userImageModel.isNotEmpty
                  ? DisplayImage(
                      imagePath:
                          "${ApiConstant.baseUrl}/${userImageModel[0].path}${userImageModel[0].filename}",
                      onPressed: () {})
                  : const Padding(
                      padding: EdgeInsets.only(top: 300),
                      child: CircularProgressIndicator(),
                    ),
            ),
            const SizedBox(
              height: 30,
            ),
            buildUserInfoDisplay(
                userModel[0].name, 'Name', const EditNameFormPage(), context),
            buildGenderDisplay(userModel[0].gender, 'Gender',
                const EditGenderFormPage(), context),
            buildUserInfoDisplay(userModel[0].phoneNum, 'Phone Number',
                const EditPhoneNumberFormPage(), context),
            buildUserInfoDisplay(userModel[0].address, "Address",
                const EditAddressFormPage(), context),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyProfilePage2()));
                    },
                    child: const Text("Account Information ->"),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ],
      ),
    );
  }

  Widget buildUserInfoDisplay(String getValue, String title, Widget editPage,
          BuildContext context) =>
      Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 1,
              ),
              Container(
                  width: SizeConfig.screenWidth -
                      (SizeConfig.safeBlockHorizontal * 10),
                  height: 40,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ))),
                  child: Row(children: [
                    Expanded(
                        child: Text(
                      getValue,
                    )),
                    TextButton(
                      child: Text("Change $title"),
                      onPressed: () => navigateSecondPage(editPage, context),
                    )
                  ]))
            ],
          ));

  Widget buildGenderDisplay(String getValue, String title, Widget editPage,
          BuildContext context) =>
      Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 1,
              ),
              Container(
                  width: SizeConfig.screenWidth -
                      (SizeConfig.safeBlockHorizontal * 10),
                  height: 40,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ))),
                  child: Row(children: [
                    Expanded(
                        child: getValue == "1"
                            ? const Text(
                                "Female",
                              )
                            : const Text(
                                "Male",
                              )),
                    TextButton(
                      child: Text("Change $title"),
                      onPressed: () => navigateSecondPage(editPage, context),
                    )
                  ]))
            ],
          ));

  Widget buildUserInfoDisplayWithPasswordRecheck(String getValue, String title,
          Widget editPage, BuildContext context) =>
      Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 1,
              ),
              Container(
                  width: SizeConfig.screenWidth -
                      (SizeConfig.safeBlockHorizontal * 10),
                  height: 40,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ))),
                  child: Row(children: [
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              navigateSecondPage(editPage, context);
                            },
                            child: Text(
                              getValue,
                              style: const TextStyle(fontSize: 16, height: 1.4),
                            ))),
                    const Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.grey,
                      size: 40.0,
                    )
                  ]))
            ],
          ));

  // Widget builds the display item with the proper formatting to display the user's info
  Widget buildUserInfoDisplayWithoutWidget(String getValue, String title) =>
      Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 1,
              ),
              Container(
                  width: SizeConfig.screenWidth -
                      (SizeConfig.safeBlockHorizontal * 10),
                  height: 40,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ))),
                  child: Row(children: [
                    Expanded(
                        child: Text(
                      getValue,
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    )),
                  ]))
            ],
          ));

  // Refrshes the Page after updating user info.
  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  // Handles navigation and prompts refresh.
  void navigateSecondPage(Widget editForm, BuildContext context) {
    Route route = MaterialPageRoute(builder: (context) => editForm);
    Navigator.push(context, route).then(onGoBack);
  }
}

// This class handles the Page to display the user's info on the "Profile" Screen
class MyProfilePage2 extends StatefulWidget {
  const MyProfilePage2({super.key});

  @override
  _MyProfilePage2State createState() => _MyProfilePage2State();
}

class _MyProfilePage2State extends State<MyProfilePage2> {
  List<UserModel>? userModel;
  final username = SaveLogin().getUsername();
  final level = SaveLogin().getLevel();
  final storage = const FlutterSecureStorage();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserProfile().then((value) => setState(() {
          _isLoading = false; // <-- Code run after delay
        }));
  }

  Future getUserProfile() async {
    userModel = (await (ApiService().getUserProfile(username)))!;
  }

  Future deleteUser(BuildContext context) async {
    int? data1 = await ApiService().checkOngoingOrder(username);

    if (data1 == 200) {
      int data = await (ApiService().deleteUser(SaveLogin().getUsername()));

      if (data != 404) {
        storage.deleteAll();
        Fluttertoast.showToast(
          msg: 'Successfully Delete User',
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
          msg: 'Failed to Delete User',
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Failed to Delete User. There still exists ongoing order!',
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBar(
            backgroundColor: Colors.blue,
            elevation: 0,
            toolbarHeight: 50,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyProfilePage()))),
          ),
          if (_isLoading) ...[
            const Center(
                child: Padding(
              padding: EdgeInsets.only(top: 300),
              child: CircularProgressIndicator(),
            )),
          ] else ...[
            SingleChildScrollView(
                child: Column(
              children: [
                const Center(
                    child: Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          'Account Information',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(64, 105, 225, 1),
                          ),
                        ))),
                const SizedBox(
                  height: 20,
                ),
                buildUserInfoDisplayWithoutWidget(
                    userModel![0].username, 'Username'),
                buildUserInfoDisplay(
                    userModel![0].email,
                    'Email',
                    const RecheckPasswordFormPage(
                      title: "Email",
                    ),
                    context),
                buildUserInfoDisplay("*********", 'Password',
                    const RecheckPasswordFormPage(title: "Password"), context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (SaveLogin().getLevel() == 0) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 22, 0),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RecheckAdminPasswordFormPage()));
                          },
                          child: const Text("Change Admin Password"),
                        ),
                      )
                    ],
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 200, 0, 0),
                    child: MaterialButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text('Delete Account'),
                                  content: const Text(
                                      'Are you sure you want to delete the account?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        deleteUser(context);
                                      },
                                      child: const Text('Yes'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('No'),
                                    ),
                                  ],
                                ));
                      },
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        "Delete My Account",
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    )),
              ],
            )),
          ],
        ],
      ),
    );
  }

  // Widget builds the display item with the proper formatting to display the user's info
  Widget buildUserInfoDisplay(String getValue, String title, Widget editPage,
          BuildContext context) =>
      Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 1,
              ),
              Container(
                  width: SizeConfig.screenWidth -
                      (SizeConfig.safeBlockHorizontal * 10),
                  height: 40,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ))),
                  child: Row(children: [
                    Expanded(
                        child: Text(
                      getValue,
                    )),
                    TextButton(
                      child: Text("Change $title"),
                      onPressed: () => navigateSecondPage(editPage, context),
                    )
                  ]))
            ],
          ));

  // Widget builds the display item with the proper formatting to display the user's info
  Widget buildUserInfoDisplayWithoutWidget(String getValue, String title) =>
      Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 1,
              ),
              Container(
                  width: SizeConfig.screenWidth -
                      (SizeConfig.safeBlockHorizontal * 10),
                  height: 40,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ))),
                  child: Row(children: [
                    Expanded(
                        child: Text(
                      getValue,
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    )),
                  ]))
            ],
          ));

  // Refrshes the Page after updating user info.
  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  // Handles navigation and prompts refresh.
  void navigateSecondPage(Widget editForm, BuildContext context) {
    Route route = MaterialPageRoute(builder: (context) => editForm);
    Navigator.push(context, route).then(onGoBack);
  }
}
