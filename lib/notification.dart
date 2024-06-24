// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:flutter/material.dart';
import 'package:toautoapp/db_helper.dart';
import 'package:toautoapp/home.dart';
import 'package:toautoapp/notification_helper.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<StatefulWidget> createState() => _NotificationState();
}

List<Map<String, dynamic>> data = [];
List<Map<String, dynamic>> data2 = [];

DbHelper dbHelper = DbHelper();

List<String> carId = [];
String selectedCarId = '1';
bool _isButtonEnabled = false;

class _NotificationState extends State<NotificationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    _nameController.addListener((_checkFormValidity));
    _dateController.addListener((_checkFormValidity));
    listenToNotifications();
    super.initState();
    getData();
  }

  int findIndexById(int id, List<Map<String, dynamic>> data) {
    for (int i = 0; i < data.length; i++) {
      if (data[i]['id'] == id) {
        return i;
      }
    }
    // Eğer listede ilgili id'ye sahip bir eleman bulunamazsa -1 döndürürüz.
    return -1;
  }

  //  to listen to any notification clicked or not
  listenToNotifications() {
    print("Listening to notification");
    LocalNotifications.onClickNotification.stream.listen((event) {
      print(event);
      Navigator.pushNamed(context, '/', arguments: event);
    });
  }

  Future<void> getData() async {
    await dbHelper.open();
    data = await dbHelper.getCarData();
    List<String> carIds = data.map((car) => car['id'].toString()).toList();
    setState(() {
      carId = carIds;
    });
  }

  Future<void> getNotificationData() async {
    await dbHelper.open();
    data2 = await dbHelper.getNotificationData();
  }

  String addLeadingZero(int value) {
    if (value < 10) {
      return '0$value';
    } else {
      return '$value';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dateController.text =
            "${addLeadingZero(picked.day)}.${addLeadingZero(picked.month)}.${picked.year}";
      });
    }
  }

  DateTime returnDateTime(String dateG) {
    List<String> dateParts = dateG.split('.');
    int day = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);
    DateTime dateTime = DateTime(year, month, day, 09, 00);
    return dateTime;
  }

  void _checkFormValidity() {
    setState(() {
      _isButtonEnabled =
          _nameController.text.isNotEmpty && _dateController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text(
            "Notification",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Enter notification informaiton:",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            height: 3),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          children: [
                            TextField(
                              controller: _nameController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.transparent,
                                hintText: 'Enter the name of the notification',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                            TextField(
                              controller: _dateController,
                              style: TextStyle(color: Colors.white),
                              readOnly: true,
                              onTap: () => _selectDate(context),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.transparent,
                                hintText: 'Enter the date of the notification',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Choose your car:",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            height: 5),
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: PageScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: carId.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCarId = carId[index];
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: selectedCarId == carId[index]
                                  ? Colors.red[900]
                                  : Colors.grey[800],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      data[index]["make"],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      data[index]["model"],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w100,
                                          height: 2),
                                    ),
                                    Image.asset(
                                      "assets/${data[index]["carBody"].toString().toLowerCase()}.png",
                                      width:
                                          MediaQuery.of(context).size.width / 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _isButtonEnabled
                            ? [
                                Color.fromRGBO(214, 39, 39, 1),
                                Color.fromRGBO(157, 25, 25, 1),
                              ]
                            : [
                                const Color.fromARGB(255, 45, 45, 45),
                                const Color.fromARGB(255, 45, 45, 45),
                              ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(
                          10), // Adjust the border radius if needed
                    ),
                    child: ElevatedButton(
                      onPressed: _isButtonEnabled
                          ? () async {
                              if (_isButtonEnabled) {
                                dbHelper.addNotificationData(
                                    int.parse(selectedCarId),
                                    _nameController.text,
                                    _dateController.text);
                                await getNotificationData();
                                int indexs = findIndexById(
                                    int.parse(selectedCarId), data);
                                LocalNotifications.showScheduleNotification(
                                    id: data2.last["id"],
                                    title: "Car Notification",
                                    body:
                                        "Your car ${data[indexs]["make"]} ${data[indexs]["model"]} ${_nameController.text} date. Don't Forget!",
                                    payload: "None",
                                    scheduledDateTime:
                                        returnDateTime(_dateController.text));
                                Navigator.pop(context);
                              } else {
                                setState(() {
                                  _isButtonEnabled = _isButtonEnabled;
                                });
                              }
                            }
                          : () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8), // Match the border radius of the container
                        ),
                      ),
                      child: const Text(
                        "Add Notification",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          fontFamily: "Gilroy",
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
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
      ),
    );
  }
}
