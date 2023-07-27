import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_ordering_application/api/api_constant.dart';
import 'package:food_ordering_application/api/api_service.dart';
import 'package:food_ordering_application/app_theme.dart';
import 'package:food_ordering_application/model/food_detail_model.dart';
import 'package:food_ordering_application/model/status_msg_model.dart';
import 'package:food_ordering_application/user/saveLogin.dart';
import 'package:food_ordering_application/utilities/sizeConfig.dart';
import 'package:food_ordering_application/view_menu/giveRating.dart';
import 'package:food_ordering_application/widgets/button.dart';
import 'package:food_ordering_application/widgets/count_controller.dart';

class FoodDetailWidget extends StatefulWidget {
  const FoodDetailWidget({Key? key, required this.foodId}) : super(key: key);

  final int foodId;

  @override
  _FoodDetailWidgetState createState() => _FoodDetailWidgetState();
}

class _FoodDetailWidgetState extends State<FoodDetailWidget>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = true;
  bool isRated = false;
  bool isAdded = false;
  int foodRating = 0;
  List<FoodDetailModel>? food;
  int? countControllerValue;

  @override
  void initState() {
    super.initState();
    getFoodDetail()
        .then((value) => retrieveRating().then((value) => setState(() {
              isLoading = false;
            })));
  }

  Future getFoodDetail() async {
    food = await ApiService().readFoodDetail(widget.foodId);
  }

  Future retrieveRating() async {
    int data = (await ApiService()
        .retrieveRating(SaveLogin().getUsername(), widget.foodId))!;

    setState(() {
      if (data == -1) {
        isRated = false;
      } else {
        isRated = true;
        foodRating = data;
      }
    });
  }

  Future addToCart() async {
    List<StatusMsgModel>? model = await (ApiService().addCartLine(
        SaveLogin().getCartId(), widget.foodId, countControllerValue));

    if (model![0].statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'Successfully Add to Cart',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Failed to Add to Cart',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () async {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_rounded,
            color: AppTheme.of(context).secondaryText,
            size: 24,
          ),
        ),
        title: isLoading
            ? const Text("")
            : Text(
                ' ${food![0].foodName}',
                style: AppTheme.of(context).subtitle2.override(
                      fontFamily: 'Lexend Deca',
                      color: const Color(0xFF151B1E),
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                    ),
              ),
        elevation: 0,
      ),
      backgroundColor: AppTheme.of(context).secondaryBackground,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16, 16, 16, 16),
                          child: Hero(
                            tag: 'mainImage',
                            transitionOnUserGestures: true,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                height: SizeConfig.screenHeight / 10 * 3,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                imageUrl:
                                    "${ApiConstant.baseUrl}/${food![0].foodImgLocation}",
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16, 0, 16, 0),
                          child: Text(
                            'Food Detail',
                            style: AppTheme.of(context).title1,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(16, 4, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Ratings: ',
                                textAlign: TextAlign.start,
                                style: AppTheme.of(context).subtitle1,
                              ),
                              RatingBarIndicator(
                                rating: food![0].foodRating.toDouble(),
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 25.0,
                                direction: Axis.horizontal,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              food![0].countRating > 1
                                  ? Text(
                                      "${food![0].countRating} ratings",
                                      style: const TextStyle(
                                        fontSize: 17,
                                      ),
                                    )
                                  : Text(
                                      "${food![0].countRating} rating",
                                      style: const TextStyle(
                                        fontSize: 17,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(16, 4, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Your Rating: ',
                                textAlign: TextAlign.start,
                                style: AppTheme.of(context).subtitle1,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditRating(
                                          rating: foodRating.toDouble(),
                                          foodId: widget.foodId,
                                          foodName: food![0].foodName,
                                          imageUrl: food![0].foodImgLocation),
                                    ),
                                  );
                                },
                                child: RatingBarIndicator(
                                  rating: foodRating.toDouble(),
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 25.0,
                                  direction: Axis.horizontal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(16, 4, 0, 0),
                          child: Text(
                            'Price: RM ${double.parse(food![0].foodPrice).toStringAsFixed(2)}',
                            textAlign: TextAlign.start,
                            style: AppTheme.of(context).subtitle1,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(16, 4, 0, 0),
                          child: Text(
                            'Description:',
                            textAlign: TextAlign.start,
                            style: AppTheme.of(context).subtitle1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16, 8, 16, 8),
                          child: Text(
                            food![0].foodDesc,
                            style: AppTheme.of(context).bodyText2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: SizeConfig.safeBlockHorizontal * 25,
                    decoration: BoxDecoration(
                      color: AppTheme.of(context).primaryBackground,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4,
                          color: Color(0x320F1113),
                          offset: Offset(0, -2),
                        )
                      ],
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 34),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: SizeConfig.safeBlockHorizontal * 40,
                            height: SizeConfig.safeBlockHorizontal * 10,
                            decoration: BoxDecoration(
                              color: AppTheme.of(context).secondaryBackground,
                              borderRadius: BorderRadius.circular(12),
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: AppTheme.of(context).primaryBackground,
                                width: 2,
                              ),
                            ),
                            child: CountController(
                              decrementIconBuilder: (enabled) => Icon(
                                Icons.remove_rounded,
                                color: enabled
                                    ? AppTheme.of(context).secondaryText
                                    : AppTheme.of(context).secondaryText,
                                size: 16,
                              ),
                              incrementIconBuilder: (enabled) => Icon(
                                Icons.add_rounded,
                                color: enabled
                                    ? AppTheme.of(context).primaryColor
                                    : AppTheme.of(context).secondaryText,
                                size: 16,
                              ),
                              countBuilder: (count) => Text(
                                count.toString(),
                                style: AppTheme.of(context).subtitle1,
                              ),
                              count: countControllerValue ??= 1,
                              updateCount: (count) =>
                                  setState(() => countControllerValue = count),
                              stepSize: 1,
                              minimum: 1,
                            ),
                          ),
                          MyButtonWidget(
                            onPressed: () {
                              addToCart();
                            },
                            text: 'Add to Cart',
                            options: ButtonOptions(
                                width: SizeConfig.safeBlockHorizontal * 40,
                                height: SizeConfig.safeBlockVertical * 5,
                                color: Colors.blue,
                                textStyle:
                                    AppTheme.of(context).subtitle2.override(
                                          fontFamily: 'Poppins',
                                          color: Colors.white,
                                        ),
                                elevation: 5,
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(36))),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
