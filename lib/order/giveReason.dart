import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_ordering_application/api/api_service.dart';
import 'package:food_ordering_application/model/status_msg_model.dart';
import 'package:food_ordering_application/order/orderDetail.dart';
import 'package:food_ordering_application/user/saveLogin.dart';
import 'package:food_ordering_application/utilities/sizeConfig.dart';

class EditReason extends StatefulWidget {
  final int orderId;
  final String fromPage;
  const EditReason({
    Key? key,
    required this.orderId,
    required this.fromPage,
  }) : super(key: key);

  @override
  EditReasonState createState() => EditReasonState();
}

class EditReasonState extends State<EditReason> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController feedback = TextEditingController();

  void cancelOrder() async {
    List<StatusMsgModel>? model1 =
        await (ApiService().cancelOrder(widget.orderId));

    if (model1![0].statusCode == 200) {
      List<StatusMsgModel>? model =
          await ApiService().addFeedback(widget.orderId, feedback.text);
      Fluttertoast.showToast(
        msg: 'Successfully Cancel Order',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderDetail(
                    orderId: widget.orderId,
                    fromPage: widget.fromPage,
                  )));
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Failed to Cancel Order',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  void rejectOrder() async {
    List<StatusMsgModel>? model1 =
        await (ApiService().rejectOrder(widget.orderId));

    if (model1![0].statusCode == 200) {
      List<StatusMsgModel>? model =
          await ApiService().addFeedback(widget.orderId, feedback.text);
      Fluttertoast.showToast(
        msg: 'Successfully Reject Order',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderDetail(
                    orderId: widget.orderId,
                    fromPage: widget.fromPage,
                  )));
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Failed to Reject Order',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            SaveLogin().getLevel() == 0
                ? "Reject Order ID ${widget.orderId}"
                : "Cancel Order ID ${widget.orderId}",
          ),
          elevation: 0,
          toolbarHeight: 50,
        ),
        body: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Please Leave the Reason:",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: SizeConfig.safeBlockHorizontal * 90,
                  child: TextFormField(
                    maxLines: 10,
                    controller: feedback,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the reason.';
                      }
                      return null;
                    },
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(200),
                    ],
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0))),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: SizeConfig.safeBlockHorizontal * 80,
                          height: SizeConfig.safeBlockVertical * 5,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: SaveLogin().getLevel() == 0
                                        ? const Text('Reject Order')
                                        : const Text('Cancel Order'),
                                    content: SaveLogin().getLevel() == 0
                                        ? const Text(
                                            'Are you sure you want to reject this order?')
                                        : const Text(
                                            'Are you sure you want to cancel this order?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => {
                                          SaveLogin().getLevel() == 0
                                              ? rejectOrder()
                                              : cancelOrder()
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
                                );
                              }
                            },
                            child: const Text(
                              'Submit',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        )))
              ],
            )));
  }
}
