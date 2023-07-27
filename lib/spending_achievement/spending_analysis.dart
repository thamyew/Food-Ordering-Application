import 'package:flutter/material.dart';
import 'package:food_ordering_application/app_theme.dart';
import 'package:food_ordering_application/model/spending_date.dart';
import 'package:food_ordering_application/model/spending_model.dart';
import 'package:food_ordering_application/utilities/sizeConfig.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SpendingAnalysisWidget extends StatefulWidget {
  const SpendingAnalysisWidget({
    Key? key,
    required this.spending,
    required this.date,
    required this.dataLabel,
    required this.dataDateLabel,
    required this.controller,
    required this.currentIndex,
  }) : super(key: key);

  final List<SpendingModel>? spending;
  final List<DateTime> date;
  final String dataLabel;
  final String dataDateLabel;
  final PageController controller;
  final int currentIndex;

  @override
  _SpendingAnalysisWidgetState createState() => _SpendingAnalysisWidgetState();
}

class _SpendingAnalysisWidgetState extends State<SpendingAnalysisWidget>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<SpendingDate> dateData = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.date.length; i++) {
      String date = DateFormat('yyyy-MM-dd').format(widget.date[i]);

      if (widget.spending!.isNotEmpty) {
        if (widget.date.length != widget.spending!.length) {
          for (int j = 0; j < widget.spending!.length; j++) {
            if (widget.spending![j].spendingDate == date) {
              dateData.add(SpendingDate(
                  widget.date[i], double.parse(widget.spending![j].total)));
            } else {
              dateData.add(SpendingDate(widget.date[i], 0));
            }
          }
        } else {
          dateData.add(SpendingDate(
              widget.date[i], double.parse(widget.spending![i].total)));
        }
      } else {
        dateData.add(SpendingDate(widget.date[i], 0));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double finalValue = 0;
    if (widget.spending!.isNotEmpty) {
      for (int i = 0; i < widget.spending!.length; i++) {
        finalValue += double.parse(widget.spending![i].total);
      }
    }
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: AppTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: AppTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              "${widget.dataLabel} Analysis",
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          leading: widget.currentIndex != 0
              ? InkWell(
                  onTap: () async {
                    previousPage(widget.controller);
                  },
                  child: Icon(
                    Icons.keyboard_arrow_left,
                    color: AppTheme.of(context).secondaryText,
                    size: 50,
                  ),
                )
              : const SizedBox(),
          actions: [
            widget.currentIndex != 5
                ? InkWell(
                    onTap: () async {
                      nextPage(widget.controller);
                    },
                    child: Icon(
                      Icons.keyboard_arrow_right,
                      color: AppTheme.of(context).secondaryText,
                      size: 50,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            if (widget.dataLabel == "Today & Yesterday") ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 180,
                    width: SizeConfig.safeBlockHorizontal * 45,
                    decoration: BoxDecoration(
                      color: AppTheme.of(context).secondaryBackground,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 2,
                          color: Color(0x3600000F),
                          offset: Offset(0, 2),
                        )
                      ],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Text(
                            "Today",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            DateFormat('yyyy/MM/dd').format(widget.date.last),
                            style: const TextStyle(
                                fontSize: 15, fontStyle: FontStyle.italic),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Text("Total Spending"),
                          Text(
                            widget.spending!.isEmpty
                                ? "RM 0.00"
                                : "RM ${dateData[1].spending.toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 35),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 180,
                    width: SizeConfig.safeBlockHorizontal * 45,
                    decoration: BoxDecoration(
                      color: AppTheme.of(context).secondaryBackground,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 2,
                          color: Color(0x3600000F),
                          offset: Offset(0, 2),
                        )
                      ],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Text(
                            "Yesterday",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            DateFormat('yyyy/MM/dd').format(widget.date.first),
                            style: const TextStyle(
                                fontSize: 15, fontStyle: FontStyle.italic),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Text("Total Spending"),
                          Text(
                            widget.spending!.isEmpty
                                ? "RM 0.00"
                                : "RM ${dateData[0].spending.toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 35),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ] else ...[
              Container(
                height: 180,
                width: SizeConfig.screenWidth - 15,
                decoration: BoxDecoration(
                  color: AppTheme.of(context).secondaryBackground,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 2,
                      color: Color(0x3600000F),
                      offset: Offset(0, 2),
                    )
                  ],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        widget.dataLabel,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.dataDateLabel,
                        style: const TextStyle(
                            fontSize: 15, fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text("Total Spending"),
                      Text(
                        widget.spending!.isEmpty
                            ? "RM 0.00"
                            : "RM ${finalValue.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 35),
                      )
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                height: 50,
                child: Row(
                  children: const [
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Chart Analysis:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: SizeConfig.screenHeight / 2,
              width: SizeConfig.screenWidth,
              child: dateData.where((element) => element.spending != 0).isEmpty
                  ? const Center(
                      child:
                          Text("There is no spending data to plot the chart"),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8),
                      child: widget.date.length > 7
                          ? SfCartesianChart(
                              primaryXAxis: DateTimeAxis(
                                intervalType: DateTimeIntervalType.auto,
                                majorGridLines: const MajorGridLines(width: 0),
                                majorTickLines: const MajorTickLines(width: 0),
                              ),
                              primaryYAxis: NumericAxis(
                                numberFormat: NumberFormat.currency(
                                    locale: "en_MY", symbol: "RM "),
                                isVisible: false,
                              ),
                              legend: Legend(isVisible: false),
                              tooltipBehavior: TooltipBehavior(enable: true),
                              series: <ChartSeries<SpendingDate, DateTime>>[
                                  LineSeries<SpendingDate, DateTime>(
                                    dataSource: dateData,
                                    xValueMapper: (SpendingDate spending, _) =>
                                        spending.date,
                                    yValueMapper: (SpendingDate spending, _) =>
                                        spending.spending,
                                    name: 'Spendings',
                                    dataLabelSettings: const DataLabelSettings(
                                        isVisible: false, showZeroValue: false),
                                  )
                                ])
                          : SfCartesianChart(
                              primaryXAxis: DateTimeCategoryAxis(
                                dateFormat: DateFormat("MMM dd"),
                                intervalType: DateTimeIntervalType.days,
                                interval: 1,
                                majorGridLines: const MajorGridLines(width: 0),
                                majorTickLines: const MajorTickLines(width: 0),
                              ),
                              primaryYAxis: NumericAxis(
                                numberFormat: NumberFormat.currency(
                                    locale: "en_MY", symbol: "RM "),
                                isVisible: false,
                              ),
                              legend: Legend(isVisible: false),
                              tooltipBehavior: TooltipBehavior(enable: true),
                              series: <ChartSeries<SpendingDate, DateTime>>[
                                  ColumnSeries<SpendingDate, DateTime>(
                                    dataSource: dateData,
                                    xValueMapper: (SpendingDate spending, _) =>
                                        spending.date,
                                    yValueMapper: (SpendingDate spending, _) =>
                                        spending.spending,
                                    name: 'Spendings',
                                    dataLabelSettings: const DataLabelSettings(
                                        isVisible: true, showZeroValue: false),
                                  )
                                ]),
                    ),
            ),
          ],
        ));
  }

  nextPage(PageController controller) {
    controller.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInCubic,
    );
  }

  previousPage(PageController controller) {
    controller.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInCubic,
    );
  }
}
