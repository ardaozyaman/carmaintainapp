/****************************************************************************
 **                              DÜZCE ÜNİVERSİTESİ
 **                          LİSANSÜSTÜ EĞİTİM ENSTİTÜSÜ
 **                       BİLGİSAYAR MÜHENDİLİĞİ ANABİLİM DALI
 **                       ÖĞRENCİ ADI :          ARDA ÖZYAMAN
 **                       ÖĞRENCİ NUMARASI :     2345007016
 **
 ****************************************************************************/

import 'dart:io';
import 'package:carmaintainapp/models/users/customer.dart';
import 'package:carmaintainapp/models/users/employee.dart';
import 'package:carmaintainapp/pages/add_user.dart';
import 'package:carmaintainapp/pages/employee/employee_control_page.dart';
import 'package:carmaintainapp/pages/user/user_control_page.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'data/dbhelper.dart';
import 'models/appointment.dart';
import 'models/car.dart';
import 'models/users/user.dart';

Future main() async {
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: "Servis Randevu Sistemi"),
        '/registration': (context) => const RegistrationPage(),
        '/employee panel': (context) => const EmployeeControlPanel(),
        '/customer panel': (context) => const CustomerControlPanel(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _mailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
        title: Text(widget.title,
            style: TextStyle(color: Theme.of(context).colorScheme.surface)),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 0.5,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextField(
                  controller: _mailController,
                  decoration: const InputDecoration(labelText: 'Mail'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Şifre'),
                ),
                ElevatedButton(
                  onPressed: _logIn,
                  child: const Text('Giriş Yap'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async =>
            await Navigator.pushNamed(context, "/registration"),
        tooltip: 'Yeni kayıt',
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add),
            Text("Yeni Kayıt", style: TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }

  void _logIn() async {
    DbHelper dbHelper = DbHelper();
    User? user = await dbHelper.getUserByEmail(_mailController.text);
    if (user!.pass == _passwordController.text) {
      print("giriş basarılı");
      if (user is Employee) {
        employeeLogIn(user, dbHelper);
      } else if (user is Customer) {
        await customerLogIn(user, dbHelper);
      }
    }
  }

  employeeLogIn(Employee user, DbHelper dbHelper) async {
    var appointments = await dbHelper.getAppointmentsByCustomerId(user.id!);
    var cars = await dbHelper.getAllCars();
    loggedInEmployee = user;
    user.cars = cars;
    var list = getAppointmentsWithCars(appointments, cars);
    if(list.isNotEmpty){
      user.appointments = list;
    }
    Navigator.pushNamed(context, '/employee panel');
  }

  customerLogIn(Customer user, DbHelper dbHelper) async {
    var appointments = await dbHelper.getAppointmentsByCustomerId(user.id!);
    var cars = await dbHelper.getCarsByCustomerId(user.id!);
    loggedInCustomer = user;
    user.cars = cars;
    var list = getAppointmentsWithCars(appointments, cars);
    if(list.isNotEmpty){
      user.appointments = list;
    }
    Navigator.pushNamed(context, '/customer panel');
  }

  List<Appointment> getAppointmentsWithCars(
      List<Appointment> appointments, List<Car> cars) {
    List<Appointment> appointmentsWithCars = [];

    for (var appointment in appointments) {
      Car car = cars.firstWhere((car) => car.id == appointment.carId);

      appointment.car = car;
      appointmentsWithCars.add(appointment);
    }

    return appointmentsWithCars;
  }
}
