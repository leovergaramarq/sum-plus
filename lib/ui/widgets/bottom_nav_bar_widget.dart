import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:sum_plus/ui/pages/content/home_page.dart';
import 'package:sum_plus/ui/pages/content/profile_page.dart';
import 'package:sum_plus/ui/pages/content/history_page.dart';

class BottomNavBarWidget extends StatelessWidget {
  const BottomNavBarWidget({Key? key, required this.section}) : super(key: key);

  final BottomNavBarWidgetSection section;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      key: const Key('BottomNavBar'),
      currentIndex: section.index,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home,
              color: section.index == 0 ? Colors.purple : Colors.grey,
              size: 30),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person,
              color: section.index == 1 ? Colors.purple : Colors.grey,
              size: 30),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history,
              color: section.index == 2 ? Colors.purple : Colors.grey,
              size: 30),
          label: 'History',
        ),
      ],
      selectedItemColor: Colors.purple,
      onTap: (int index) {
        if (section.index == index) return;
        switch (index) {
          case 0:
            Get.off(() => HomePage(
                  key: const Key('HomePage'),
                  // fetchSessions: false, // don't fetch sessions again
                ));
            break;
          case 1:
            Get.off(() => ProfilePage(
                  key: const Key('ProfilePage'),
                ));
            break;
          case 2:
            Get.off(() => HistoryPage(
                  key: const Key('HistoryPage'),
                ));
            break;
        }
      },
    );
  }
}

enum BottomNavBarWidgetSection { home, profile, history }
