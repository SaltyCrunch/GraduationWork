
import 'package:diplom_vlad/pages/Employee/EmployeeList.dart';
import 'package:diplom_vlad/pages/Employee/EmployeePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/adapters.dart';
import 'client/hive_names.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'models/employee.dart';
import 'pages/loginIn.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(EmployeeAdapter());

  await Hive.openBox<Employee>(HiveBoxes.employee);

  Hive.registerAdapter(CarAdapter());

  await Hive.openBox<Car>(HiveBoxes.car);

  Hive.registerAdapter(PathListAdapter());

  await Hive.openBox<PathList>(HiveBoxes.pathList);

  Hive.registerAdapter(StoreAdapter());

  await Hive.openBox<Store>(HiveBoxes.store);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        locale: const Locale("ru"),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', 'US'),
          Locale('ru', 'RUS'),
          // ... other locales the app supports
        ],
        home: Builder(builder: (BuildContext context) {
          return LoginIn();
        }));
  }
}
