import 'package:flutter/material.dart';
import 'package:food_ordering_application/api/api_service.dart';
import 'package:food_ordering_application/model/spending_model.dart';
import 'package:food_ordering_application/spending_achievement/spending_analysis.dart';
import 'package:food_ordering_application/user/saveLogin.dart';
import 'package:food_ordering_application/widgets/navBarWidget.dart';
import 'package:intl/intl.dart';

class SpendingDashboard extends StatefulWidget {
  @override
  _SpendingDashboardState createState() => _SpendingDashboardState();
}

class _SpendingDashboardState extends State<SpendingDashboard> {
  List<SpendingModel> todaySpending = [];
  List<SpendingModel> yesterdaySpending = [];
  List<SpendingModel> twoDaySpending = [];
  List<SpendingModel> thisWeekSpending = [];
  List<SpendingModel> lastWeekSpending = [];
  List<SpendingModel> thisMonthSpending = [];
  List<SpendingModel> lastMonthSpending = [];
  List<SpendingModel> lifetimeSpending = [];

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
  String currentPage = 'spending';

  List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  Future retrieveSpendings() async {
    lifetimeSpending = (await ApiService()
        .getSpending(SaveLogin().getUsername(), SaveLogin().getLevel()))!;

    if (lifetimeSpending.isNotEmpty) {
      twoDaySpending.addAll(lifetimeSpending
          .where((element) =>
              DateTime.parse(element.spendingDate).compareTo(twoDays.first) >=
                  0 &&
              DateTime.parse(element.spendingDate).compareTo(twoDays.last) <= 0)
          .toList());

      todaySpending = lifetimeSpending
          .where((element) =>
              element.spendingDate ==
              DateFormat('yyyy-MM-dd')
                  .format(DateTime.now().subtract(const Duration(days: 1))))
          .toList();

      yesterdaySpending = lifetimeSpending
          .where((element) =>
              element.spendingDate ==
              DateFormat('yyyy-MM-dd')
                  .format(DateTime.now().subtract(const Duration(days: 1))))
          .toList();

      lastWeekSpending = lifetimeSpending
          .where((element) =>
              DateTime.parse(element.spendingDate).compareTo(DateTime.now()
                      .subtract(Duration(days: diffStartWeek + 7))) >=
                  0 &&
              DateTime.parse(element.spendingDate).compareTo(DateTime.now()
                      .subtract(Duration(days: diffStartWeek + 1))) <=
                  0)
          .toList();

      thisWeekSpending = lifetimeSpending
          .where((element) =>
              DateTime.parse(element.spendingDate).compareTo(
                      DateTime.now().subtract(Duration(days: diffStartWeek))) >=
                  0 &&
              DateTime.parse(element.spendingDate).compareTo(
                      DateTime.now().add(Duration(days: diffEndWeek))) <=
                  0)
          .toList();

      thisMonthSpending = lifetimeSpending
          .where((element) =>
              DateTime.parse(element.spendingDate)
                      .compareTo(thisMonthFirstDate) >=
                  0 &&
              DateTime.parse(element.spendingDate)
                      .compareTo(thisMonthLastDate) <=
                  0)
          .toList();

      lastMonthSpending = lifetimeSpending
          .where((element) =>
              DateTime.parse(element.spendingDate)
                      .compareTo(lastMonthFirstDate) >=
                  0 &&
              DateTime.parse(element.spendingDate)
                      .compareTo(lastMonthLastDate) <=
                  0)
          .toList();
      startDate = lastMonth.first.compareTo(
                  DateTime.parse(lifetimeSpending.first.spendingDate)) >
              0
          ? DateTime.parse(lifetimeSpending.first.spendingDate)
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

    retrieveSpendings().then((value) => setState(() {
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
            "Spending Analysis",
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
                    child: SpendingAnalysisWidget(
                      spending: lifetimeSpending,
                      date: lifetimeDate,
                      dataLabel: "Lifetime",
                      dataDateLabel: "until today...",
                      controller: controller,
                      currentIndex: 0,
                    ),
                  ),
                  Center(
                    child: SpendingAnalysisWidget(
                      spending: twoDaySpending,
                      date: twoDays,
                      dataLabel: "Today & Yesterday",
                      dataDateLabel:
                          "${DateFormat('yyyy/MM/dd').format(twoDays.last)} - ${DateFormat('yyyy/MM/dd').format(twoDays.first)}",
                      controller: controller,
                      currentIndex: 1,
                    ),
                  ),
                  Center(
                    child: SpendingAnalysisWidget(
                      spending: thisWeekSpending,
                      date: thisWeek,
                      dataLabel: "This Week",
                      dataDateLabel:
                          "${DateFormat('yyyy/MM/dd').format(thisWeek.first)} - ${DateFormat('yyyy/MM/dd').format(thisWeek.last)}",
                      controller: controller,
                      currentIndex: 2,
                    ),
                  ),
                  Center(
                    child: SpendingAnalysisWidget(
                      spending: lastWeekSpending,
                      date: lastWeek,
                      dataLabel: "Last Week",
                      dataDateLabel:
                          "${DateFormat('yyyy/MM/dd').format(lastWeek.first)} - ${DateFormat('yyyy/MM/dd').format(lastWeek.last)}",
                      controller: controller,
                      currentIndex: 3,
                    ),
                  ),
                  Center(
                    child: SpendingAnalysisWidget(
                      spending: thisMonthSpending,
                      date: thisMonth,
                      dataLabel: "This Month",
                      dataDateLabel:
                          "${DateFormat('yyyy/MM/dd').format(thisMonth.first)} - ${DateFormat('yyyy/MM/dd').format(thisMonth.last)}",
                      controller: controller,
                      currentIndex: 4,
                    ),
                  ),
                  Center(
                    child: SpendingAnalysisWidget(
                      spending: lastMonthSpending,
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
