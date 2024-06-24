// ignore_for_file: prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toautoapp/notification.dart';
import 'garage_edit.dart';
import 'home.dart';

String imgpath = 'assets/profile.png';
String name = "********";
String birthday = "********";
bool canWe = false;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    getData().then((_) {
      setState(() {}); // Güncelleme için setState kullanılıyor.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 6,
                  height: MediaQuery.of(context).size.width / 6,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(77, 24, 24, 1),
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: canWe
                        ? Image.file(File(imgpath))
                        : Image.asset(imgpath),
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      birthday,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.edit, color: Colors.white),
                  title: Text('Garage edit',
                      style: TextStyle(color: Colors.white)),
                  trailing: Icon(Icons.arrow_forward, color: Colors.white),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GarageEditPage(),
                      ),
                    );
                  },
                ),
                Divider(color: Colors.grey),
                ListTile(
                  leading: Icon(Icons.notifications, color: Colors.white),
                  title: Text('Notification',
                      style: TextStyle(color: Colors.white)),
                  trailing: Icon(Icons.arrow_forward, color: Colors.white),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> getData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  name = prefs.getString("name")!;
  birthday = prefs.getString("birthday")!;
  imgpath = prefs.getString("photo")!;
  canWe = true;
}
