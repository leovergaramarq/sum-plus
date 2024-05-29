import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sum_plus/domain/models/session.dart';

// import 'package:sum_plus/ui/pages/auth/login_page.dart';
// import 'package:sum_plus/ui/pages/content/quest_page.dart';
import 'package:sum_plus/ui/widgets/app_bar_widget.dart';
import 'package:sum_plus/ui/widgets/bottom_nav_bar_widget.dart';

// import 'package:sum_plus/ui/widgets/level_stars_widget.dart';

import 'package:sum_plus/ui/controller/auth_controller.dart';
import 'package:sum_plus/ui/controller/user_controller.dart';
import 'package:sum_plus/ui/controller/session_controller.dart';
import 'package:sum_plus/ui/widgets/session_item_widget.dart';
// import 'package:sum_plus/ui/controller/question_controller.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({Key? key}) : super(key: key);

  final AuthController _authController = Get.find<AuthController>();
  final UserController _userController = Get.find<UserController>();
  final SessionController _sessionController = Get.find<SessionController>();
  // final QuestionController _questionController = Get.find<QuestionController>();

  Widget listSessions() {
    List<Session> sessions = _sessionController.sessions.reversed.toList();

    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 6);
      },
      // scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: sessions.length,
      itemBuilder: (context, i) => (SessionItemWidget(
        session: sessions[i],
        numSession: sessions.length - i,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xF2F2F2).withOpacity(1),
        appBar: AppBarWidget(text: 'History', logoutButton: true),
        bottomNavigationBar:
            BottomNavBarWidget(section: BottomNavBarWidgetSection.history),
        body: Container(
          padding: const EdgeInsets.fromLTRB(16, 48, 16, 36),
          height: double.infinity,
          child: _sessionController.areSessionsFetched &&
                  _sessionController.sessions.isNotEmpty
              ? listSessions()
              : Container(),
        ));
  }
}
