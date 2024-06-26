/****************************************************************************
 **                              DÜZCE ÜNİVERSİTESİ
 **                          LİSANSÜSTÜ EĞİTİM ENSTİTÜSÜ
 **                       BİLGİSAYAR MÜHENDİLİĞİ ANABİLİM DALI
 **                       ÖĞRENCİ ADI :          ARDA ÖZYAMAN
 **                       ÖĞRENCİ NUMARASI :     2345007016
 **
 ****************************************************************************/
import 'package:carmaintainapp/pages/employee/on_prgress_appointments_employee.dart';
import 'package:flutter/material.dart';
import '../../models/users/employee.dart';
import '../../models/users/enums/appointment_state.dart';
import 'waiting_appointments_employee.dart';

Employee? loggedInEmployee;

class EmployeeControlPanel extends StatefulWidget {
  const EmployeeControlPanel({super.key});

  @override
  State createState() => _ControlPanelState();
}

class _ControlPanelState extends State<EmployeeControlPanel> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const InProgressAppointmentsPage(),
    const EmployeeAppointmentsPage(states: [AppointmentState.waiting]),
    const EmployeeAppointmentsPage(states: [AppointmentState.finished,AppointmentState.cancelled]),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Araba Bakım Kontrol Paneli'),
      ),
      body: Center(
        child: _screens.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.car_crash),
            label: 'İşlemdeki Randevular',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range_rounded),
            label: 'Bekleyen Randevular',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range_rounded),
            label: 'Geçmiş Randevular',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final String title;

  const PlaceholderWidget(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 30),
      ),
    );
  }
}
