import 'package:carmaintainapp/data/dbhelper.dart';
import 'package:carmaintainapp/models/appointment.dart';
import 'package:carmaintainapp/models/car.dart';
import 'package:carmaintainapp/pages/user/user_control_page.dart';
import 'package:flutter/material.dart';

class NewAppointmentPage extends StatefulWidget {
  const NewAppointmentPage({super.key});

  @override
  State createState() => _NewAppointmentPageState();
}

class _NewAppointmentPageState extends State<NewAppointmentPage> {
  static final TextEditingController _dateController = TextEditingController();
  static final TextEditingController _brandController = TextEditingController();
  static final TextEditingController _modelController = TextEditingController();
  static final TextEditingController _issueController = TextEditingController();
  static final TextEditingController _licenseIdController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _dateController,
              readOnly: true,
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  setState(() {
                    _dateController.text =
                        selectedDate.toString().split(' ')[0];
                  });
                }
              },
              decoration: const InputDecoration(
                labelText: 'Randevu Tarihi',
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _brandController,
              decoration: const InputDecoration(
                labelText: 'Araç Markası',
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _modelController,
              decoration: const InputDecoration(
                labelText: 'Araç Modeli',
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _licenseIdController,
              decoration: const InputDecoration(
                labelText: 'Araç Plakası',
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _issueController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                labelText: 'Sorun',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: newAppointment,
              child: const Text('Randevu Oluştur'),
            ),
          ],
        ),
      ),
    );
  }

  void newAppointment() async {
    DbHelper dbHelper = DbHelper();

    Car car = Car(
        customerId: loggedInCustomer!.id!,
        licenseId: _licenseIdController.text,
        brand: _brandController.text,
        modelName: _modelController.text);
    var carId = await dbHelper.insertCar(car);
    car.id = carId;

    Appointment appointment = Appointment(
        carId: carId,
        customerId: loggedInCustomer!.id!,
        appointmentDate: _dateController.text,
        description: _issueController.text,
        car: car);
    var appId = await dbHelper.insertAppointment(appointment);
    appointment.id = appId;

    loggedInCustomer!.cars.add(car);

    loggedInCustomer!.appointments.add(appointment);
  }
}
