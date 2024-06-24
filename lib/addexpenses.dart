// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:toautoapp/db_helper.dart';
import 'package:toautoapp/home.dart';

class AddExpenses extends StatefulWidget {
  const AddExpenses({super.key});

  @override
  State<StatefulWidget> createState() => _AddExpensesState();
}

List<String> carId = [];
List<Map<String, dynamic>> data = [];

DbHelper dbHelper = DbHelper();

String selectedCarId = '1';
bool _isButtonEnabled = false;

class _AddExpensesState extends State<AddExpenses> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener((_checkFormValidity));
    _costController.addListener((_checkFormValidity));
    getData();
  }

  void _checkFormValidity() {
    setState(() {
      _isButtonEnabled =
          _nameController.text.isNotEmpty && _costController.text.isNotEmpty;
    });
  }

  Future<void> getData() async {
    await dbHelper.open();
    data = await dbHelper.getCarData();
    List<String> carIds = data.map((car) => car['id'].toString()).toList();
    setState(() {
      carId = carIds;
      print(carId);
      print(data[0]);
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
            "Add Expenses",
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
                        "Enter expenses informaiton:",
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
                                hintText: 'Enter the name of the expenses',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                            TextField(
                              controller: _costController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.transparent,
                                hintText: 'Enter the cost',
                                suffix: Text("\$"),
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
                                      data[index]['make'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      data[index]['model'],
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
                          ? () {
                              if (_isButtonEnabled) {
                                dbHelper.addExpensesData(
                                    int.parse(selectedCarId),
                                    _nameController.text,
                                    _costController.text);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Home()));
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
                        "Add Expenses",
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
          currentIndex: 0,
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
