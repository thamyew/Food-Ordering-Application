import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_ordering_application/api/api_service.dart';
import 'package:food_ordering_application/model/status_msg_model.dart';
import 'package:food_ordering_application/order/orderDetail.dart';
import 'package:food_ordering_application/utilities/sizeConfig.dart';

class EditFeedback extends StatefulWidget {
  final int orderId;
  final String fromPage;
  const EditFeedback({
    Key? key,
    required this.orderId,
    required this.fromPage,
  }) : super(key: key);

  @override
  EditFeedbackState createState() => EditFeedbackState();
}

class EditFeedbackState extends State<EditFeedback> {
  TextEditingController feedback = TextEditingController();

  void addFeedback() async {
    List<StatusMsgModel>? model =
        await (ApiService().addFeedback(widget.orderId, feedback.text));

    if (model![0].statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'Successfully Add Feedback',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
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
        msg: 'Failed to Add Feedback',
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
            "Feedback Order ID ${widget.orderId}",
          ),
          elevation: 0,
          toolbarHeight: 50,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Please Leave Us Your Feedback:",
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
                    return 'Please enter the feedback.';
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
                          addFeedback();
                        },
                        child: const Text(
                          'Submit',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    )))
          ],
        ));
  }
}
