import 'dart:developer';

import 'package:diplom_vlad/models/employee.dart';
import 'package:diplom_vlad/pages/Car/CarPage.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import '../../client/hive_names.dart';
import '../../tools/utils.dart';
import '../BottomNavBar.dart';
import 'EditCar.dart';
import 'AddCar.dart';

class CarList extends StatefulWidget {
  CarList({Key key, this.employee}) : super(key: key);
  Employee employee;

  @override
  _CarListState createState() => _CarListState();
}

class _CarListState extends State<CarList> {
  List<Car> copyCars;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavBar(
          employee: widget.employee,
        ),
        appBar: AppBar(
          title: Text("Транспортные средства",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              )),
          backgroundColor: Color(0x6ea85100),
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
          actions: [
            Visibility(
              visible: widget.employee.post.compareTo("Администратор") == 0 ? true : false,
              child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddCar(employee: widget.employee)));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xffA85100),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            )
          ],
        ),
        backgroundColor: Color(0xffFFF3E9),
        body: ValueListenableBuilder(
            valueListenable: Hive.box<Car>(HiveBoxes.car).listenable(),
            builder: (context, Box<Car> box, _) {
              return ValueListenableBuilder(
                valueListenable: Hive.box<PathList>(HiveBoxes.pathList).listenable(),
                builder: (context, Box<PathList> boxPaths, _) {
                  if (box.values.isEmpty) {
                    return Center(
                      child: Text("Транспорта нет"),
                    );
                  }
                  List<Car> car = List.from(box.values.toList());
                  if(widget.employee.post.compareTo("Водитель") == 0) {
                    car.removeWhere((element) =>
                    element.employeeId != widget.employee.id);
                  }

                  return Column(children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
                      child: Container(
                        color: Color(0x6ea85100),
                        width: double.infinity,
                        height: 50,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                              hintText: 'Поиск',
                              hintStyle: TextStyle(
                                  color: Color(0xffE5E5E5),
                                  fontSize: 18,
                                  fontFamily: "Ghotic",
                                  fontWeight: FontWeight.w400)),
                          onChanged: (value) {
                            copyCars = List.from(car);
                            copyCars.removeWhere((element) => !element.numberCar
                                .toLowerCase()
                                .contains(value.toLowerCase()));
                            setState(() {});
                          },
                        ),
                      ),
                    ),
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
                              "Статус",
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
                            itemCount: copyCars == null
                                ? car.length
                                : copyCars.length,
                            itemBuilder: (context, index) {
                              Car res = copyCars == null
                                  ? car[index]
                                  : copyCars[index];
                              return Dismissible(
                                background: Container(color: Colors.red),
                                key: UniqueKey(),
                                onDismissed: (direction) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext ctx) {
                                        return AlertDialog(
                                          title: const Text('Удаление'),
                                          content: const Text('Вы уверены, что хотите удалить ТС?'),
                                          actions: [
                                            // The "Yes" button
                                            TextButton(
                                                onPressed: () {
                                                  // Remove the box
                                                  boxPaths.toMap().values.toList().removeWhere((element) => element.numberCar == res.numberCar);
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
                                              builder: (context) => CarPage(
                                                  employee: widget.employee,
                                                  car: res)));
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
                                                  res.status??"",
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
