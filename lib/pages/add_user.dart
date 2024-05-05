import 'package:carmaintainapp/data/dbhelper.dart';
import 'package:carmaintainapp/models/users/customer.dart';
import 'package:carmaintainapp/models/users/employee.dart';
import 'package:carmaintainapp/models/users/enums/user_type.dart';
import 'package:flutter/material.dart';

import '../models/users/user.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  UserType? _selectedType;
  User? user;
  void _register() {
    String username = _usernameController.text;
    String surname = _surnameController.text;
    String pass = _passwordController.text;
    String mail = _mailController.text;
    String phone = _phoneController.text;
    if (_selectedType == UserType.employee) {
      user = Employee(
          id: null,
          name: username,
          surname: surname,
          pass: pass,
          mail: mail,
          phone: phone,
          type: _selectedType!.asString);
    }
    if (_selectedType == UserType.customer) {
      user = Customer(
          id: null,
          name: username,
          surname: surname,
          pass: pass,
          mail: mail,
          phone: phone,
          type: _selectedType!.asString);
    }
    if (user != null) {
      DbHelper dbHelper = DbHelper();
      dbHelper.insertUserData(user!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kayıt Ol'),
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
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Adı'),
                ),
                TextField(
                  controller: _surnameController,
                  decoration: const InputDecoration(labelText: 'SoyAdı'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'pass'),
                ),
                TextField(
                  controller: _mailController,
                  decoration: const InputDecoration(labelText: 'mail'),
                ),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Telefon'),
                  keyboardType: TextInputType.phone,
                ),
                DropdownButton<UserType>(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  hint: const Text("kullanıcı tipi"),
                  enableFeedback: false,
                  value: _selectedType,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedType = newValue!;
                    });
                  },
                  items: UserType.values
                      .map<DropdownMenuItem<UserType>>((userType) {
                    return DropdownMenuItem(
                        value: userType, child: Text(userType.asString));
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: _register,
                  child: const Text('Kayıt Ol'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
