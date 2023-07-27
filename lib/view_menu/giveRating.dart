import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_ordering_application/api/api_constant.dart';
import 'package:food_ordering_application/api/api_service.dart';
import 'package:food_ordering_application/app_theme.dart';
import 'package:food_ordering_application/model/status_msg_model.dart';
import 'package:food_ordering_application/user/saveLogin.dart';
import 'package:food_ordering_application/utilities/sizeConfig.dart';
import 'package:food_ordering_application/view_menu/foodListingWidget.dart';
import 'package:food_ordering_application/widgets/button.dart';

class EditRating extends StatefulWidget {
  final String foodName;
  final String imageUrl;
  final int foodId;
  final double rating;
  const EditRating(
      {Key? key,
      required this.rating,
      required this.foodId,
      required this.foodName,
      required this.imageUrl})
      : super(key: key);

  @override
  EditRatingState createState() => EditRatingState();
}

class EditRatingState extends State<EditRating> {
  bool rated = false;
  double finalRating = 3;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    if (widget.rating != 0) {
      rated = true;
      finalRating = widget.rating;
    }
  }

  void feedbackAction(List<StatusMsgModel>? data) {
    if (data![0].statusCode == 200) {
      Fluttertoast.showToast(
        msg: rated ? 'Successfully Update Rating' : 'Successfully Add Rating',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const FoodListingWidget()));
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: rated ? 'Failed to Update Rating' : 'Failed to Add Rating',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  Future addRating() async {
    List<StatusMsgModel>? data = await ApiService()
        .addRating(SaveLogin().getUsername(), widget.foodId, finalRating);

    feedbackAction(data);
  }

  Future updateRating() async {
    List<StatusMsgModel>? data = await ApiService()
        .updateRating(SaveLogin().getUsername(), widget.foodId, finalRating);

    feedbackAction(data);
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
        title: Text(
          widget.foodName,
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
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                    child: Hero(
                      tag: 'mainImage',
                      transitionOnUserGestures: true,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          height: SizeConfig.screenHeight / 6 * 2,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          imageUrl: "${ApiConstant.baseUrl}/${widget.imageUrl}",
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                    child: Text(
                      'Please Leave Us Your Rating',
                      style: AppTheme.of(context).title1,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Your Rating: ',
                          textAlign: TextAlign.start,
                          style: AppTheme.of(context).subtitle1,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RatingBar.builder(
                          initialRating: rated ? widget.rating : 3,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemSize: 50,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            finalRating = rating;
                          },
                        ),
                      ],
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
              height: SizeConfig.safeBlockVertical * 13,
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
                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 34),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyButtonWidget(
                      onPressed: () {
                        rated ? updateRating() : addRating();
                      },
                      text: 'Submit Rating',
                      options: ButtonOptions(
                          width: SizeConfig.safeBlockHorizontal * 40,
                          height: SizeConfig.safeBlockVertical * 6,
                          color: Colors.blue,
                          textStyle: AppTheme.of(context).subtitle2.override(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                              ),
                          elevation: 1,
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(36))),
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
