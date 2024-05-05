/****************************************************************************
 **                              DÜZCE ÜNİVERSİTESİ
 **                          LİSANSÜSTÜ EĞİTİM ENSTİTÜSÜ
 **                       BİLGİSAYAR MÜHENDİLİĞİ ANABİLİM DALI
 **                       ÖĞRENCİ ADI :          ARDA ÖZYAMAN
 **                       ÖĞRENCİ NUMARASI :     2345007016
 **
 ****************************************************************************/
import 'package:carmaintainapp/data/dbhelper.dart';
import 'package:carmaintainapp/models/users/enums/appointment_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/appointment.dart';
import '../../models/car.dart';

class EmployeeAppointmentsPage extends StatefulWidget {
  const EmployeeAppointmentsPage({super.key, required this.states});
  final List<AppointmentState> states;
  @override
  State<EmployeeAppointmentsPage> createState() =>
      _EmployeeAppointmentsPageState();
}

class _EmployeeAppointmentsPageState extends State<EmployeeAppointmentsPage> {
  @override
  Widget build(BuildContext context) {
    var states = widget.states;
    return Scaffold(
      body: FutureBuilder(
        future: _getAppointments(states),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _listBuilder(snapshot.data!, states);
          } else {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: LinearProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _listBuilder(
      List<Appointment> appointments, List<AppointmentState> states) {
    return appointments.isEmpty
        ? const Center(
            child: Text('Randevu bulunamadı'),
          )
        : ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  child: ListTile(
                      titleAlignment: ListTileTitleAlignment.center,
                      title: Text(
                        'Randevu Tarihi: ${appointment.appointmentDate}',
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Araç Markası: ${appointment.car!.brand}'),
                          Text('Araç Modeli: ${appointment.car!.modelName}'),
                          Text('Açıklama: ${appointment.description}'),
                        ],
                      ),
                      trailing: _trailing(appointment, states),
                      leading: _leading(appointment.state)),
                ),
              );
            },
          );
  }

  void _acceptAppointment(Appointment appointment) async {
    appointment.state = AppointmentState.inProgress;
    DbHelper dbHelper = DbHelper();
    await dbHelper.updateAppointment(appointment);
  }

  void _rejectAppointment(Appointment appointment) async {
    appointment.state = AppointmentState.cancelled;
    DbHelper dbHelper = DbHelper();
    await dbHelper.updateAppointment(appointment);
  }

  _trailing(Appointment appointment, List<AppointmentState> states) {
    if (states.contains(AppointmentState.cancelled) ||
        states.contains(AppointmentState.finished)) {
      return IconButton(
        icon: const Icon(Icons.delete_forever, color: Colors.green),
        onPressed: () {
          _deleteAppointment(appointment);
          setState(() {
            _getAppointments(states);
          });
        },
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.check, color: Colors.green),
          onPressed: () {
            _acceptAppointment(appointment);
            setState(() {
              _getAppointments(states);
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.cancel, color: Colors.red),
          onPressed: () {
            _rejectAppointment(appointment);
            setState(() {
              _getAppointments(states);
            });
          },
        ),
      ],
    );
  }

  Widget _leading(AppointmentState state) {
    Icon icon;
    String text = state.asString;
    if (state == AppointmentState.waiting) {
      icon = const Icon(CupertinoIcons.clock_solid);
    } else if (state == AppointmentState.inProgress) {
      icon = const Icon(Icons.car_repair_rounded);
    } else if (state == AppointmentState.finished) {
      icon = const Icon(
        Icons.done_all_rounded,
        color: Colors.green,
      );
    } else {
      icon = const Icon(Icons.cancel, color: Colors.redAccent);
    }
    return Column(
      children: [icon, Text(text)],
    );
  }

  /*Future<List<Appointment>> _getAppointments(
      List<AppointmentState> states) async {
    DbHelper dbHelper = DbHelper();
    var list = await dbHelper.getAllAppointments();
    List<Appointment> listWaiting = list.where((element) {
      return element.state == states;
    }).toList();
    var cars = await dbHelper.getAllCars();
    return _mergeAppointmentsWithCars(listWaiting, cars);
  }*/


  Future<List<Appointment>> _getAppointments(
      List<AppointmentState> states) async {
    DbHelper dbHelper = DbHelper();
    var list = await dbHelper.getAllAppointments();
    List<Appointment> filteredAppointments = [];

    for (var state in states) {
      var appointmentsWithState =
      list.where((appointment) => appointment.state == state);
      filteredAppointments.addAll(appointmentsWithState);
    }

    var cars = await dbHelper.getAllCars();
    return _mergeAppointmentsWithCars(filteredAppointments, cars);
  }


  List<Appointment> _mergeAppointmentsWithCars(
    List<Appointment> appointments,
    List<Car> cars,
  ) {
    List<Appointment> appointmentsWithCars = [];

    for (var appointment in appointments) {
      Car car = cars.firstWhere((car) => car.id == appointment.carId);

      appointment.car = car;
      appointmentsWithCars.add(appointment);
    }

    return appointmentsWithCars;
  }
}


void _deleteAppointment(Appointment appointment) {
  DbHelper dbHelper = DbHelper();
  dbHelper.deleteAppointment(appointment.id!);
}
