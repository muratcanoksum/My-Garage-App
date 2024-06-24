// ignore_for_file: unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:toautoapp/fix_car.dart';
import 'package:toautoapp/profile.dart';

import 'add_car.dart';
import 'db_helper.dart';
import 'expense.dart';
import 'garage.dart';
import 'home.dart';

class GarageEditPage extends StatelessWidget {
  const GarageEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Garage edit', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: GarageEditBody(), // Body olarak yeni Stateless widget kullanılıyor
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white,
        currentIndex: 2,
        items: const [
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
        onTap: (index) {
          switch (index) {
            case 0:
              Home.selectedIndex = 0;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
                (Route<dynamic> route) => false,
              );
              break;
            case 1:
              Home.selectedIndex = 1;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
                (Route<dynamic> route) => false,
              );
              break;
            case 2:
              Home.selectedIndex = 2;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
                (Route<dynamic> route) => false,
              );
              break;
          }
        },
      ),
    );
  }
}

List<Map<String, dynamic>> data = [];

class GarageEditBody extends StatefulWidget {
  const GarageEditBody({super.key});

  @override
  State<StatefulWidget> createState() => _GarageEditBodyState();
}

class _GarageEditBodyState extends State<GarageEditBody> {
  Future<void> getCarData() async {
    DbHelper dbHelper = DbHelper();
    await dbHelper.open();
    data = await dbHelper.getCarData();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCarData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Wrap(
                children: [
                  for (int i = 0; i < data.length; i++)
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      margin: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Text(data[i]["make"],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900)),
                              Text(
                                data[i]["model"],
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Image.asset(
                                "assets/${data[i]["carBody"].toString().toLowerCase()}.png",
                                fit: BoxFit.contain,
                                width: (MediaQuery.of(context).size.width / 4),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FixCarForm(
                                              carId: data[i]["id"])));
                                },
                                child: Icon(
                                  Icons.edit_note,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CarForm(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(10.0),
                backgroundColor: Colors.red,
              ),
              child: Text('Add car',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900)),
            ),
          ),
        ],
      ),
    );
  }
}
