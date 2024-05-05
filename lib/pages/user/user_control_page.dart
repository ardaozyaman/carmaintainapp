/****************************************************************************
 **                              DÜZCE ÜNİVERSİTESİ
 **                          LİSANSÜSTÜ EĞİTİM ENSTİTÜSÜ
 **                       BİLGİSAYAR MÜHENDİLİĞİ ANABİLİM DALI
 **                       ÖĞRENCİ ADI :          ARDA ÖZYAMAN
 **                       ÖĞRENCİ NUMARASI :     2345007016
 **
 ****************************************************************************/

import 'package:flutter/material.dart';
import '../../models/users/customer.dart';
import 'current_appointments_user.dart';
import 'new_appointment.dart';

Customer? loggedInCustomer;

class CustomerControlPanel extends StatefulWidget {
  const CustomerControlPanel({super.key});

  @override
  State createState() => _ControlPanelState();
}

class _ControlPanelState extends State<CustomerControlPanel> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const NewAppointmentPage(),
    CustomerAppointmentsPage()
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
        title: Text("Hoş geldiniz ${loggedInCustomer!.name}"),
      ),
      body: Center(
        child: _screens.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.car_crash),
            label: 'Yeni Randevu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range_rounded),
            label: 'Mevcut Randevu',
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
