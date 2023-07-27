import 'package:flutter/material.dart';
import 'package:food_ordering_application/api/api_service.dart';
import 'package:food_ordering_application/model/earning_model.dart';
import 'package:food_ordering_application/user/saveLogin.dart';
import 'package:food_ordering_application/widgets/navBarWidget.dart';
import 'package:food_ordering_application/earning_leaderboard/earning_analysis.dart';
import 'package:intl/intl.dart';

class EarningDashboard extends StatefulWidget {
  @override
  _EarningDashboardState createState() => _EarningDashboardState();
}

class _EarningDashboardState extends State<EarningDashboard> {
  List<EarningModel> todayEarning = [];
  List<EarningModel> yesterdayEarning = [];
  List<EarningModel> twoDayEarning = [];
  List<EarningModel> thisWeekEarning = [];
  List<EarningModel> lastWeekEarning = [];
  List<EarningModel> thisMonthEarning = [];
  List<EarningModel> lastMonthEarning = [];
  List<EarningModel> lifetimeEarning = [];

  List<DateTime> lifetimeDate = [];
  List<DateTime> twoDays = [
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
        .subtract(const Duration(days: 1)),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
  ];
  List<DateTime> lastWeek = [];
  List<DateTime> thisWeek = [];
  List<DateTime> lastMonth = [];
  List<DateTime> thisMonth = [];

  int diffStartWeek = DateTime.now().weekday == 7 ? 0 : DateTime.now().weekday;
  int diffEndWeek =
      DateTime.now().weekday == 7 ? 6 : 6 - DateTime.now().weekday;
  DateTime startDate = DateTime(2022, 12, 1);
  DateTime thisMonthFirstDate =
      DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime thisMonthLastDate =
      DateTime(DateTime.now().year, DateTime.now().month + 1, 1)
          .subtract(const Duration(days: 1));
  DateTime lastMonthFirstDate =
      DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
  DateTime lastMonthLastDate =
      DateTime(DateTime.now().year, DateTime.now().month, 1)
          .subtract(const Duration(days: 1));

  bool isLoading = true;

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  String currentPage = 'earning';

  List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  Future retrieveEarnings() async {
    lifetimeEarning = (await ApiService().getEarning(SaveLogin().getLevel()))!;

    if (lifetimeEarning.isNotEmpty) {
      twoDayEarning.addAll(lifetimeEarning
          .where((element) =>
              DateTime.parse(element.earningDate).compareTo(twoDays.first) >=
                  0 &&
              DateTime.parse(element.earningDate).compareTo(twoDays.last) <= 0)
          .toList());
      todayEarning = lifetimeEarning
          .where((element) =>
              element.earningDate ==
              DateFormat('yyyy-MM-dd').format(DateTime.now()))
          .toList();
      yesterdayEarning = lifetimeEarning
          .where((element) =>
              element.earningDate ==
              DateFormat('yyyy-MM-dd')
                  .format(DateTime.now().subtract(const Duration(days: 1))))
          .toList();
      lastWeekEarning = lifetimeEarning
          .where((element) =>
              DateTime.parse(element.earningDate).compareTo(DateTime.now()
                      .subtract(Duration(days: diffStartWeek + 7))) >=
                  0 &&
              DateTime.parse(element.earningDate).compareTo(DateTime.now()
                      .subtract(Duration(days: diffStartWeek + 1))) <=
                  0)
          .toList();

      thisWeekEarning = lifetimeEarning
          .where((element) =>
              DateTime.parse(element.earningDate).compareTo(
                      DateTime.now().subtract(Duration(days: diffStartWeek))) >=
                  0 &&
              DateTime.parse(element.earningDate).compareTo(
                      DateTime.now().add(Duration(days: diffEndWeek))) <=
                  0)
          .toList();

      thisMonthEarning = lifetimeEarning
          .where((element) =>
              DateTime.parse(element.earningDate)
                      .compareTo(thisMonthFirstDate) >=
                  0 &&
              DateTime.parse(element.earningDate)
                      .compareTo(thisMonthLastDate) <=
                  0)
          .toList();

      lastMonthEarning = lifetimeEarning
          .where((element) =>
              DateTime.parse(element.earningDate)
                      .compareTo(lastMonthFirstDate) >=
                  0 &&
              DateTime.parse(element.earningDate)
                      .compareTo(lastMonthLastDate) <=
                  0)
          .toList();
      startDate = lastMonth.first.compareTo(
                  DateTime.parse(lifetimeEarning.first.earningDate)) >
              0
          ? DateTime.parse(lifetimeEarning.first.earningDate)
          : lastMonth.first;
    }

    lifetimeDate = getDaysInBetween(startDate, DateTime.now());
  }

  @override
  void initState() {
    super.initState();
    lastWeek = getDaysInBetween(
        DateTime.now().subtract(Duration(days: diffStartWeek + 7)),
        DateTime.now().subtract(Duration(days: diffStartWeek + 1)));
    thisWeek = getDaysInBetween(
        DateTime.now().subtract(Duration(days: diffStartWeek)),
        DateTime.now().add(Duration(days: diffEndWeek)));

    lastMonth = getDaysInBetween(lastMonthFirstDate, lastMonthLastDate);
    thisMonth = getDaysInBetween(thisMonthFirstDate, thisMonthLastDate);

    retrieveEarnings().then((value) => setState(() {
          isLoading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(initialPage: 1);
    return Scaffold(
        key: _key,
        drawer: NavSideBar(currentPage),
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          toolbarHeight: 50,
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: const Icon(Icons.more_horiz_rounded),
              onPressed: () => _key.currentState?.openDrawer()),
          title: const Text(
            "Earning Analysis",
          ),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : PageView(
                controller: controller,
                children: <Widget>[
                  Center(
                    child: EarningAnalysisWidget(
                      earning: lifetimeEarning,
                      date: lifetimeDate,
                      dataLabel: "Lifetime",
                      dataDateLabel: "until today...",
                      controller: controller,
                      currentIndex: 0,
                    ),
                  ),
                  Center(
                    child: EarningAnalysisWidget(
                      earning: twoDayEarning,
                      date: twoDays,
                      dataLabel: "Today & Yesterday",
                      dataDateLabel:
                          "${DateFormat('yyyy/MM/dd').format(twoDays.last)} - ${DateFormat('yyyy/MM/dd').format(twoDays.first)}",
                      controller: controller,
                      currentIndex: 1,
                    ),
                  ),
                  Center(
                    child: EarningAnalysisWidget(
                      earning: thisWeekEarning,
                      date: thisWeek,
                      dataLabel: "This Week",
                      dataDateLabel:
                          "${DateFormat('yyyy/MM/dd').format(thisWeek.first)} - ${DateFormat('yyyy/MM/dd').format(thisWeek.last)}",
                      controller: controller,
                      currentIndex: 2,
                    ),
                  ),
                  Center(
                    child: EarningAnalysisWidget(
                      earning: lastWeekEarning,
                      date: lastWeek,
                      dataLabel: "Last Week",
                      dataDateLabel:
                          "${DateFormat('yyyy/MM/dd').format(lastWeek.first)} - ${DateFormat('yyyy/MM/dd').format(lastWeek.last)}",
                      controller: controller,
                      currentIndex: 3,
                    ),
                  ),
                  Center(
                    child: EarningAnalysisWidget(
                      earning: thisMonthEarning,
                      date: thisMonth,
                      dataLabel: "This Month",
                      dataDateLabel:
                          "${DateFormat('yyyy/MM/dd').format(thisMonth.first)} - ${DateFormat('yyyy/MM/dd').format(thisMonth.last)}",
                      controller: controller,
                      currentIndex: 4,
                    ),
                  ),
                  Center(
                    child: EarningAnalysisWidget(
                      earning: lastMonthEarning,
                      date: lastMonth,
                      dataLabel: "Last Month",
                      dataDateLabel:
                          "${DateFormat('yyyy/MM/dd').format(lastMonth.first)} - ${DateFormat('yyyy/MM/dd').format(lastMonth.last)}",
                      controller: controller,
                      currentIndex: 5,
                    ),
                  ),
                ],
              ));
  }
}
