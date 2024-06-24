import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toautoapp/profile.dart';

import 'expense.dart';
import 'garage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  static int selectedIndex = 1;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = Home.selectedIndex; // Başlangıçta Garage sekmesi seçili

  static const List<Widget> _widgetOptions = <Widget>[
    ExpensesPage(),
    GaragePage(),
    ProfilePage(),
  ];

  static const List<String> _titles = <String>[
    'EXPENSES',
    'GARAGE',
    'PROFILE',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
            child: Text(
          _titles[_selectedIndex],
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        )),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.garage),
            label: 'Garage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
