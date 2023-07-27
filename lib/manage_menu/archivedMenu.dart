import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_ordering_application/api/api_service.dart';
import 'package:food_ordering_application/app_theme.dart';
import 'package:food_ordering_application/manage_menu/viewFoodDetail.dart';
import 'package:food_ordering_application/utilities/sizeConfig.dart';
import 'package:food_ordering_application/widgets/navBarWidget.dart';

import '../model/archived_food_menu_model.dart';

class ArchivedMenu extends StatefulWidget {
  const ArchivedMenu({Key? key}) : super(key: key);

  @override
  _ArchivedMenuState createState() => _ArchivedMenuState();
}

class _ArchivedMenuState extends State<ArchivedMenu> {
  String currentPage = "archiveMenu";
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  List<ArchivedFoodMenuModel>? menu;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getArchivedMenuData().then((value) => setState(() {
          _isLoading = false;
        }));
  }

  Future getArchivedMenuData() async {
    menu = (await (ApiService().readArchivedFoodMenu()));
  }

  void viewFoodDetail(foodId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ViewFoodPage(fromPage: currentPage, foodId: foodId)));
  }

  Future restoreFoodData(foodId) async {
    int response = await (ApiService().restoreArchivedFood(foodId));

    if (response != 404) {
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
          builder: (context) => const ArchivedMenu(),
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

  Future deleteFoodData(foodId) async {
    int response = await (ApiService().deleteFood(foodId));

    if (response != 404) {
      Fluttertoast.showToast(
        msg: 'Successfully Delete Food',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ArchivedMenu(),
        ),
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

  Future restoreAllFood() async {
    int response = await (ApiService().restoreAllArchivedFood());

    if (response != 404) {
      Fluttertoast.showToast(
        msg: 'Successfully Restore All Food',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ArchivedMenu(),
        ),
      );
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Failed to Restore All Food',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  Future deleteAllFood() async {
    int response = await (ApiService().deleteAllFood());

    if (response != 404) {
      Fluttertoast.showToast(
        msg: 'Successfully Delete All Food',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ArchivedMenu(),
        ),
      );
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Failed to Delete All Food',
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
          title: const Text("Arhicved Menu"),
          backgroundColor: Colors.blue,
          elevation: 0,
          toolbarHeight: 50,
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: const Icon(Icons.more_horiz_rounded),
              onPressed: () => _key.currentState?.openDrawer()),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : menu == null
                ? Center(
                    child: Text("There is no food archived right now...",
                        textAlign: TextAlign.center,
                        style: AppTheme.of(context).subtitle2),
                  )
                : Padding(
                    //内边距
                    padding: const EdgeInsets.all(10), //内边距为10
                    child: Column(mainAxisSize: MainAxisSize.min, children: <
                        Widget>[
                      SizedBox(
                        width: SizeConfig.safeBlockHorizontal * 100,
                        child: const ListTile(
                          //ListTile
                          title: Text("Food Name"), //ListTile
                          tileColor: Color.fromARGB(255, 139, 168, 236),
                          trailing: Text("Actions            ",
                              style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 70,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: menu?.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Text(menu![index].foodName),
                                tileColor: const Color.fromARGB(
                                    255, 207, 214, 230), //ListTile
                                //subtitle: Text("subtitle"), //ListTile副标题
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      // constraints: BoxConstraints(),
                                      splashRadius: 20,
                                      onPressed: () =>
                                          {viewFoodDetail(menu![index].foodId)},
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
                                            builder: (context) => AlertDialog(
                                                  title: const Text(
                                                      'Restore Food'),
                                                  content: const Text(
                                                      'Are you sure you want to restore this food?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        restoreFoodData(
                                                            menu![index]
                                                                .foodId);
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
                                                ))
                                      },
                                      icon: const Icon(
                                        Icons.restore,
                                        size: 20,
                                      ),
                                    ),
                                    IconButton(
                                      // constraints: BoxConstraints(),
                                      splashRadius: 20,
                                      onPressed: () => {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title:
                                                      const Text('Delete Food'),
                                                  content: const Text(
                                                      'Are you sure you want to delete this food?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        deleteFoodData(
                                                            menu?[index]
                                                                .foodId);
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
                                                ))
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ), //ListTile右边图表
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 2,
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Expanded(
                          child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                      side:
                                          const BorderSide(color: Colors.green),
                                      borderRadius:
                                          BorderRadius.circular(30.0))),
                              onPressed: () => {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title:
                                        const Text('Restore All Archived Food'),
                                    content: const Text(
                                        'Are you sure you want to restore all archived food?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => setState(() {
                                          Navigator.pop(context);
                                          restoreAllFood();
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
                              child: const Text("Restore All"),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                      side: const BorderSide(color: Colors.red),
                                      borderRadius:
                                          BorderRadius.circular(30.0))),
                              onPressed: () => {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title:
                                        const Text('Delete All Archived Food'),
                                    content: const Text(
                                        'Are you sure you want to delete all archived food?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => setState(() {
                                          Navigator.pop(context);
                                          deleteAllFood();
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
                              child: const Text("Delete All"),
                            ),
                          ),
                        ),
                      ]),
                    ]),
                  ));
  }
}


// child: ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: 30,
//                       itemBuilder: (context, index) {
//                         return ListTile(
//                           title: Text(menu![0].foodName),
//                           tileColor:
//                               Color.fromARGB(255, 207, 214, 230), //ListTile
//                           //subtitle: Text("subtitle"), //ListTile副标题
//                           trailing: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               IconButton(
//                                 // constraints: BoxConstraints(),
//                                 splashRadius: 20,
//                                 onPressed: () => {},
//                                 icon: Icon(
//                                   Icons.remove_red_eye,
//                                   size: 20,
//                                 ),
//                               ),
//                               IconButton(
//                                 // constraints: BoxConstraints(),
//                                 splashRadius: 20,
//                                 onPressed: () => {
//                                   showDialog(
//                                       context: context,
//                                       builder: (context) => AlertDialog(
//                                             title: Text('Restore Food'),
//                                             content: Text(
//                                                 'Are you sure you want to restore this food?'),
//                                             actions: [
//                                               TextButton(
//                                                 onPressed: () {
//                                                   restoreFoodData(
//                                                       menu![index].foodId);
//                                                 },
//                                                 child: Text('Yes'),
//                                               ),
//                                               TextButton(
//                                                 onPressed: () {
//                                                   Navigator.pop(context);
//                                                 },
//                                                 child: Text('No'),
//                                               ),
//                                             ],
//                                           ))
//                                 },
//                                 icon: Icon(
//                                   Icons.restore,
//                                   size: 20,
//                                 ),
//                               ),
//                               IconButton(
//                                 // constraints: BoxConstraints(),
//                                 splashRadius: 20,
//                                 onPressed: () => {
//                                   showDialog(
//                                       context: context,
//                                       builder: (context) => AlertDialog(
//                                             title: Text('Delete Food'),
//                                             content: Text(
//                                                 'Are you sure you want to delete this food?'),
//                                             actions: [
//                                               TextButton(
//                                                 onPressed: () {
//                                                   deleteFoodData(
//                                                       menu![index].foodId);
//                                                 },
//                                                 child: Text('Yes'),
//                                               ),
//                                               TextButton(
//                                                 onPressed: () {
//                                                   Navigator.pop(context);
//                                                 },
//                                                 child: Text('No'),
//                                               ),
//                                             ],
//                                           ))
//                                 },
//                                 icon: Icon(
//                                   Icons.delete,
//                                   size: 20,
//                                 ),
//                               ),
//                             ],
//                           ), //ListTile右边图表
//                         );
//                       },
//                     ),