import 'package:carmaintainapp/models/users/enums/appointment_state.dart';
import 'package:carmaintainapp/pages/user/user_control_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomerAppointmentsPage extends StatelessWidget {
  CustomerAppointmentsPage({super.key});

  final appointments = loggedInCustomer!.appointments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: appointments.isEmpty
          ? const Center(
              child: Text('Randevu bulunamadı'),
            )
          : ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 2),
                  child: Card(
                    color: appointment.state == AppointmentState.cancelled ? Colors.redAccent : Colors.greenAccent,
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
                      trailing: trailing(appointment.state),
                      // Burada gerekirse listtile'a tıklanınca yapılacak işlemi ekleyebilirsiniz
                      onTap: () {
                        // ListTile'a tıklanınca yapılacak işlem
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }

  trailing(AppointmentState state) {
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
      icon = const Icon(Icons.cancel, color: Colors.black);
    }
    return Column(
      children: [icon, Text(text)],
    );
  }
}
