import 'package:flutter/material.dart';

import '../screens/add.dart';
import '../screens/search.dart';

int selectedIndex = 0;

onItemTapped(BuildContext context) {
  switch (selectedIndex) {
    case 0:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddNewCardScreen()),
      );
      break;
    case 1:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SearchPage()),
      );
      break;
  }
}

List<BottomNavigationBarItem> menuitems = [
  const BottomNavigationBarItem(
    icon: Icon(Icons.home),
    label: 'Home',
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.search),
    label: 'Search',
  ),
];
