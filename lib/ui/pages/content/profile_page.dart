import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sum_plus/ui/widgets/app_bar_widget.dart';
import 'package:sum_plus/ui/widgets/bottom_nav_bar_widget.dart';
import 'package:sum_plus/ui/controller/user_controller.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  final UserController _authController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xF2F2F2).withOpacity(1),
      appBar: AppBarWidget(text: 'Profile', logoutButton: true),
      bottomNavigationBar:
          BottomNavBarWidget(section: BottomNavBarWidgetSection.profile),
      body: ListView(
        children: [
          SizedBox(height: 20.0), // Espacio entre AppBar y Container
          Center(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(16.0),
              height: 210.0,
              width: 500.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personal Info',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Itim',
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Email:  ${_authController.user.email}',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Itim',
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'School: ${_authController.user.school}',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Itim',
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Degree: ${_authController.user.degree}',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Itim',
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Birthdate: ${_authController.user.birthDate}',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Itim',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: CircleAvatar(
                      radius: 70.0,
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          Image.asset('assets/img/profile_photo_2.jpg').image,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
