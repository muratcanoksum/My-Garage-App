// ignore_for_file: prefer_is_empty, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/material.dart';

import 'db_helper.dart';

class GaragePage extends StatefulWidget {
  const GaragePage({super.key});

  @override
  State<GaragePage> createState() => _GaragePageState();
}

DbHelper dbHelper = DbHelper();

List<Map<String, dynamic>> data = [];
List<Map<String, dynamic>> data2 = [];
List<Map<String, dynamic>> data3 = [];

class _GaragePageState extends State<GaragePage> {
  Future<void> getCarData() async {
    await dbHelper.open();
    data = await dbHelper.getCarData();
    setState(() {});
  }

  Future<void> getNotificationData() async {
    await dbHelper.open();
    data2 = await dbHelper.getNotificationData();
    setState(() {});
  }

  Future<void> getExpenseData() async {
    await dbHelper.open();
    data3 = await dbHelper.getExpenseData();
    setState(() {});
  }

  List<Map<String, dynamic>> filterByCarId(
      int carId, List<Map<String, dynamic>> dataList) {
    return dataList.where((item) => item['carId'] == carId).toList();
  }

  @override
  void initState() {
    super.initState();
    getCarData();
    getNotificationData();
    getExpenseData();
  }

  @override
  Widget build(BuildContext context) {
    return data.length == 0
        ? Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, // Metni ortala
              children: [
                Text(
                  "It's empty so far.\nAdd your cars!\nIn the 'Expenses' section, you can specify your car expenses.\nIn the 'Profile' section, you can download a driver's license and car insurance.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                )
              ],
            ),
          )
        : SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (int i = 0; i < data.length; i++)
                    Column(
                      children: [
                        Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white10,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(data[i]["make"],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w900)),
                                        Text(
                                          data[i]["model"],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Image.asset(
                                          "assets/${data[i]["carBody"].toString().toLowerCase()}.png",
                                          fit: BoxFit.contain,
                                          width: (MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              6),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Volume",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w900)),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/engine.png",
                                              fit: BoxFit.contain,
                                              width: (MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  10),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              data[i]["volume"],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w800),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text("Drive",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w900)),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/drive.png",
                                              fit: BoxFit.contain,
                                              width: (MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  10),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              data[i]["drive"],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w800),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Fuel",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w900)),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/fuel.png",
                                              fit: BoxFit.contain,
                                              width: (MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  12),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              data[i]["gasolineType"],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w800),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text("Gearing",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w900)),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/gear.png",
                                              fit: BoxFit.contain,
                                              width: (MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  10),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              data[i]["transmission"],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w800),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Capacity",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w900)),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/capacity.png",
                                              fit: BoxFit.contain,
                                              width: (MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  10),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              data[i]["power"],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w800),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text("Engine Type",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w900)),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/engine.png",
                                              fit: BoxFit.contain,
                                              width: (MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  10),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              data[i]["engineType"],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w800),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Expenses",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        Column(
                          children: [
                            for (int k = 0;
                                k < filterByCarId(data[i]["id"], data3).length;
                                k++)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      filterByCarId(data[i]["id"], data3)[k]
                                          ["expenseName"],
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white)),
                                  Text(
                                    "- ${filterByCarId(data[i]["id"], data3)[k]["expensePrice"]}\$",
                                    style: TextStyle(color: Colors.red),
                                  )
                                ],
                              )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Notifications",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        Column(
                          children: [
                            for (int j = 0;
                                j < filterByCarId(data[i]["id"], data2).length;
                                j++)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "${filterByCarId(data[i]["id"], data2)[j]["nameNoti"]}",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white)),
                                  Text(
                                    "${filterByCarId(data[i]["id"], data2)[j]["dateTime"]}",
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              )
                          ],
                        )
                      ],
                    ),
                ],
              ),
            ),
          );
  }
}
