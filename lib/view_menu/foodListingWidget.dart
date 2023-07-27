import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_application/api/api_service.dart';
import 'package:food_ordering_application/app_theme.dart';
import 'package:food_ordering_application/model/food_menu_model.dart';
import 'package:food_ordering_application/utilities/sizeConfig.dart';
import 'package:food_ordering_application/widgets/foodList.dart';
import 'package:food_ordering_application/widgets/navBarWidget.dart';

class FoodListingWidget extends StatefulWidget {
  const FoodListingWidget({Key? key}) : super(key: key);

  @override
  _FoodListingWidgetState createState() => _FoodListingWidgetState();
}

class _FoodListingWidgetState extends State<FoodListingWidget> {
  TextEditingController? textController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String currentPage = "foodMenu";
  List<FoodMenuModel>? foodMenu;
  bool isSearchStarted = false;
  bool isLoading = true;

  List<FoodMenuModel> searchedFoods = [];

  @override
  void initState() {
    super.initState();
    getFoodMenu().then((value) => setState(() {
          isLoading = false;
        }));
    textController = TextEditingController();
  }

  Future getFoodMenu() async {
    foodMenu = await ApiService().readFoodMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: NavSideBar(currentPage),
      appBar: AppBar(
        title: const Text(
          'Food Menu',
        ),
        elevation: 0,
        backgroundColor: Colors.blue,
        toolbarHeight: 50,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: const Icon(Icons.more_horiz_rounded),
            onPressed: () => scaffoldKey.currentState?.openDrawer()),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                  child: Container(
                    width: SizeConfig.safeBlockHorizontal * 100,
                    height: SizeConfig.safeBlockVertical * 5,
                    decoration: BoxDecoration(
                      color: AppTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.of(context).primaryBackground,
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(4, 0, 4, 0),
                            child: Icon(
                              Icons.search_rounded,
                              color: Color(0xFF95A1AC),
                              size: 24,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  4, 0, 0, 0),
                              child: TextFormField(
                                controller: textController,
                                obscureText: false,
                                onChanged: (_) => EasyDebounce.debounce(
                                  'tFMemberController',
                                  const Duration(milliseconds: 0),
                                  () {
                                    isSearchStarted = textController!
                                            .text.isNotEmpty &&
                                        textController!.text.trim().length > 0;
                                    if (isSearchStarted) {
                                      searchedFoods = foodMenu!
                                          .where((item) => item.foodName
                                              .toLowerCase()
                                              .contains(textController!.text
                                                  .trim()
                                                  .toLowerCase()))
                                          .toList();
                                    }
                                    setState(() {});
                                  },
                                ),
                                decoration: const InputDecoration(
                                  labelText: 'Search our menu here...',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                  ),
                                ),
                                style: AppTheme.of(context).bodyText1.override(
                                      fontFamily: 'Poppins',
                                      color: const Color(0xFF95A1AC),
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: FoodList(
                    foods: isSearchStarted ? searchedFoods : foodMenu!,
                  ),
                ),
              ],
            ),
    );
  }
}
