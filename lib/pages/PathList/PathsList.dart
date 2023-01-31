import 'dart:developer';

import 'package:diplom_vlad/models/employee.dart';
import 'package:diplom_vlad/pages/PathList/EditPathList.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import '../../client/hive_names.dart';
import '../BottomNavBar.dart';
import '../Car/EditCar.dart';
import 'PathListPage.dart';
import '../Car/AddCar.dart';

class PathsList extends StatefulWidget {
  PathsList({Key key, this.employee, this.car}) : super(key: key);
  Employee employee;
  Car car;

  @override
  _PathsListState createState() => _PathsListState();
}

class _PathsListState extends State<PathsList> {

  bool _isSort = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavBar(
          employee: widget.employee,
        ),
        appBar: AppBar(
          title: Text("Путевые листы",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              )),
          backgroundColor: Color(0x6ea85100),
          actions: [
            IconButton(
              icon: Icon(
                Icons.sort,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                setState(() {
                  _isSort = !_isSort;
                });
              },
            ),
          ],
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        backgroundColor: Color(0xffFFF3E9),
        body: ValueListenableBuilder(
            valueListenable: Hive.box<Car>(HiveBoxes.car).listenable(),
            builder: (context, Box<Car> box, _) {

              return ValueListenableBuilder(
                valueListenable: Hive.box<PathList>(HiveBoxes.pathList).listenable(),
                builder: (context, Box<PathList> boxPaths, _) {
                  if (boxPaths.values.isEmpty) {
                    return Center(
                      child: Text("Путевых листов нет"),
                    );
                  }
                  List<PathList> lists = List.from(boxPaths.values);
                  lists.removeWhere((element) => element.numberCar != widget.car.numberCar);

                  if (_isSort) {
                    lists.sort((a, b) => b.date.compareTo(a.date));
                  }

                  return Column(children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(80, 20, 80, 0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Center(
                                child: Text(
                                  "№ ТС",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      fontFamily: "Ghotic"),
                                )),
                            Center(
                                child: Text(
                                  "Дата",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      fontFamily: "Ghotic"),
                                )),
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0x6ea85100)),
                        ),
                        child: ListView.builder(
                            itemCount: lists.length,
                            itemBuilder: (context, index) {
                              PathList res = lists[index];
                              return Dismissible(
                                background: Container(color: Colors.red),
                                key: UniqueKey(),
                                onDismissed: (direction) {

                                  showDialog(
                                      context: context,
                                      builder: (BuildContext ctx) {
                                        return AlertDialog(
                                          title: const Text('Удаление'),
                                          content: const Text('Вы уверены, что хотите удалить путевой лист?'),
                                          actions: [
                                            // The "Yes" button
                                            TextButton(
                                                onPressed: () {
                                                  // Remove the box
                                                  res?.delete();
                                                  Navigator.pop(context);
                                                  // Close the dialog

                                                },
                                                child: const Text('Да')),
                                            TextButton(
                                                onPressed: () {
                                                  // Close the dialog
                                                  setState(() {

                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Нет'))
                                          ],
                                        );
                                      });

                                },
                                child: Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(0, 30, 0, 0),
                                  child: MaterialButton(
                                    onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PathListPage(
                                                        employee: widget
                                                            .employee,
                                                        pathList: res)));
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                                  3,
                                              child: Center(
                                                child: Text(
                                                  res.numberCar,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: "Ghotic",
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const VerticalDivider(
                                              width: 6,
                                              thickness: 1.5,
                                              color: Color(0x6ea85100),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                                  3,
                                              child: Center(
                                                child: Text(
                                                  res.date == null ? "" : res.date.month.toString() + "-" + res.date.day.toString() + "-" + res.date.year.toString(),
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: "Ghotic",
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          height: 6,
                                          thickness: 1.5,
                                          color: Color(0x6ea85100),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ]);
                },
              );
            }));
  }
}