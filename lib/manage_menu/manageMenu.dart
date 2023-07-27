import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_ordering_application/api/api_constant.dart';
import 'package:food_ordering_application/api/api_service.dart';
import 'package:food_ordering_application/app_theme.dart';
import 'package:food_ordering_application/manage_menu/addFoodPage.dart';
import 'package:food_ordering_application/manage_menu/viewFoodDetail.dart';
import 'package:food_ordering_application/model/food_menu_model.dart';
import 'package:food_ordering_application/utilities/sizeConfig.dart';
import 'package:food_ordering_application/widgets/navBarWidget.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageMenu extends StatefulWidget {
  const ManageMenu({Key? key}) : super(key: key);

  @override
  _ManageMenuState createState() => _ManageMenuState();
}

class _ManageMenuState extends State<ManageMenu> {
  String currentPage = "manageMenu";
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  List<FoodMenuModel>? menu;
  List<FoodMenuModel>? normalMenu;
  List<FoodMenuModel>? recommendedMenu;
  ScrollController mainScrollController = ScrollController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    clearCachedNetworkImageCache();
    getMenuData().then((value) => setState(() {
          _isLoading = false;
        }));
  }

  void clearCachedNetworkImageCache() {
    DefaultCacheManager().emptyCache();
  }

  Future getMenuData() async {
    menu = (await (ApiService().readFoodMenu()));
    normalMenu = menu?.where((i) => i.foodRecommend == 0).toList();
    recommendedMenu = menu?.where((i) => i.foodRecommend == 1).toList();
  }

  Future recommendFood(foodId, recommendkey, context) async {
    int response = await (ApiService().recommendFood(foodId, recommendkey));

    if (response != 404) {
      Fluttertoast.showToast(
        msg: recommendkey == 1
            ? 'Successfully Recommend Food'
            : 'Successfully Undo Recommendation',
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
        msg: recommendkey == 1
            ? 'Failed to Recommend Food'
            : 'Failed to Undo Recommendation',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  Future archiveFoodData(foodId, context) async {
    int response = await (ApiService().archiveFood(foodId));

    if (response != 404) {
      Fluttertoast.showToast(
        msg: 'Successfully Archive Food',
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
        msg: 'Failed to Archive Food',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: NavSideBar(currentPage),
        appBar: AppBar(
          //toolbar
          title: const Text("Manage Menu"),
          backgroundColor: Colors.blue,
          elevation: 0,
          toolbarHeight: 50,
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: const Icon(Icons.more_horiz_rounded),
              onPressed: () => _key.currentState?.openDrawer()),
          actions: [
            IconButton(
                icon: const Icon(Icons.add_box_outlined),
                iconSize: 30,
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddFoodPage()))),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : menu == null
                ? Center(
                    child: Text("There is no food right now...",
                        textAlign: TextAlign.center,
                        style: AppTheme.of(context).subtitle2),
                  )
                : ListView(
                    controller: mainScrollController,
                    children: [
                      if (recommendedMenu!.isNotEmpty) ...[
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.recommend,
                                color: Colors.yellow[600],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Recommended",
                                style: GoogleFonts.lobster(
                                  textStyle: const TextStyle(fontSize: 25),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: recommendedMenu?.length,
                          itemBuilder: (context, index) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 5,
                              child: Column(children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                CachedNetworkImage(
                                  height: SizeConfig.screenHeight / 5,
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  imageUrl:
                                      "${ApiConstant.baseUrl}/${recommendedMenu?[index].foodImgLocation}",
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 10, 0, 0),
                                      child: RatingBarIndicator(
                                        rating: recommendedMenu![index]
                                            .foodRating
                                            .toDouble(),
                                        itemBuilder: (context, index) =>
                                            const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        itemCount: 5,
                                        itemSize: 25.0,
                                        direction: Axis.horizontal,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          13, 13, 0, 0),
                                      child:
                                          recommendedMenu![index].countRating >
                                                  1
                                              ? Text(
                                                  "${recommendedMenu![index].countRating} ratings",
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                  ),
                                                )
                                              : Text(
                                                  "${recommendedMenu![index].countRating} rating",
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                  ),
                                                ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    color: const Color.fromARGB(20, 0, 0, 0),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            SizedBox(
                                              width: SizeConfig
                                                      .safeBlockHorizontal *
                                                  57,
                                              child: Text(
                                                "${recommendedMenu?[index].foodName}",
                                                style: const TextStyle(
                                                    fontSize: 25),
                                              ),
                                            ),
                                            SizedBox(
                                              width: SizeConfig
                                                      .safeBlockHorizontal *
                                                  3,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.pink[300],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              height: 30,
                                              width: SizeConfig
                                                      .safeBlockHorizontal *
                                                  28,
                                              child: Center(
                                                child: Text(
                                                  recommendedMenu![index]
                                                          .foodPrice
                                                          .contains(".")
                                                      ? recommendedMenu![index]
                                                                      .foodPrice
                                                                      .length -
                                                                  recommendedMenu![
                                                                          index]
                                                                      .foodPrice
                                                                      .indexOf(
                                                                          ".") -
                                                                  1 <
                                                              2
                                                          ? "RM ${recommendedMenu?[index].foodPrice}0"
                                                          : "RM ${recommendedMenu?[index].foodPrice}"
                                                      : "RM ${recommendedMenu?[index].foodPrice}.00",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.pink[50]),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            IconButton(
                                              // constraints: BoxConstraints(),
                                              splashRadius: 20,
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ViewFoodPage(
                                                                fromPage:
                                                                    currentPage,
                                                                foodId: recommendedMenu![
                                                                        index]
                                                                    .foodId)));
                                              },
                                              icon: const Icon(
                                                Icons.remove_red_eye,
                                                size: 20,
                                              ),
                                            ),
                                            IconButton(
                                              // constraints: BoxConstraints(),
                                              splashRadius: 20,
                                              onPressed: () => {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                          title: const Text(
                                                              'Undo Recommend Food'),
                                                          content: const Text(
                                                              'Are you sure you want to remove this food from recommended list?'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () => {
                                                                recommendFood(
                                                                    recommendedMenu?[
                                                                            index]
                                                                        .foodId,
                                                                    0,
                                                                    context)
                                                              },
                                                              child: const Text(
                                                                  'Yes'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  'No'),
                                                            ),
                                                          ],
                                                        ))
                                              },
                                              icon: const Icon(
                                                Icons.recommend,
                                                size: 20,
                                              ),
                                            ),
                                            IconButton(
                                              // constraints: BoxConstraints(),
                                              splashRadius: 20,
                                              onPressed: () => {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                          title: const Text(
                                                              'Archive Food'),
                                                          content: const Text(
                                                              'Are you sure you want to archive this food?'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () => {
                                                                archiveFoodData(
                                                                    recommendedMenu?[
                                                                            index]
                                                                        .foodId,
                                                                    context)
                                                              },
                                                              child: const Text(
                                                                  'Yes'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  'No'),
                                                            ),
                                                          ],
                                                        ))
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                size: 20,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                              ]),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                      ],
                      if (normalMenu!.isNotEmpty) ...[
                        if (recommendedMenu!.isEmpty) ...[
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                        Row(
                          children: [
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              recommendedMenu!.isEmpty
                                  ? "All Food"
                                  : "Other Food",
                              style: GoogleFonts.lobster(
                                textStyle: const TextStyle(fontSize: 25),
                              ),
                            ),
                          ],
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: normalMenu?.length,
                          itemBuilder: (context, index) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 5,
                              child: Column(children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                CachedNetworkImage(
                                  height: 150,
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  imageUrl:
                                      "${ApiConstant.baseUrl}/${normalMenu?[index].foodImgLocation}",
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 10, 0, 0),
                                      child: RatingBarIndicator(
                                        rating: normalMenu![index]
                                            .foodRating
                                            .toDouble(),
                                        itemBuilder: (context, index) =>
                                            const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        itemCount: 5,
                                        itemSize: 25.0,
                                        direction: Axis.horizontal,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          13, 13, 0, 0),
                                      child: normalMenu![index].countRating > 1
                                          ? Text(
                                              "${normalMenu![index].countRating} ratings",
                                              style: const TextStyle(
                                                fontSize: 17,
                                              ),
                                            )
                                          : Text(
                                              "${normalMenu![index].countRating} rating",
                                              style: const TextStyle(
                                                fontSize: 17,
                                              ),
                                            ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    color: const Color.fromARGB(20, 0, 0, 0),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            SizedBox(
                                              width: SizeConfig
                                                      .safeBlockHorizontal *
                                                  57,
                                              child: Text(
                                                "${normalMenu?[index].foodName}",
                                                style: const TextStyle(
                                                    fontSize: 25),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.pink[300],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              height: 30,
                                              width: SizeConfig
                                                      .safeBlockHorizontal *
                                                  28,
                                              child: Center(
                                                child: Text(
                                                  normalMenu![index]
                                                          .foodPrice
                                                          .contains(".")
                                                      ? normalMenu![index]
                                                                      .foodPrice
                                                                      .length -
                                                                  normalMenu![
                                                                          index]
                                                                      .foodPrice
                                                                      .indexOf(
                                                                          ".") -
                                                                  1 <
                                                              2
                                                          ? "RM ${normalMenu?[index].foodPrice}0"
                                                          : "RM ${normalMenu?[index].foodPrice}"
                                                      : "RM ${normalMenu?[index].foodPrice}.00",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.pink[50]),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            IconButton(
                                              // constraints: BoxConstraints(),
                                              splashRadius: 20,
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ViewFoodPage(
                                                                fromPage:
                                                                    currentPage,
                                                                foodId: normalMenu![
                                                                        index]
                                                                    .foodId)));
                                              },
                                              icon: const Icon(
                                                Icons.remove_red_eye,
                                                size: 20,
                                              ),
                                            ),
                                            IconButton(
                                              // constraints: BoxConstraints(),
                                              splashRadius: 20,
                                              onPressed: () => {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                          title: const Text(
                                                              'Recommend Food'),
                                                          content: const Text(
                                                              'Are you sure you want to add this food to recommended list?'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () => {
                                                                recommendFood(
                                                                    normalMenu?[
                                                                            index]
                                                                        .foodId,
                                                                    1,
                                                                    context)
                                                              },
                                                              child: const Text(
                                                                  'Yes'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  'No'),
                                                            ),
                                                          ],
                                                        ))
                                              },
                                              icon: const Icon(
                                                Icons.recommend_outlined,
                                                size: 20,
                                              ),
                                            ),
                                            IconButton(
                                              // constraints: BoxConstraints(),
                                              splashRadius: 20,
                                              onPressed: () => {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                          title: const Text(
                                                              'Archive Food'),
                                                          content: const Text(
                                                              'Are you sure you want to archive this food?'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () => {
                                                                archiveFoodData(
                                                                    normalMenu?[
                                                                            index]
                                                                        .foodId,
                                                                    context)
                                                              },
                                                              child: const Text(
                                                                  'Yes'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  'No'),
                                                            ),
                                                          ],
                                                        ))
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                size: 20,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                              ]),
                            );
                          },
                        ),
                      ],
                    ],
                  ));
  }
}
