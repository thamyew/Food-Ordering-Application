import 'dart:io';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_ordering_application/api/api_constant.dart';
import 'package:food_ordering_application/api/api_service.dart';
import 'package:food_ordering_application/manage_menu/archivedMenu.dart';
import 'package:food_ordering_application/manage_menu/manageMenu.dart';
import 'package:food_ordering_application/model/food_detail_model.dart';
import 'package:food_ordering_application/model/status_msg_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:food_ordering_application/utilities/sizeConfig.dart';
import 'package:image_picker/image_picker.dart';

class ViewFoodPage extends StatefulWidget {
  final String fromPage;
  final int foodId;
  const ViewFoodPage({Key? key, required this.fromPage, required this.foodId})
      : super(key: key);

  @override
  _ViewFoodPageState createState() => _ViewFoodPageState();
}

class _ViewFoodPageState extends State<ViewFoodPage> {
  List<StatusMsgModel>? msg;
  List<FoodDetailModel>? foodDetail;
  TextEditingController? nameController;
  TextEditingController? priceController;
  TextEditingController? descriptionController;
  final picker = ImagePicker();
  late File image;
  String? originalImagePath;

  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;
  bool isEditing = false;
  bool imageSelected = false;
  bool usingOriginalImage = true;
  bool usingDefaultImage = false;
  bool originalEqualDefault = false;

  @override
  void initState() {
    super.initState();
    clearCachedNetworkImageCache();
    getFoodData().then((value) => setState(() {
          isLoading = false;
          image =
              File("${ApiConstant.baseUrl}/${foodDetail![0].foodImgLocation}");
          nameController = TextEditingController(text: foodDetail![0].foodName);
          descriptionController =
              TextEditingController(text: foodDetail![0].foodDesc);

          String? priceFormatted;

          if (foodDetail![0].foodPrice.contains(".")) {
            if (foodDetail![0].foodPrice.length -
                    foodDetail![0].foodPrice.indexOf(".") -
                    1 <
                2) {
              priceFormatted = "RM ${foodDetail?[0].foodPrice}0";
            } else {
              priceFormatted = "RM ${foodDetail?[0].foodPrice}";
            }
          } else {
            priceFormatted = "RM ${foodDetail?[0].foodPrice}.00";
          }

          priceController = TextEditingController(text: priceFormatted);
          originalImagePath =
              "${ApiConstant.baseUrl}/${foodDetail![0].foodImgLocation}";

          if (originalImagePath ==
              "${ApiConstant.baseUrl}/images/food_pic/defaultFood.jpg") {
            originalEqualDefault = true;
            usingDefaultImage = true;
          }
        }));
  }

  void clearCachedNetworkImageCache() {
    DefaultCacheManager().emptyCache();
  }

  Future getFoodData() async {
    foodDetail = await (ApiService().readFoodDetail(widget.foodId));
  }

  Future chooseImage() async {
    var pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        usingOriginalImage = false;
        usingDefaultImage = false;
        imageSelected = true;
        image = File(pickedImage.path);
      }
    });
  }

  Future updateFoodData() async {
    var foodPrice = priceController!.text.substring(3);

    msg = await (ApiService().updateFoodDetail(widget.foodId,
        nameController!.text, descriptionController!.text, foodPrice));

    if (imageSelected) {
      msg = await (ApiService().updateFoodImage(widget.foodId, image.path));
    } else if (usingDefaultImage && !originalEqualDefault) {
      msg = await (ApiService().updateDefaultFoodImage(widget.foodId));
    }

    if (msg![0].statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'Successfully Update Food Detail',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ViewFoodPage(fromPage: widget.fromPage, foodId: widget.foodId),
        ),
      );
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Failed to Update Food Detail',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  Future recommendFood(recommend) async {
    int data = await (ApiService().recommendFood(widget.foodId, recommend));

    if (data == 200) {
      Fluttertoast.showToast(
        msg: 'Successfully Change Food Recommendation',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ViewFoodPage(fromPage: widget.fromPage, foodId: widget.foodId),
        ),
      );
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Failed to Change Food Recommendation',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  Future archiveFood() async {
    int data = await (ApiService().archiveFood(widget.foodId));

    if (data == 200) {
      Fluttertoast.showToast(
        msg: 'Successfully Archive Food',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ViewFoodPage(fromPage: widget.fromPage, foodId: widget.foodId),
        ),
      );
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Failed to Archive Food',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  Future restoreFood() async {
    int data = await (ApiService().restoreArchivedFood(widget.foodId));

    if (data == 200) {
      Fluttertoast.showToast(
        msg: 'Successfully Restore Food',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ViewFoodPage(fromPage: widget.fromPage, foodId: widget.foodId),
        ),
      );
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Failed to Restore Food',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  Future deleteFood() async {
    int data = await (ApiService().deleteFood(widget.foodId));

    if (data == 200) {
      Fluttertoast.showToast(
        msg: 'Successfully Delete Food',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: widget.fromPage == 'manageMenu'
                ? (context) => const ManageMenu()
                : (context) => const ArchivedMenu()),
      );
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Failed to Delete Food',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //toolbar
        title: const Text("Food Detail"),
        backgroundColor: Colors.blue,
        elevation: 0,
        toolbarHeight: 50,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.pop(context);
            widget.fromPage == 'manageMenu'
                ? Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ManageMenu()))
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ArchivedMenu()));
          },
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 25,
                      child: isEditing
                          ? InkWell(
                              onTap: () => chooseImage(),
                              child: imageSelected
                                  ? Center(child: Image.file(image))
                                  : Center(
                                      child: CachedNetworkImage(
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        imageUrl: image.path,
                                      ),
                                    ),
                            )
                          : InkWell(
                              child: Center(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  imageUrl: image.path,
                                ),
                              ),
                            ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: RatingBarIndicator(
                            rating: foodDetail![0].foodRating.toDouble(),
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 25.0,
                            direction: Axis.horizontal,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(13, 23, 0, 0),
                          child: foodDetail![0].countRating > 1
                              ? Text(
                                  "${foodDetail![0].countRating} ratings",
                                  style: const TextStyle(
                                    fontSize: 17,
                                  ),
                                )
                              : Text(
                                  "${foodDetail![0].countRating} rating",
                                  style: const TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                        )
                      ],
                    ),
                    if (isEditing) ...[
                      if (!usingDefaultImage || !usingOriginalImage)
                        const SizedBox(
                          height: 15,
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!usingOriginalImage)
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                      side:
                                          const BorderSide(color: Colors.blue),
                                      borderRadius:
                                          BorderRadius.circular(30.0))),
                              onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text(
                                            'Use Last Updated Image'),
                                        content: const Text(
                                            'Are you sure you want to use last updated image?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => setState(
                                              () {
                                                Navigator.pop(context);
                                                image =
                                                    File(originalImagePath!);
                                                usingOriginalImage = true;
                                                usingDefaultImage = false;
                                                imageSelected = false;

                                                if (originalEqualDefault) {
                                                  usingDefaultImage = true;
                                                }
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
                              child: const Text("Use Last Updated Image"),
                            ),
                          if (!usingDefaultImage && !usingOriginalImage)
                            const SizedBox(
                              width: 5,
                            ),
                          if (!usingDefaultImage)
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                      side: const BorderSide(color: Colors.red),
                                      borderRadius:
                                          BorderRadius.circular(30.0))),
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
                                                image = File(
                                                    "${ApiConstant.baseUrl}/images/food_pic/defaultFood.jpg");
                                                usingOriginalImage = false;
                                                usingDefaultImage = true;
                                                imageSelected = false;

                                                if (originalEqualDefault) {
                                                  usingOriginalImage = true;
                                                }
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
                            ),
                        ],
                      ),
                    ],
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: SizeConfig.safeBlockHorizontal * 25,
                            child: const Text("Name: "),
                          ),
                          SizedBox(
                            width: SizeConfig.safeBlockHorizontal * 65,
                            child: TextFormField(
                              controller: nameController,
                              readOnly: isEditing ? false : true,
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
                                      borderRadius:
                                          BorderRadius.circular(32.0))),
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
                            width: SizeConfig.safeBlockHorizontal * 25,
                            child: const Text("Price: "),
                          ),
                          SizedBox(
                            width: SizeConfig.safeBlockHorizontal * 65,
                            child: TextFormField(
                              controller: priceController,
                              readOnly: isEditing ? false : true,
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
                                      borderRadius:
                                          BorderRadius.circular(32.0))),
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
                            width: SizeConfig.safeBlockHorizontal * 25,
                            child: const Text("Description: "),
                          ),
                          SizedBox(
                            width: SizeConfig.safeBlockHorizontal * 65,
                            child: TextFormField(
                              maxLines: 5,
                              controller: descriptionController,
                              readOnly: isEditing ? false : true,
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
                                      borderRadius:
                                          BorderRadius.circular(32.0))),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    if (foodDetail![0].foodArchived == 1) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: SizeConfig.safeBlockHorizontal * 25,
                              child: const Text("Archive Expiry Date: "),
                            ),
                            SizedBox(
                              width: SizeConfig.safeBlockHorizontal * 65,
                              child: TextFormField(
                                initialValue:
                                    foodDetail![0].foodArchivedExpDate,
                                readOnly: true,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        20.0, 10.0, 20.0, 10.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(32.0))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                    ],
                    isEditing
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const SizedBox(
                                width: 25,
                              ),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                        side:
                                            const BorderSide(color: Colors.red),
                                        borderRadius:
                                            BorderRadius.circular(30.0))),
                                onPressed: () => {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text(
                                          'Cancel Update Food Detail'),
                                      content: const Text(
                                          'Are you sure you want to cancel update on this food?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => setState(() {
                                            Navigator.pop(context);
                                            image = File(originalImagePath!);
                                            isEditing = false;
                                            usingOriginalImage = true;
                                            if (originalEqualDefault) {
                                              usingDefaultImage = true;
                                            }
                                            imageSelected = false;
                                          }),
                                          child: const Text('Yes'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('No'),
                                        ),
                                      ],
                                    ),
                                  ),
                                },
                                child: const Text("Cancel Update"),
                              ),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            color: Colors.green),
                                        borderRadius:
                                            BorderRadius.circular(30.0))),
                                onPressed: () => {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Update Food Detail'),
                                      content: const Text(
                                          'Are you sure you want to update this food?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => {updateFoodData()},
                                          child: const Text('Yes'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('No'),
                                        ),
                                      ],
                                    ),
                                  ),
                                },
                                child: const Text("Confirm Update"),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            color: Colors.green),
                                        borderRadius:
                                            BorderRadius.circular(30.0))),
                                onPressed: () {
                                  setState(() {
                                    isEditing = true;
                                  });
                                },
                                child: const Text("Change Detail"),
                              ),
                              if (foodDetail![0].foodArchived == 0) ...[
                                if (foodDetail![0].foodRecommend == 0) ...[
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.orange,
                                        shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                                color: Colors.orange),
                                            borderRadius:
                                                BorderRadius.circular(30.0))),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Recommend Food'),
                                          content: const Text(
                                              'Are you sure you want to add this food to recommended list?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  {recommendFood(1)},
                                              child: const Text('Yes'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('No'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: const Text("Recommend Food"),
                                  ),
                                ] else ...[
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        foregroundColor: const Color.fromARGB(
                                            255, 195, 77, 13),
                                        shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 195, 77, 13)),
                                            borderRadius:
                                                BorderRadius.circular(30.0))),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title:
                                              const Text('Undo Recommend Food'),
                                          content: const Text(
                                              'Are you sure you want to remove this food from recommended list?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  {recommendFood(0)},
                                              child: const Text('Yes'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('No'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: const Text("Un-Recommend Food"),
                                  ),
                                ],
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color: Colors.red),
                                          borderRadius:
                                              BorderRadius.circular(30.0))),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Archive Food'),
                                        content: const Text(
                                            'Are you sure you want to archive this food?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => {archiveFood()},
                                            child: const Text('Yes'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('No'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: const Text("Archive Food"),
                                ),
                              ] else ...[
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.orange,
                                      shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color: Colors.orange),
                                          borderRadius:
                                              BorderRadius.circular(30.0))),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Restore Food'),
                                        content: const Text(
                                            'Are you sure you want to restore this food?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => {restoreFood()},
                                            child: const Text('Yes'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('No'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: const Text("Restore Food"),
                                ),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color: Colors.red),
                                          borderRadius:
                                              BorderRadius.circular(30.0))),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Delete Food'),
                                        content: const Text(
                                            'Are you sure you want to permanently delete this food?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => {deleteFood()},
                                            child: const Text('Yes'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('No'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: const Text("Delete Food"),
                                ),
                              ]
                            ],
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
