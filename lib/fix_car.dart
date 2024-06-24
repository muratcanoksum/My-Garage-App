// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toautoapp/db_helper.dart';

import 'home.dart';

class FixCarForm extends StatefulWidget {
  final int carId;
  const FixCarForm({super.key, required this.carId});

  @override
  State<StatefulWidget> createState() => _FixCarFormState();
}

class _FixCarFormState extends State<FixCarForm> {
  final _formKey = GlobalKey<FormState>();
  String selectedCarBody = 'Van';

  final makeController = TextEditingController();
  final modelController = TextEditingController();
  final volumeController = TextEditingController();
  final gasolineTypeController = TextEditingController();
  final powerController = TextEditingController();
  final driveController = TextEditingController();
  final transmissionController = TextEditingController();
  final engineTypeController = TextEditingController();

  bool _isButtonEnabled = false;

  final carBodies = [
    'Van',
    'Hatchback',
    'Sportcar',
    'Coupe',
    'Sedan',
    'Universal',
    'Cabriolet',
    'SUV',
    'Jeep'
  ];
  DbHelper dbHelper = DbHelper();
  List<Map<String, dynamic>> carData = [];

  @override
  void initState() {
    super.initState();
    makeController.addListener(_checkFormValidity);
    modelController.addListener(_checkFormValidity);
    volumeController.addListener(_checkFormValidity);
    gasolineTypeController.addListener(_checkFormValidity);
    powerController.addListener(_checkFormValidity);
    driveController.addListener(_checkFormValidity);
    transmissionController.addListener(_checkFormValidity);
    engineTypeController.addListener(_checkFormValidity);
    dbHelper.open();
    getDataCar();
  }

  Future<void> getDataCar() async {
    await dbHelper.open();
    carData = await dbHelper.getCarData();
    setState(() {
      for (var test in carData) {
        if (test["id"] == widget.carId) {
          makeController.text = test["make"];
          modelController.text = test["model"];
          volumeController.text = test["volume"];
          gasolineTypeController.text = test["gasolineType"];
          powerController.text = test["power"];
          driveController.text = test["drive"];
          transmissionController.text = test["transmission"];
          engineTypeController.text = test["engineType"];
          selectedCarBody = test["carBody"];
        }
      }
    });
  }

  void _checkFormValidity() {
    setState(() {
      _isButtonEnabled = makeController.text.isNotEmpty &&
          modelController.text.isNotEmpty &&
          volumeController.text.isNotEmpty &&
          gasolineTypeController.text.isNotEmpty &&
          powerController.text.isNotEmpty &&
          driveController.text.isNotEmpty &&
          transmissionController.text.isNotEmpty &&
          engineTypeController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    makeController.dispose();
    modelController.dispose();
    volumeController.dispose();
    gasolineTypeController.dispose();
    powerController.dispose();
    driveController.dispose();
    transmissionController.dispose();
    engineTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Garage Edit', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter your car information:",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          buildTextField(
                              'Enter the make of the car', makeController),
                          buildTextField(
                              'Enter the car model', modelController),
                          buildTextField(
                              'Enter the volume of the car', volumeController),
                          buildTextField(
                              'Enter the type of gasoline of the car',
                              gasolineTypeController),
                          buildTextField(
                              'Enter the car\'s power', powerController),
                          buildTextField(
                              'Enter the vehicle\'s drive', driveController),
                          buildTextField('Enter the vehicle\'s transmission',
                              transmissionController),
                          buildTextField('Enter the type of car engine',
                              engineTypeController),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Choose a car body:',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.5,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: carBodies.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCarBody = carBodies[index];
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: selectedCarBody == carBodies[index]
                                  ? Colors.red[900]
                                  : Colors.grey[800],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/${carBodies[index].toLowerCase()}.png",
                                    width: 80,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    carBodies[index],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isButtonEnabled
                              ? () {
                                  if (_formKey.currentState!.validate()) {
                                    dbHelper.updateCarData(
                                        widget.carId,
                                        makeController.text,
                                        modelController.text,
                                        volumeController.text,
                                        gasolineTypeController.text,
                                        powerController.text,
                                        driveController.text,
                                        transmissionController.text,
                                        engineTypeController.text,
                                        selectedCarBody);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                const Home())));
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isButtonEnabled
                                ? Colors.red[900]
                                : Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Edit Car',
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
                    ),
                    SizedBox(height: 15),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            dbHelper.deleteCarData(widget.carId);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => const Home())));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Delete Car',
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
                    ),
                  ],
                ),
              ),
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
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
      ),
    );
  }
}
