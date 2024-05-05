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
import 'employee_appointment_details.dart';

class InProgressAppointmentsPage extends StatefulWidget {
  const InProgressAppointmentsPage({super.key});

  @override
  State<InProgressAppointmentsPage> createState() =>
      _EmployeeAppointmentsPageState();
}

class _EmployeeAppointmentsPageState extends State<InProgressAppointmentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _getAppointments(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _listBuilder(snapshot.data!);
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

  Widget _listBuilder(List<Appointment> appointments) {
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
                  color: appointment.state == AppointmentState.cancelled
                      ? Colors.redAccent
                      : Colors.greenAccent,
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
                    trailing: _trailing(appointment),
                    leading: _leading(appointment.state),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmployeeAppointmentDetailPage(
                            appointment: appointment,
                          ),
                        )),
                  ),
                ),
              );
            },
          );
  }

  void _acceptAppointment(Appointment appointment) async {
    appointment.state = AppointmentState.finished;
    DbHelper dbHelper = DbHelper();
    await dbHelper.updateAppointment(appointment);
  }

  void _rejectAppointment(Appointment appointment) async {
    appointment.state = AppointmentState.cancelled;
    DbHelper dbHelper = DbHelper();
    await dbHelper.updateAppointment(appointment);
  }

  _trailing(Appointment appointment) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.check, color: Colors.green),
          onPressed: () {
            _acceptAppointment(appointment);
            setState(() {
              _getAppointments();
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.cancel, color: Colors.red),
          onPressed: () {
            _rejectAppointment(appointment);
            setState(() {
              _getAppointments();
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

  Future<List<Appointment>> _getAppointments() async {
    DbHelper dbHelper = DbHelper();
    var list = await dbHelper.getAllAppointments();
    List<Appointment> listWaiting = list.where((element) {
      return element.state == AppointmentState.inProgress;
    }).toList();

    var cars = await dbHelper.getAllCars();

    return _mergeAppointmentsWithCars(listWaiting, cars);
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
