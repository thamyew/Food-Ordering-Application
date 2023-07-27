import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_application/api/api_constant.dart';
import 'package:food_ordering_application/api/api_service.dart';
import 'package:food_ordering_application/model/achievement_model.dart';
import 'package:food_ordering_application/user/saveLogin.dart';
import 'package:food_ordering_application/utilities/sizeConfig.dart';
import 'package:food_ordering_application/widgets/navBarWidget.dart';

class Achievement extends StatefulWidget {
  const Achievement({Key? key}) : super(key: key);

  @override
  _AchievementState createState() => _AchievementState();
}

class _AchievementState extends State<Achievement> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  String currentPage = "achievement";
  bool isLoading = true;
  ScrollController mainScrollController = ScrollController();

  List<AchievementModel> achievements = [];
  List<AchievementModel> unlocked = [];
  List<AchievementModel> locked = [];

  Future retrieveAchivement() async {
    achievements =
        (await ApiService().getAchievement(SaveLogin().getUsername()))!;

    unlocked = achievements.where((element) => element.achieved == 1).toList();
    locked = achievements.where((element) => element.achieved == 0).toList();
  }

  @override
  void initState() {
    super.initState();
    retrieveAchivement().then((value) => setState(() {
          isLoading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: NavSideBar(currentPage),
      appBar: AppBar(
        //toolbar
        backgroundColor: Colors.blue,
        elevation: 0,
        toolbarHeight: 50,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: const Icon(Icons.more_horiz_rounded),
            onPressed: () => _key.currentState?.openDrawer()),
        title: const Text(
          "Achievement",
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              controller: mainScrollController,
              children: [
                if (unlocked.isNotEmpty) ...[
                  SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.lock_open,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Unlocked Achievements",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: unlocked.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 80,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  imageUrl:
                                      "${ApiConstant.baseUrl}/images/achieve_pic/defaultAchievementUnlocked.jpg",
                                ),
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.screenWidth / 5 * 4 - 20,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                child: Column(
                                  children: [
                                    Text(
                                      unlocked[index].achievementName,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width:
                                          SizeConfig.screenWidth / 5 * 4 - 20,
                                      child: Text(
                                        unlocked[index].achievementDesc,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.lock_outline,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Locked Achievements",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: locked.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 80,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: CachedNetworkImage(
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                imageUrl:
                                    "${ApiConstant.baseUrl}/images/achieve_pic/defaultAchievementLocked.jpg",
                              ),
                            ),
                          ),
                          SizedBox(
                            width: SizeConfig.screenWidth / 5 * 4 - 20,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                              child: Column(
                                children: [
                                  Text(
                                    locked[index].achievementName,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: SizeConfig.screenWidth / 5 * 4 - 20,
                                    child: Text(
                                      locked[index].achievementDesc,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
