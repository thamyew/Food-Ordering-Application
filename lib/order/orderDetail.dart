import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_ordering_application/api/api_service.dart';
import 'package:food_ordering_application/model/order_model.dart';
import 'package:food_ordering_application/model/status_msg_model.dart';
import 'package:food_ordering_application/order/giveFeedback.dart';
import 'package:food_ordering_application/order/giveReason.dart';
import 'package:food_ordering_application/user/saveLogin.dart';
import 'package:food_ordering_application/utilities/sizeConfig.dart';
import 'package:intl/intl.dart';

class OrderDetail extends StatefulWidget {
  final int orderId;
  final String fromPage;

  const OrderDetail({super.key, required this.orderId, required this.fromPage});
  @override
  _OrderDetail createState() => _OrderDetail();
}

class _OrderDetail extends State<OrderDetail> {
  List<OrderModel>? order;
  bool isLoading = true;
  int orderStatusCode = 0;

  @override
  void initState() {
    super.initState();
    getOrderDetail().then((value) => setState(() {
          orderStatusCode = order![0].orderStatus;
          isLoading = false;
        }));
  }

  Future getOrderDetail() async {
    order = await ApiService().readOrderInfo(widget.orderId);
  }

  void acceptOrder() async {
    List<StatusMsgModel>? model =
        await (ApiService().acceptOrder(widget.orderId));

    if (model![0].statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'Successfully Accept Order',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      Navigator.pop(context);
      Navigator.pop(context);
      // Navigator.push(context, MaterialPageRoute(builder: ((context) => )); // When Order List Done
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Failed to Accept Order',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  void readyToPickup() async {
    List<StatusMsgModel>? model =
        await (ApiService().updateOrderStatus(widget.orderId));

    if (model![0].statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'Successfully Update Order Status',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      Navigator.pop(context);
      Navigator.pop(context);
      // Navigator.push(context, MaterialPageRoute(builder: ((context) => )); // When Order List Done
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Failed to Update Order Status',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  void markComplete() async {
    List<StatusMsgModel>? model =
        await (ApiService().completeOrder(widget.orderId));

    if (model![0].statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'Successfully Update Order Status',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      Navigator.pop(context);
      Navigator.pop(context);
      // Navigator.push(context, MaterialPageRoute(builder: ((context) => )); // When Order List Done
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Failed to Update Order Status',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.blue,
        title: Text(
          "Order ${widget.orderId}: Order Details",
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: SizeConfig.safeBlockHorizontal * 38,
                        child: const Text(
                          "Customer Username",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.safeBlockHorizontal * 5,
                        child: const Text(
                          ":",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Text(
                        order![0].orderCustomerUsername,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: SizeConfig.safeBlockHorizontal * 38,
                        child: const Text(
                          "Order Date",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.safeBlockHorizontal * 5,
                        child: const Text(
                          ":",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Text(
                        DateFormat('yyyy-MM-dd')
                            .format(DateTime.parse(order![0].orderDateTime)),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: SizeConfig.safeBlockHorizontal * 38,
                        child: const Text(
                          "Order Time",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.safeBlockHorizontal * 5,
                        child: const Text(
                          ":",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Text(
                        DateFormat('h:mm a')
                            .format(DateTime.parse(order![0].orderDateTime)),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: SizeConfig.safeBlockHorizontal * 38,
                        child: const Text(
                          "Order List:",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: SizeConfig.safeBlockHorizontal * 97,
                  child: ListTile(
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "No",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          width: SizeConfig.safeBlockHorizontal * 2,
                        ),
                        const Text(
                          "Food Name",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    //ListTile
                    tileColor: const Color.fromARGB(255, 139, 168, 236),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: SizeConfig.safeBlockHorizontal * 20,
                          child: const Text(
                            "Quantity",
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.safeBlockHorizontal * 20,
                          child: const Text(
                            "Price (RM)",
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: SizeConfig.safeBlockHorizontal * 98,
                  child: SizedBox(
                    height: order![0].orders.length < 4
                        ? 40 * (1 + order![0].orders.length.toDouble())
                        : 160,
                    child: ListView.builder(
                      itemCount: order?[0].orders.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: SizeConfig.screenWidth > 500
                                      ? SizeConfig.safeBlockHorizontal * 5
                                      : SizeConfig.safeBlockHorizontal * 7,
                                  child: Text(
                                    " ${index + 1}",
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                SizedBox(
                                  width: SizeConfig.screenWidth > 500
                                      ? SizeConfig.safeBlockHorizontal * 47.5
                                      : SizeConfig.safeBlockHorizontal * 40,
                                  child: Text(order![0].orders[index].foodName),
                                ),
                                SizedBox(
                                  width: SizeConfig.safeBlockHorizontal * 20,
                                  child: Text(
                                    order![0]
                                        .orders[index]
                                        .foodQuantity
                                        .toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  width: SizeConfig.safeBlockHorizontal * 20,
                                  child: Text(
                                    (double.parse(order![0]
                                                .orders[index]
                                                .foodPerPrice) *
                                            order![0]
                                                .orders[index]
                                                .foodQuantity)
                                        .toStringAsFixed(2),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            tileColor: const Color.fromARGB(
                                255, 207, 214, 230), //ListTile

                            //subtitle: Text("subtitle"), //ListTile副标题
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: SizeConfig.safeBlockHorizontal * 38,
                        child: const Text(
                          "Subtotal Price",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.safeBlockHorizontal * 5,
                        child: const Text(
                          ":",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Text(
                        "RM ${double.parse(order![0].orderSubtotal).toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: SizeConfig.safeBlockHorizontal * 38,
                        child: const Text(
                          "Total Price",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.safeBlockHorizontal * 5,
                        child: const Text(
                          ":",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Text(
                        "RM ${double.parse(order![0].orderTotal).toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: SizeConfig.safeBlockHorizontal * 38,
                        child: const Text(
                          "Order Status",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.safeBlockHorizontal * 5,
                        child: const Text(
                          ":",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color:
                                orderStatusCode < 4 ? Colors.green : Colors.red,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.all(7),
                          child: Text(
                            orderStatusCode == 0
                                ? "Submitted"
                                : orderStatusCode == 1
                                    ? "In Preparing"
                                    : orderStatusCode == 2
                                        ? "Ready to Pickup"
                                        : orderStatusCode == 3
                                            ? "Completed"
                                            : orderStatusCode == 4
                                                ? "Cancelled"
                                                : "Rejected",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: SizeConfig.safeBlockHorizontal * 38,
                        child: const Text(
                          "Remark",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.safeBlockHorizontal * 5,
                        child: const Text(
                          ":",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.safeBlockHorizontal * 45,
                        child: Text(
                          order![0].orderRemark,
                          style: const TextStyle(fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                orderStatusCode >= 3
                    ? Column(children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: SizeConfig.safeBlockHorizontal * 38,
                                child: const Text(
                                  "Archive Expiry Date",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.safeBlockHorizontal * 5,
                                child: const Text(
                                  ":",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.safeBlockHorizontal * 45,
                                child: Text(
                                  DateFormat('yyyy-MM-dd').format(
                                      DateTime.parse(
                                          order![0].orderArchivedExpiryDate)),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: SizeConfig.safeBlockHorizontal * 38,
                                child: const Text(
                                  "Feedback",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.safeBlockHorizontal * 5,
                                child: const Text(
                                  ":",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.safeBlockHorizontal * 45,
                                child: Text(
                                  order![0].orderFeedback != "-1"
                                      ? order![0].orderFeedback
                                      : "",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        ),
                      ])
                    : const SizedBox(
                        height: 15,
                      ),
                SaveLogin().getLevel() == 0
                    ? orderStatusCode == 0
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                                Expanded(
                                  child: Align(
                                    alignment: FractionalOffset.bottomCenter,
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  color: Colors.red),
                                              borderRadius:
                                                  BorderRadius.circular(30.0))),
                                      onPressed: () => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditReason(
                                                        orderId: widget.orderId,
                                                        fromPage:
                                                            widget.fromPage))),
                                      },
                                      child: const Text("Reject Order"),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: FractionalOffset.bottomCenter,
                                    child: OutlinedButton(
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
                                            title: const Text('Accept Order'),
                                            content: const Text(
                                                'Are you sure you want to accept this order?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => {
                                                  acceptOrder(),
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
                                          ),
                                        ),
                                      },
                                      child: const Text("Accept Order"),
                                    ),
                                  ),
                                ),
                              ])
                        : orderStatusCode == 1
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                    Expanded(
                                      child: Align(
                                        alignment:
                                            FractionalOffset.bottomCenter,
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                              foregroundColor: Colors.green,
                                              shape: RoundedRectangleBorder(
                                                  side: const BorderSide(
                                                      color: Colors.green),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0))),
                                          onPressed: () => {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text(
                                                    'Ready to Pickup'),
                                                content: const Text(
                                                    'Are you sure you want to switch this order to ready to pickup?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => {
                                                      readyToPickup(),
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
                                              ),
                                            ),
                                          },
                                          child: const Text(
                                              "Switch to Ready to Pickup"),
                                        ),
                                      ),
                                    ),
                                  ])
                            : orderStatusCode == 2
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                        Expanded(
                                          child: Align(
                                            alignment:
                                                FractionalOffset.bottomCenter,
                                            child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                  foregroundColor: Colors.green,
                                                  shape: RoundedRectangleBorder(
                                                      side: const BorderSide(
                                                          color: Colors.green),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0))),
                                              onPressed: () => {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    title: const Text(
                                                        'Mark as Completed'),
                                                    content: const Text(
                                                        'Are you sure you want to mark this order as completed?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () => {
                                                          markComplete(),
                                                        },
                                                        child:
                                                            const Text('Yes'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text('No'),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              },
                                              child: const Text(
                                                  "Mark as Completed"),
                                            ),
                                          ),
                                        ),
                                      ])
                                : const SizedBox(
                                    height: 10,
                                  )
                    : orderStatusCode == 0
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                                Expanded(
                                  child: Align(
                                    alignment: FractionalOffset.bottomCenter,
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  color: Colors.red),
                                              borderRadius:
                                                  BorderRadius.circular(30.0))),
                                      onPressed: () => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditReason(
                                                        orderId: widget.orderId,
                                                        fromPage:
                                                            widget.fromPage))),
                                      },
                                      child: const Text("Cancel Order"),
                                    ),
                                  ),
                                ),
                              ])
                        : orderStatusCode == 3 &&
                                order![0].orderFeedback == "-1"
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                    const SizedBox(
                                      height: 15,
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
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditFeedback(
                                                      orderId: widget.orderId,
                                                      fromPage: widget.fromPage,
                                                    )))
                                      },
                                      child: const Text("Submit Feedback"),
                                    ),
                                  ])
                            : const SizedBox(
                                height: 10,
                              ),
              ]),
            ),
    );
  }
}
