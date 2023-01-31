import 'dart:developer';

import 'package:diplom_vlad/models/employee.dart';
import 'package:diplom_vlad/pages/Employee/EditEmployee.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:hive_flutter/hive_flutter.dart';

import '../../client/hive_names.dart';
import '../Employee/AddEmployee.dart';
import 'AddStore.dart';
import '../BottomNavBar.dart';
import 'EditStore.dart';

class StoreList extends StatefulWidget {
  StoreList({Key key, this.employee}) : super(key: key);
  Employee employee;

  @override
  _StoreListState createState() => _StoreListState();
}

class _StoreListState extends State<StoreList> {
  List<Store> copyStore;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavBar(
        employee: widget.employee,
      ),
      appBar: AppBar(
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
          MaterialButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddStore(
                        employee: widget.employee,
                        state: setState,
                      )));
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
          )
        ],
      ),
      backgroundColor: Color(0xffFFF3E9),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Store>(HiveBoxes.store).listenable(),
        builder: (context, Box<Store> box, _) {
          if (box.values.isEmpty) {
            return Center(
              child: Text("Деталей нет"),
            );
          }
          /*Employee employee = box.getAt(0);
          box.clear();
          box.add(employee);*/
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
                    copyStore = List.from(box.values.toList());
                    copyStore.removeWhere((element) => !element.name
                        .toLowerCase()
                        .contains(value.toLowerCase()));
                    setState(() {});
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(60, 20, 60, 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Center(
                        child: Text(
                      "Наименование",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          fontFamily: "Ghotic"),
                    )),
                    Center(
                        child: Text(
                      "Количество",
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
                    itemCount: copyStore == null
                        ? box.values.length
                        : copyStore.length,
                    itemBuilder: (context, index) {
                      Store res = copyStore == null
                          ? box.getAt(index)
                          : copyStore[index];
                      return Dismissible(
                        background: Container(color: Colors.red),
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return AlertDialog(
                                  title: const Text('Удаление'),
                                  content: const Text('Вы уверены, что хотите удалить запчасть?'),
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
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditStore(
                                        employee: widget.employee,
                                        store: res,
                                      )));
                            },
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      child: Center(
                                        child: Text(
                                          res.name,
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
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              res.remains.toString(),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontFamily: "Ghotic",
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                IconButton(onPressed: () {
                                                  res.remains++;
                                                  res.save();
                                                }, icon: Icon(Icons.add, size: 15,)),
                                                IconButton(onPressed: () {
                                                  if (res.remains > 0) {
                                                    res.remains--;
                                                    res.save();
                                                  }
                                                }, icon: Icon(Icons.remove, size: 15)),
                                              ],
                                            ),

                                          ],
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
      ),
    );
  }
}
