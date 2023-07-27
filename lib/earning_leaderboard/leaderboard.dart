import 'package:flutter/material.dart';
import 'package:food_ordering_application/model/total_spending_model.dart';
import 'package:food_ordering_application/utilities/sizeConfig.dart';
import 'package:intl/intl.dart';

const Color cool = Color(0xFF181A2F);
Color leadbtn = const Color.fromARGB(255, 5, 113, 155);
Color gold = const Color(0xFFD0B13E);
Color silver = const Color(0xFFE7E7E7);
Color bronze = const Color(0xFFA45735);

class Leaderboard extends StatefulWidget {
  final String periodLabel;
  final String dateLabel;
  final List<TotalSpendingModel> spending;
  final PageController controller;
  final int currentIndex;

  const Leaderboard(
      {super.key,
      required this.periodLabel,
      required this.dateLabel,
      required this.spending,
      required this.controller,
      required this.currentIndex});
  @override
  State<StatefulWidget> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  final int minPage = 0;
  final int maxPage = 4;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.blue,
            automaticallyImplyLeading: false,
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 250.0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(4.0),
              child: SizedBox(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: SizeConfig.screenWidth / 10 * 2 - 10,
                        child: Center(
                          child: Text("Rank",
                              style: TextStyle(
                                  color: Colors.grey[200],
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.screenWidth / 10 * 4 - 10,
                        child: Text(
                          "Username",
                          style: TextStyle(
                              color: Colors.grey[200],
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.screenWidth / 10 * 4 - 10,
                        child: Center(
                          child: Text(
                            "Spending (RM)",
                            style: TextStyle(
                                color: Colors.grey[200],
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[leadbtn.withOpacity(0), cool])),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: Text(
                        "LEADERBOARD",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.grey[200],
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: SizeConfig.screenWidth / 4,
                          child: widget.currentIndex != 0
                              ? InkWell(
                                  onTap: () async {
                                    previousPage(widget.controller);
                                  },
                                  child: const Icon(
                                    Icons.keyboard_arrow_left,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                )
                              : const SizedBox(),
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth / 2,
                          child: Column(
                            children: [
                              Text(
                                widget.periodLabel,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[200],
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.dateLabel,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[200],
                                    fontStyle: FontStyle.italic),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Icon(
                                Icons.emoji_events_rounded,
                                color: gold,
                                size: 70,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth / 4,
                          child: widget.currentIndex != 4
                              ? InkWell(
                                  onTap: () async {
                                    nextPage(widget.controller);
                                  },
                                  child: const Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                )
                              : const SizedBox(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            elevation: 9.0,
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => buildList(context, index),
            childCount: widget.spending.length,
          ))
        ],
      ),
    );
  }

  Widget buildList(BuildContext txt, int index) {
    int ind = index + 1;
    String rank = ind.toString();
    String name = widget.spending[index].customerUsername;
    String spent =
        double.parse(widget.spending[index].total).toStringAsFixed(2);

    Widget listItem;

    listItem = Card(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      shadowColor: Colors.grey[200],
      color: ind == 1
          ? gold
          : ind == 2
              ? silver
              : ind == 3
                  ? bronze
                  : Colors.white, // Changed
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: SizeConfig.screenWidth / 10 * 2 - 10,
              child: Center(
                child: Text(rank,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(
              width: SizeConfig.screenWidth / 10 * 4 - 10,
              child: Text(
                name,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: SizeConfig.screenWidth / 10 * 4 - 10,
              child: Center(
                child: Text(
                  spent,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return listItem;
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
