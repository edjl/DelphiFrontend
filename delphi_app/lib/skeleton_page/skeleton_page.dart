import 'package:flutter/material.dart';
import 'tabs.dart';

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
  }

  Widget _buildIcon(int index, IconData? icon, String? assetPath) {
    return CircleAvatar(
      radius: 24, // Size of the circle
      backgroundColor: _selectedIndex == index
          ? Color.fromARGB(255, 23, 153, 28) // Green color for selected
          : Colors.transparent, // Transparent for unselected
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
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildIcon(0, Icons.store, null),
            label: 'Store',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(1, Icons.person, null),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(2, null, 'images/icons8-chip-100.png'),
            label: 'Bet',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(3, Icons.folder, null),
            label: 'Shares',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(4, Icons.leaderboard, null),
            label: 'Rankings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(
            255, 23, 153, 28), // Color of the label of the selected item
        unselectedItemColor: const Color.fromARGB(
            255, 0, 0, 0), // Color of the label of unselected items
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}
