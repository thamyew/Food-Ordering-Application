import 'package:flutter/material.dart';
import 'package:food_ordering_application/api/api_service.dart';
import 'package:food_ordering_application/earning_leaderboard/leaderboard.dart';
import 'package:food_ordering_application/model/total_spending_model.dart';
import 'package:food_ordering_application/user/saveLogin.dart';
import 'package:food_ordering_application/widgets/navBarWidget.dart';
import 'package:intl/intl.dart';

class LeaderboardDashboard extends StatefulWidget {
  const LeaderboardDashboard({super.key});

  @override
  State<StatefulWidget> createState() => _LeaderboardDashboardState();
}

class _LeaderboardDashboardState extends State<LeaderboardDashboard> {
  List<TotalSpendingModel> spendingToday = [];
  List<TotalSpendingModel> spendingThisWeek = [];
  List<TotalSpendingModel> spendingLastWeek = [];
  List<TotalSpendingModel> spendingThisMonth = [];
  List<TotalSpendingModel> spendingLastMonth = [];

  DateTime today = DateTime.now();
  List<DateTime> thisWeek = [];
  List<DateTime> lastWeek = [];
  List<DateTime> thisMonth = [];
  List<DateTime> lastMonth = [];

  int diffStartWeek = DateTime.now().weekday == 7 ? 0 : DateTime.now().weekday;
  int diffEndWeek =
      DateTime.now().weekday == 7 ? 6 : 6 - DateTime.now().weekday;
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
  String currentPage = 'leaderboard';

  List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  Future retrieveData() async {
    spendingToday = (await ApiService().getTotalSpending(
        SaveLogin().getLevel(),
        DateFormat("yyyy-MM-dd").format(today),
        DateFormat("yyyy-MM-dd").format(today)))!;

    spendingThisWeek = (await ApiService().getTotalSpending(
        SaveLogin().getLevel(),
        DateFormat("yyyy-MM-dd").format(thisWeek.first),
        DateFormat("yyyy-MM-dd").format(thisWeek.last)))!;

    spendingLastWeek = (await ApiService().getTotalSpending(
        SaveLogin().getLevel(),
        DateFormat("yyyy-MM-dd").format(lastWeek.first),
        DateFormat("yyyy-MM-dd").format(lastWeek.last)))!;

    spendingThisMonth = (await ApiService().getTotalSpending(
        SaveLogin().getLevel(),
        DateFormat("yyyy-MM-dd").format(thisMonth.first),
        DateFormat("yyyy-MM-dd").format(thisMonth.last)))!;

    spendingLastMonth = (await ApiService().getTotalSpending(
        SaveLogin().getLevel(),
        DateFormat("yyyy-MM-dd").format(lastMonth.first),
        DateFormat("yyyy-MM-dd").format(lastMonth.last)))!;
  }

  @override
  void initState() {
    super.initState();
    thisWeek = getDaysInBetween(
        DateTime.now().subtract(Duration(days: diffStartWeek)),
        DateTime.now().add(Duration(days: diffEndWeek)));
    lastWeek = getDaysInBetween(
        DateTime.now().subtract(Duration(days: diffStartWeek + 7)),
        DateTime.now().subtract(Duration(days: diffStartWeek + 1)));
    lastMonth = getDaysInBetween(lastMonthFirstDate, lastMonthLastDate);
    thisMonth = getDaysInBetween(thisMonthFirstDate, thisMonthLastDate);
    retrieveData().then((value) => setState(() {
          isLoading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
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
          "Leaderboard on Spending",
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
                    child: Leaderboard(
                  spending: spendingToday,
                  periodLabel: "Today",
                  dateLabel: DateFormat('yyyy/MM/dd').format(today),
                  controller: controller,
                  currentIndex: 0,
                )),
                Center(
                  child: Leaderboard(
                    spending: spendingThisWeek,
                    periodLabel: "This Week",
                    dateLabel:
                        "${DateFormat('yyyy/MM/dd').format(thisWeek.first)} - ${DateFormat('yyyy/MM/dd').format(thisWeek.last)}",
                    controller: controller,
                    currentIndex: 1,
                  ),
                ),
                Center(
                    child: Leaderboard(
                  spending: spendingLastWeek,
                  periodLabel: "Last Week",
                  dateLabel:
                      "${DateFormat('yyyy/MM/dd').format(lastWeek.first)} - ${DateFormat('yyyy/MM/dd').format(lastWeek.last)}",
                  controller: controller,
                  currentIndex: 2,
                )),
                Center(
                    child: Leaderboard(
                  spending: spendingThisMonth,
                  periodLabel: "This Month",
                  dateLabel:
                      "${DateFormat('yyyy/MM/dd').format(thisMonth.first)} - ${DateFormat('yyyy/MM/dd').format(thisMonth.last)}",
                  controller: controller,
                  currentIndex: 3,
                )),
                Center(
                    child: Leaderboard(
                  spending: spendingLastMonth,
                  periodLabel: "Last Month",
                  dateLabel:
                      "${DateFormat('yyyy/MM/dd').format(lastMonth.first)} - ${DateFormat('yyyy/MM/dd').format(lastMonth.last)}",
                  controller: controller,
                  currentIndex: 4,
                )),
              ],
            ),
    );
  }
}
