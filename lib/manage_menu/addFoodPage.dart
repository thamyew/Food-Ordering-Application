import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_ordering_application/api/api_constant.dart';
import 'package:food_ordering_application/api/api_service.dart';
import 'package:food_ordering_application/manage_menu/manageMenu.dart';
import 'package:food_ordering_application/model/status_msg_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:food_ordering_application/utilities/sizeConfig.dart';
import 'package:image_picker/image_picker.dart';

enum Recommend { yes, no }

class AddFoodPage extends StatefulWidget {
  const AddFoodPage({Key? key}) : super(key: key);

  @override
  _AddFoodPageState createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  List<StatusMsgModel>? msg;
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final picker = ImagePicker();
  late File image =
      File("${ApiConstant.baseUrl}/images/food_pic/defaultFood.jpg");
  Recommend recommend = Recommend.no;
  bool imageSelected = false;
  final _formKey = GlobalKey<FormState>();

  Future chooseImage() async {
    var pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        imageSelected = true;
        image = File(pickedImage.path);
      }
    });
  }

  Future addFoodData() async {
    var foodRecommend = 0;
    if (recommend == Recommend.yes) foodRecommend = 1;

    var foodPrice = priceController.text.substring(3);

    if (imageSelected) {
      msg = await (ApiService().addFood(nameController.text,
          descriptionController.text, foodPrice, foodRecommend, image.path));
    } else {
      msg = await (ApiService().addFoodDefImage(nameController.text,
          descriptionController.text, foodPrice, foodRecommend));
    }

    if (msg![0].statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'Successfully Add Food',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ManageMenu(),
        ),
      );
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Failed to Add Food',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //toolbar
        title: const Text("Add Food Menu"),
        backgroundColor: Colors.blue,
        elevation: 0,
        toolbarHeight: 50,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              if (imageSelected) ...[
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 27,
                  child: InkWell(
                    onTap: () => chooseImage(),
                    child: Center(
                      child: Image.file(File(image.path)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(30.0))),
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text('Use Default Image'),
                            content: const Text(
                                'Are you sure you want to use default image?'),
                            actions: [
                              TextButton(
                                onPressed: () => setState(
                                  () {
                                    Navigator.pop(context);
                                    imageSelected = false;
                                  },
                                ),
                                child: const Text('Yes'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('No'),
                              ),
                            ],
                          )),
                  child: const Text("Use Default Food Image"),
                )
              ] else ...[
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 25,
                  child: InkWell(
                    onTap: () => chooseImage(),
                    child: Center(
                      child: CachedNetworkImage(
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        imageUrl:
                            "${ApiConstant.baseUrl}/images/food_pic/defaultFood.jpg",
                      ),
                    ),
                  ),
                ),
              ],
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal * 20,
                      child: const Text("Name: "),
                    ),
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal * 70,
                      child: TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the food name.';
                          }
                          return null;
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),
                        ],
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(
                                20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0))),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal * 20,
                      child: const Text("Price: "),
                    ),
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal * 70,
                      child: TextFormField(
                        controller: priceController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the food price.';
                          }
                          return null;
                        },
                        inputFormatters: [
                          CurrencyTextInputFormatter(symbol: "RM "),
                          LengthLimitingTextInputFormatter(8),
                        ],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(
                                20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0))),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal * 20,
                      child: const Text("Description: "),
                    ),
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal * 70,
                      child: TextFormField(
                        maxLines: 5,
                        controller: descriptionController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the food description.';
                          }
                          return null;
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(200),
                        ],
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(
                                20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0))),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal * 40,
                      child: const Text("Recommended Food: "),
                    ),
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal * 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: SizeConfig.safeBlockHorizontal * 1,
                          ),
                          Expanded(
                              child: Row(
                            children: [
                              Radio(
                                value: Recommend.yes,
                                groupValue: recommend,
                                onChanged: (value) {
                                  setState(() {
                                    recommend = value!;
                                  });
                                },
                              ),
                              const Expanded(
                                child: Text('Yes'),
                              ),
                              Radio(
                                value: Recommend.no,
                                groupValue: recommend,
                                onChanged: (value) {
                                  setState(() {
                                    recommend = value!;
                                  });
                                },
                              ),
                              const Expanded(
                                child: Text('No'),
                              ),
                            ],
                          ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(30.0))),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text('Add New Food'),
                              content: const Text(
                                  'Are you sure you want to add this food?'),
                              actions: [
                                TextButton(
                                  onPressed: () => {addFoodData()},
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
                  }
                },
                child: const Text("Confirm"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
