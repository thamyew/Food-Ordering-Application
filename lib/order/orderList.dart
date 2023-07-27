import 'package:flutter/material.dart';
import 'package:food_ordering_application/api/api_service.dart';
import 'package:food_ordering_application/app_theme.dart';
import 'package:food_ordering_application/model/order_list_model.dart';
import 'package:food_ordering_application/order/orderDetail.dart';
import 'package:food_ordering_application/user/saveLogin.dart';
import 'package:food_ordering_application/utilities/sizeConfig.dart';
import 'package:food_ordering_application/widgets/navBarWidget.dart';

class OrderList extends StatefulWidget {
  final String currentPage;
  const OrderList({Key? key, required this.currentPage}) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  List<OrderListModel>? orders;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getOrderData().then((value) => setState(() {
          _isLoading = false;
        }));
  }

  Future getOrderData() async {
    _isLoading = true;
    widget.currentPage == "orderList"
        ? orders = (await (ApiService()
            .readOrderList(SaveLogin().getUsername(), SaveLogin().getLevel())))
        : orders = (await (ApiService().readArchivedOrderList(
            SaveLogin().getUsername(), SaveLogin().getLevel())));
  }

  void viewOrderDetail(context, orderId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderDetail(
                  orderId: orderId,
                  fromPage: widget.currentPage,
                ))).then((_) {
      getOrderData().then((value) => setState(() {
            _isLoading = false;
          }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: NavSideBar(widget.currentPage),
      appBar: AppBar(
        title: widget.currentPage == "orderList"
            ? const Text("Current Orders")
            : const Text("Archived Orders"),
        backgroundColor: Colors.blue,
        elevation: 0,
        toolbarHeight: 50,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: const Icon(Icons.more_horiz_rounded),
            onPressed: () => _key.currentState?.openDrawer()),
        actions: [
          IconButton(
              icon: const Icon(Icons.autorenew_rounded),
              onPressed: () => {
                    getOrderData().then((value) => setState(() {
                          _isLoading = false;
                        })),
                  }),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : orders == null
              ? Center(
                  child: SaveLogin().getLevel() == 0
                      ? widget.currentPage == "orderList"
                          ? SizedBox(
                              width: SizeConfig.screenWidth - 10,
                              child: Text(
                                  "There is no ongoing orders at the moment.",
                                  textAlign: TextAlign.center,
                                  style: AppTheme.of(context).subtitle2),
                            )
                          : SizedBox(
                              width: SizeConfig.screenWidth - 10,
                              child: Text(
                                  "There is no order history at the moment.",
                                  textAlign: TextAlign.center,
                                  style: AppTheme.of(context).subtitle2),
                            )
                      : widget.currentPage == "orderList"
                          ? SizedBox(
                              width: SizeConfig.screenWidth - 10,
                              child: Text(
                                  "There is no ongoing orders! Go and make some orders.",
                                  textAlign: TextAlign.center,
                                  style: AppTheme.of(context).subtitle2),
                            )
                          : SizedBox(
                              width: SizeConfig.screenWidth - 10,
                              child: Text(
                                  "There is no order history! Go and make some orders.",
                                  textAlign: TextAlign.center,
                                  style: AppTheme.of(context).subtitle2),
                            ))
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: Row(
                        children: [
                          const Text("Order ID"),
                          SizedBox(
                            width: SizeConfig.safeBlockHorizontal * 6,
                          ),
                          const Text("Order Status"),
                        ],
                      ),
                      tileColor: const Color.fromARGB(255, 139, 168, 236),
                      trailing: const Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Text("View", style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    SizedBox(
                        height: 550,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: orders?.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: SizeConfig.screenWidth > 500
                                            ? SizeConfig.safeBlockHorizontal * 6
                                            : SizeConfig.safeBlockHorizontal *
                                                12,
                                        child: Text(
                                          orders![index].orderId.toString(),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        width: SizeConfig.screenWidth > 500
                                            ? SizeConfig.safeBlockHorizontal * 7
                                            : SizeConfig.safeBlockHorizontal *
                                                8,
                                      ),
                                      SizedBox(
                                        width:
                                            SizeConfig.safeBlockHorizontal * 25,
                                        child: Text(
                                          orders![index].orderStatus == 0
                                              ? "Submitted"
                                              : orders![index].orderStatus == 1
                                                  ? "In Preparing"
                                                  : orders![index]
                                                              .orderStatus ==
                                                          2
                                                      ? "Ready to Pickup"
                                                      : orders![index]
                                                                  .orderStatus ==
                                                              3
                                                          ? "Completed"
                                                          : orders![index]
                                                                      .orderStatus ==
                                                                  4
                                                              ? "Cancelled"
                                                              : "Rejected",
                                        ),
                                      )
                                    ]),
                                tileColor:
                                    const Color.fromARGB(255, 207, 214, 230),
                                trailing: IconButton(
                                    splashRadius: 20,
                                    onPressed: () => {
                                          viewOrderDetail(
                                              context, orders![index].orderId)
                                        },
                                    icon: const Icon(
                                      Icons.remove_red_eye,
                                      size: 20,
                                    )),
                              ),
                            );
                          },
                        ))
                  ],
                ),
    );
  }
}
