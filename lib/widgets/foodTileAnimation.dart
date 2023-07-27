import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_ordering_application/api/api_constant.dart';
import 'package:food_ordering_application/model/food_menu_model.dart';
import 'package:food_ordering_application/view_menu/foodDetailWidget.dart';

import '../app_theme.dart';

class FoodTileAnimation extends StatelessWidget {
  final int itemNo;
  final FoodMenuModel food;

  const FoodTileAnimation({this.itemNo = 0, required this.food});

  @override
  Widget build(BuildContext context) {
    ContainerTransitionType transitionType = ContainerTransitionType.fade;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OpenContainer<bool>(
        transitionType: transitionType,
        openBuilder: (BuildContext _, VoidCallback openContainer) {
          return FoodDetailWidget(
            foodId: food.foodId,
          );
        },
        closedShape: const RoundedRectangleBorder(),
        closedElevation: 0.0,
        closedBuilder: (BuildContext _, VoidCallback openContainer) {
          return Container(
            decoration: BoxDecoration(
              color: AppTheme.of(context).secondaryBackground,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 4,
                  color: Color(0x3600000F),
                  offset: Offset(0, 2),
                )
              ],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                          child: CachedNetworkImage(
                            height: 100,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            imageUrl:
                                "${ApiConstant.baseUrl}/${food.foodImgLocation}",
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(8, 4, 0, 0),
                          child: Text(
                            food.foodName,
                            style: AppTheme.of(context).bodyText1,
                          ),
                        ),
                        if (food.foodRecommend == 1) ...[
                          Expanded(
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                child: Icon(
                                  Icons.recommend,
                                  color: Colors.yellow[600],
                                ),
                              ),
                            ),
                          )
                        ],
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 2, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(8, 4, 0, 0),
                          child: Text(
                            'RM ${double.parse(food.foodPrice).toStringAsFixed(2)}',
                            style: AppTheme.of(context).bodyText2,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 3, 5, 0),
                              child: RatingBarIndicator(
                                rating: food.foodRating.toDouble(),
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 15.0,
                                direction: Axis.horizontal,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
