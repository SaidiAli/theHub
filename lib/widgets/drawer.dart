import 'package:flutter/material.dart';
import 'package:stacked_themes/stacked_themes.dart';
import '../constants/Theme.dart';

import './drawer-tile.dart';

class ArgonDrawer extends StatelessWidget {
  final String currentPage;

  ArgonDrawer({this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      margin: EdgeInsets.only(top: 15),
      color: getThemeManager(context).isDarkMode ? Colors.grey[900] : Colors.white,
      child: Column(children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width * 0.85,
            child: SafeArea(
              bottom: false,
              child: Center(
                child: Text('theHub',
                    style: TextStyle(
                        fontSize: 50,
                        color: ArgonColors.primary,
                        fontWeight: FontWeight.bold)),
              ),
            )),
        SizedBox(height: 15),
        Expanded(
          flex: 2,
          child: ListView(
            padding: EdgeInsets.only(top: 24, left: 16, right: 16),
            children: [
              DrawerTile(
                  icon: Icons.home,
                  onTap: () {
                    
                    if (currentPage != "Home")
                      Navigator.pushReplacementNamed(context, '/home');
                  
                  },
                  iconColor: ArgonColors.primary,
                  title: "Home",
                  isSelected: currentPage == "Home" ? true : false),
              DrawerTile(
                  icon: Icons.settings,
                  onTap: () {
                    
                    if (currentPage != 'settings')
                      Navigator.pushReplacementNamed(context, '/settings');
                  
                  },
                  iconColor: ArgonColors.primary,
                  title: "Settings",
                  isSelected: currentPage == "settings" ? true : false),
            ],
          ),
        ),
      ]),
    ));
  }
}
