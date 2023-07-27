import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_ordering_application/api/api_constant.dart';
import 'package:food_ordering_application/api/api_service.dart';
import 'package:food_ordering_application/app_theme.dart';
import 'package:food_ordering_application/model/cart_model.dart';
import 'package:food_ordering_application/model/status_msg_model.dart';
import 'package:food_ordering_application/user/saveLogin.dart';
import 'package:food_ordering_application/utilities/sizeConfig.dart';
import 'package:food_ordering_application/widgets/count_controller.dart';
import 'package:food_ordering_application/widgets/navBarWidget.dart';

class CheckoutWidget extends StatefulWidget {
  const CheckoutWidget({Key? key}) : super(key: key);

  @override
  _CheckoutWidgetState createState() => _CheckoutWidgetState();
}

class _CheckoutWidgetState extends State<CheckoutWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = true;
  bool noOrder = false;

  List<CartModel>? cart;
  String currentPage = "viewCart";
  List<int> orderQuantity = [];
  double total = 0;
  TextEditingController orderRemark = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCart();
  }

  void calculateTotal() {
    total = 0;
    for (int i = 0; i < cart![0].cartOrders.length; i++) {
      total +=
          orderQuantity[i] * double.parse(cart![0].cartOrders[i].foodPerPrice);
    }
  }

  void getCart() async {
    isLoading = true;
    cart = await ApiService().readCart(SaveLogin().getUsername());
    if (cart != null) {
      for (var element in cart![0].cartOrders) {
        orderQuantity.add(element.foodQuantity);
      }
      calculateTotal();
    }

    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
          if (cart == null) {
            noOrder = true;
          } else {
            noOrder = false;
          }
          isLoading = false;
        }));
  }

  void updateCartLine(int foodId, int increment) async {
    List<StatusMsgModel>? model = await ApiService()
        .updateCartLine(SaveLogin().getCartId(), foodId, increment);
  }

  void deleteFromCart(foodId) async {
    List<StatusMsgModel>? model =
        await ApiService().deleteCartLine(SaveLogin().getCartId(), foodId);

    if (model![0].statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'Successfully Delete from Cart',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      getCart();
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Failed to Delete from Cart',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  void addOrder() async {
    List<StatusMsgModel>? model = await ApiService().addOrder(
      SaveLogin().getUsername(),
      SaveLogin().getCartId(),
      orderRemark.text,
      total,
      total,
    );

    if (model![0].statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'Successfully Add Order',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const CheckoutWidget()));
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Failed to Add Order',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: NavSideBar(currentPage),
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.more_horiz_rounded),
            onPressed: () => scaffoldKey.currentState?.openDrawer()),
        automaticallyImplyLeading: false,
        title: const Text("Order Cart"),
        elevation: 0,
      ),
      backgroundColor: AppTheme.of(context).primaryBackground,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : noOrder
              ? Center(
                  child: Text(
                  "There is no food in the cart right now...",
                  style: AppTheme.of(context).subtitle2,
                ))
              : GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              ListView.builder(
                                padding: EdgeInsets.zero,
                                primary: false,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: cart![0].cartOrders.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16, 8, 16, 0),
                                    child: Container(
                                      width: double.infinity,
                                      height: SizeConfig.safeBlockVertical * 20,
                                      decoration: BoxDecoration(
                                        color: AppTheme.of(context)
                                            .secondaryBackground,
                                        boxShadow: const [
                                          BoxShadow(
                                            blurRadius: 4,
                                            color: Color(0x320E151B),
                                            offset: Offset(0, 1),
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(16, 8, 8, 8),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: SizeConfig
                                                      .safeBlockHorizontal *
                                                  25,
                                              height:
                                                  SizeConfig.safeBlockVertical *
                                                      14,
                                              child: Hero(
                                                tag: 'ControllerImage$index',
                                                transitionOnUserGestures: true,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: CachedNetworkImage(
                                                    placeholder: (context,
                                                            url) =>
                                                        const Center(
                                                            child:
                                                                CircularProgressIndicator()),
                                                    imageUrl:
                                                        "${ApiConstant.baseUrl}/${cart![0].cartOrders[index].foodImgLocation}",
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: SizeConfig
                                                      .safeBlockHorizontal *
                                                  3,
                                            ),
                                            SizedBox(
                                              width: SizeConfig
                                                      .safeBlockHorizontal *
                                                  40,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            0, 0, 0, 8),
                                                    child: Text(
                                                      cart![0]
                                                          .cartOrders[index]
                                                          .foodName,
                                                      style:
                                                          AppTheme.of(context)
                                                              .subtitle2
                                                              .override(
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: AppTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                              ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'Per Price: RM ${double.parse(cart![0].cartOrders[index].foodPerPrice).toStringAsFixed(2)}',
                                                    style: AppTheme.of(context)
                                                        .bodyText2,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        'Quantity: ',
                                                        style:
                                                            AppTheme.of(context)
                                                                .bodyText2,
                                                      ),
                                                      CountController(
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        decrementIconBuilder:
                                                            (enabled) => Icon(
                                                          Icons.remove_rounded,
                                                          color: enabled
                                                              ? AppTheme.of(
                                                                      context)
                                                                  .secondaryText
                                                              : AppTheme.of(
                                                                      context)
                                                                  .secondaryText,
                                                          size: 16,
                                                        ),
                                                        incrementIconBuilder:
                                                            (enabled) => Icon(
                                                          Icons.add_rounded,
                                                          color: enabled
                                                              ? AppTheme.of(
                                                                      context)
                                                                  .primaryColor
                                                              : AppTheme.of(
                                                                      context)
                                                                  .secondaryText,
                                                          size: 16,
                                                        ),
                                                        countBuilder: (count) =>
                                                            Text(
                                                          count.toString(),
                                                          style: AppTheme.of(
                                                                  context)
                                                              .subtitle1,
                                                        ),
                                                        count: orderQuantity[
                                                            index],
                                                        updateCount: (count) =>
                                                            setState(() {
                                                          int increment = 1;
                                                          if (count <
                                                              orderQuantity[
                                                                  index]) {
                                                            increment = -1;
                                                          }
                                                          orderQuantity[index] =
                                                              count;
                                                          calculateTotal();
                                                          updateCartLine(
                                                              cart![0]
                                                                  .cartOrders[
                                                                      index]
                                                                  .foodId,
                                                              increment);
                                                        }),
                                                        stepSize: 1,
                                                        minimum: 1,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'Subtotal: RM ${(double.parse(cart![0].cartOrders[index].foodPerPrice) * orderQuantity[index]).toStringAsFixed(2)}',
                                                    style: AppTheme.of(context)
                                                        .bodyText2,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: IconButton(
                                                icon: const Icon(
                                                  Icons.delete_outline_rounded,
                                                  color: Color(0xFFE86969),
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                            title: const Text(
                                                                'Delete Food from Cart'),
                                                            content: const Text(
                                                                'Are you sure you want to delete this food?'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  deleteFromCart(cart![
                                                                          0]
                                                                      .cartOrders[
                                                                          index]
                                                                      .foodId);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'Yes'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'No'),
                                                              ),
                                                            ],
                                                          ));
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    24, 16, 24, 4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'Order Remark',
                                      style: AppTheme.of(context).bodyText2,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.screenWidth - 30,
                                child: TextFormField(
                                  maxLines: 5,
                                  controller: orderRemark,
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
                                              BorderRadius.circular(10.0))),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    24, 4, 24, 24),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          'Total',
                                          style: AppTheme.of(context).subtitle2,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'RM ${total.toStringAsFixed(2)}',
                                      style: AppTheme.of(context).title1,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    24, 16, 24, 4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    SizedBox(
                                      width:
                                          SizeConfig.safeBlockHorizontal * 87,
                                      child: Text(
                                        'Please make payment at counter when food is ready',
                                        style: AppTheme.of(context).bodyText2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: SizeConfig.safeBlockVertical * 10,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0x320E151B),
                              offset: Offset(0, -2),
                            )
                          ],
                        ),
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: const Text('Add Order'),
                                      content: const Text(
                                          'Are you sure you want to add this order?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            addOrder();
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
                          child: Text(
                            'Confirm Order',
                            style: AppTheme.of(context).title2.override(
                                  fontFamily: 'Poppins',
                                  color: AppTheme.of(context).primaryBtnText,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
