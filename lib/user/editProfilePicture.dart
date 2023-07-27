import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_ordering_application/model/image_model.dart';
import 'package:food_ordering_application/user/profilePage.dart';
import 'package:food_ordering_application/user/saveLogin.dart';
import 'package:food_ordering_application/api/api_service.dart';
import 'package:food_ordering_application/model/status_msg_model.dart';
import 'package:food_ordering_application/widgets/displayImageWidget.dart';
import 'package:image_picker/image_picker.dart';

import 'package:food_ordering_application/api/api_constant.dart';

// This class handles the Page to edit the Email Section of the User Profile.
class EditProfileImageFormPage extends StatefulWidget {
  final List<ImageModel> imageModel;
  const EditProfileImageFormPage({Key? key, required this.imageModel})
      : super(key: key);

  @override
  EditProfileImageFormPageState createState() =>
      EditProfileImageFormPageState();
}

class EditProfileImageFormPageState extends State<EditProfileImageFormPage> {
  late File image = File(
      "${ApiConstant.baseUrl}/${widget.imageModel[0].path}${widget.imageModel[0].filename}");
  final picker = ImagePicker();
  late List<StatusMsgModel> model;

  Future choiceImage() async {
    var pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
    }
  }

  void uploadImage() async {
    model = (await ApiService()
        .updateProfileImage(SaveLogin().getUsername(), image.path))!;

    if (model[0].statusCode != 404) {
      Fluttertoast.showToast(
        msg: 'Successfully Update Profile Picture',
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
        msg: 'Failed to Update Profile Picture',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  void useDefaultAvatar() async {
    model = (await ApiService()
        .updateDefaultProfileImage(SaveLogin().getUsername()))!;

    if (model[0].statusCode != 404) {
      Fluttertoast.showToast(
        msg: 'Successfully Update Profile Picture',
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
        msg: 'Failed to Update Profile Picture',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          title: const Text("Update Profile Picture"),
        ),
        body: Center(
            child: SingleChildScrollView(
          child: Column(children: <Widget>[
            DisplayImage(
              imagePath: image.path,
              onPressed: () {},
            ),
            IconButton(
                onPressed: () {
                  choiceImage();
                },
                icon: const Icon(Icons.camera)),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              onPressed: () {
                uploadImage();
              },
              child: const Text("Submit Uploaded Image"),
            ),
            MaterialButton(
              onPressed: () {
                useDefaultAvatar();
              },
              child: const Text("Use Default Avatar"),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyProfilePage()));
              },
              child: const Text("Back to Profile"),
            )
          ]),
        )));
  }
}
