import 'package:flutter/material.dart';
import 'tabs.dart';
import '../constants/graphics_constants.dart';
import '../profile/user_profile_service.dart';

class SkeletonPage extends StatefulWidget {
  const SkeletonPage({super.key});

  @override
  State<SkeletonPage> createState() => _SkeletonPageState();
}

class _SkeletonPageState extends State<SkeletonPage> {
  int _selectedIndex = 2;

  static const List<Widget> _widgetOptions = <Widget>[
    StoreTab(),
    ProfileTab(),
    BetTab(),
    SharesTab(),
    LeaderboardTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      UserProfileService().loadUserProfile();
    }
  }

  Widget _buildIcon(int index, IconData? icon, String? assetPath) {
    return CircleAvatar(
      radius: 24, // Size of the circle
      backgroundColor: _selectedIndex == index
          ? GraphicsConstants.colorTheme
          : Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(10.0), // Adjust padding as needed
        child: assetPath != null
            ? Image.asset(
                assetPath,
                color: _selectedIndex == index
                    ? Colors.white // Color for selected icon
                    : Colors.black, // Color for unselected icon
              )
            : Icon(
                icon,
                color: _selectedIndex == index
                    ? Colors.white // Color for selected icon
                    : Colors.black, // Color for unselected icon
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildIcon(0, Icons.store, null),
            label: 'Store',
            backgroundColor: GraphicsConstants.lightColorTheme,
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(1, Icons.person, null),
            label: 'Profile',
            backgroundColor: GraphicsConstants.lightColorTheme,
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(2, null, 'images/icons8-chip-100.png'),
            label: 'Bet',
            backgroundColor: GraphicsConstants.lightColorTheme,
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(3, Icons.folder, null),
            label: 'Shares',
            backgroundColor: GraphicsConstants.lightColorTheme,
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(4, Icons.leaderboard, null),
            label: 'Rankings',
            backgroundColor: GraphicsConstants.lightColorTheme,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: GraphicsConstants
            .colorTheme, // Color of the label of the selected item
        unselectedItemColor:
            Colors.black, // Color of the label of unselected items
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}
