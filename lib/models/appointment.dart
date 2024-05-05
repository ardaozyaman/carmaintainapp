import 'package:carmaintainapp/models/users/enums/appointment_state.dart';

import 'car.dart';

class Appointment {
  int? id;
  int customerId;
  int? employeeId;
  int carId;
  String appointmentDate;
  String description;
  AppointmentState state;
  Car? car;

  Appointment(
      {this.id,
      required this.customerId,
      required this.carId,
      this.employeeId,
      required this.appointmentDate,
      required this.description,
      this.state = AppointmentState.waiting,
      this.car});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'carId': carId,
      'appointmentDate': appointmentDate,
      'state' : state.asString,
      'description': description,
    };
  }

  static Appointment fromMap(Map<String, dynamic> map) {
    return Appointment(
        id: map['id'],
        customerId: map['customerId'],
        carId: map['carId'],
        appointmentDate: map['appointmentDate'],
        state: StateExtension.fromString(map['state']),
        description: map['description']);
  }
}
