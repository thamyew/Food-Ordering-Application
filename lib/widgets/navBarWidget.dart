import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_ordering_application/api/api_service.dart';
import 'package:food_ordering_application/cart/checkout_widget.dart';
import 'package:food_ordering_application/earning_leaderboard/earning_dashboard.dart';
import 'package:food_ordering_application/earning_leaderboard/leaderboard_dashboard.dart';
import 'package:food_ordering_application/manage_menu/archivedMenu.dart';
import 'package:food_ordering_application/manage_menu/manageMenu.dart';
import 'package:food_ordering_application/order/orderList.dart';
import 'package:food_ordering_application/spending_achievement/achievement.dart';
import 'package:food_ordering_application/spending_achievement/spending_dashboard.dart';
import 'package:food_ordering_application/user/login.dart';
import 'package:food_ordering_application/user/profilePage.dart';
import 'package:food_ordering_application/user/saveLogin.dart';
import 'package:food_ordering_application/view_menu/foodListingWidget.dart';

class NavSideBar extends StatelessWidget {
  const NavSideBar(this.currentPage, {super.key});
  final String currentPage;
  final storage = const FlutterSecureStorage();

  void logout(BuildContext context) {
    ApiService().deleteFCM(SaveLogin().getUsername());
    SaveLogin().reset();
    storage.deleteAll();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MyLogin()),
        (route) => false);
  }

  void toProfilePage(BuildContext context) {
    Navigator.pop(context);

    if (currentPage != "profile") {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const MyProfilePage()));
    }
  }

  void toManageMenu(BuildContext context) {
    Navigator.pop(context);

    if (currentPage != "manageMenu") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const ManageMenu()));
    }
  }

  void toManageArchiveMenu(BuildContext context) {
    Navigator.pop(context);

    if (currentPage != "archiveMenu") {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ArchivedMenu()));
    }
  }

  void toFoodMenu(BuildContext context) async {
    Navigator.pop(context);

    if (currentPage != "foodMenu") {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const FoodListingWidget()));
    }
  }

  void toViewCart(BuildContext context) async {
    Navigator.pop(context);

    if (currentPage != "viewCart") {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const CheckoutWidget()));
    }
  }

  void toPastOrderList(BuildContext context) async {
    Navigator.pop(context);

    if (currentPage != "pastOrderList") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const OrderList(currentPage: "pastOrderList")));
    }
  }

  void toOrderList(BuildContext context) async {
    Navigator.pop(context);

    if (currentPage != "orderList") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const OrderList(currentPage: "orderList")));
    }
  }

  void toSpendingAnalysis(BuildContext context) async {
    Navigator.pop(context);

    if (currentPage != "spending") {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SpendingDashboard()));
    }
  }

  void toAchievement(BuildContext context) {
    Navigator.pop(context);

    if (currentPage != "achievement") {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const Achievement()));
    }
  }

  void toEarning(BuildContext context) {
    Navigator.pop(context);

    if (currentPage != "earning") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => EarningDashboard()));
    }
  }

  void toLeaderboard(BuildContext context) {
    Navigator.pop(context);

    if (currentPage != "leaderboard") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const LeaderboardDashboard()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      child: ListView(
        children: [
          Container(
            height: 50,
            color: Colors.blue,
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () => toProfilePage(context),
          ),
          const Divider(),
          if (SaveLogin().getLevel() == 0) ...[
            ListTile(
              leading: const Icon(Icons.restaurant_menu_rounded),
              title: const Text('Manage Menu'),
              onTap: () => toManageMenu(context),
            ),
            ListTile(
              leading: const Icon(Icons.archive_rounded),
              title: const Text('Manage Archived Menu'),
              onTap: () => toManageArchiveMenu(context),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.assignment_rounded),
              title: const Text('View Current Orders'),
              onTap: () => toOrderList(context),
            ),
            ListTile(
              leading: const Icon(Icons.checklist_rounded),
              title: const Text('View Archived Orders'),
              onTap: () => toPastOrderList(context),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('View Earning'),
              onTap: () => toEarning(context),
            ),
            ListTile(
              leading: const Icon(Icons.leaderboard),
              title: const Text('View Leaderboard'),
              onTap: () => toLeaderboard(context),
            ),
          ] else ...[
            ListTile(
              leading: const Icon(Icons.restaurant_menu_rounded),
              title: const Text('View Menu'),
              onTap: () => toFoodMenu(context),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart_rounded),
              title: const Text('View Cart'),
              onTap: () => toViewCart(context),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.assignment_rounded),
              title: const Text('View Current Orders'),
              onTap: () => toOrderList(context),
            ),
            ListTile(
              leading: const Icon(Icons.checklist_rounded),
              title: const Text('View Archived Orders'),
              onTap: () => toPastOrderList(context),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('View Spending'),
              onTap: () => toSpendingAnalysis(context),
            ),
            ListTile(
              leading: const Icon(Icons.emoji_events),
              title: const Text('View Achievements'),
              onTap: () => toAchievement(context),
            ),
          ],
          const Divider(),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.exit_to_app),
            onTap: () => logout(context),
          ),
        ],
      ),
    );
  }
}
