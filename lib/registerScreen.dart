import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:metublind/main.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';


void main() {
  runApp(registerScreen());
}

class registerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pinkAccent[100],
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              ); // Burada Navigator.pop kullanarak bir önceki sayfaya geri dönüyoruz
            },
          ),
        ),
        body: UserForm(),
      ),
    );
  }
}



class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  int _selectedOption = 0;
  int _selectedOption2 = 0;
  DateTime? _selectedDate;

  void _saveUserInformation() async{
    // Kullanıcı bilgilerini veritabanına kaydetme işlemi
    String username = _usernameController.text;
    String password = _passwordController.text;
    int gender = _selectedOption;
    int interest = _selectedOption2;
    DateTime? dateOfBirth = _selectedDate;


    print(username);
    print(password);
    print(gender);
    print(interest);
    print(dateOfBirth);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String dob_string = formatter.format(dateOfBirth!);
    print(dob_string); // something like 2013-04-20

    if(username == "" || password == "" || gender == 0 || interest == 0 || dateOfBirth == null){
      Fluttertoast.showToast(msg: "Please fill all the form");
    }
    else{
      sendData(username, password, gender, interest, dob_string); // Veritabanına kaydetme işlemi burada gerçekleştirilir
    }



    // Bilgiler kaydedildikten sonra giriş alanlarını temizleyin
    _usernameController.clear();
    _passwordController.clear();
    _selectedDate = null;

    // Sayfayı sıfırlayarak, kullanıcı bilgilerinin ekranın herhangi bir yerinde gözükmesini önleyin
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => registerScreen()),
    );
  }


  Future<void> sendData(username,password,gender, interest, dob_string) async {
    try{
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse('https://blind-metu-rest-api.onrender.com/register');

      Map body = {
        "username" : username,
        "password": password,
        "gender": gender,
        "date_of_birth" : dob_string,
        "sexual_interest" : interest
      };
      http.Response response = await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 201) {
        Fluttertoast.showToast(msg: "User created successfully");
      }
      else if (response.statusCode == 400) {

        Fluttertoast.showToast(msg: "Bad request: ${response.reasonPhrase}");
        // Handle other specific error codes as needed
      } else if (response.statusCode == 409) {

        Fluttertoast.showToast(msg: "User already exist: ${response.reasonPhrase}");
        // Handle other specific error codes as needed
      } else if(response.statusCode == 422){

        Fluttertoast.showToast(msg: "Error: ${response.reasonPhrase}");
        // Handle other general errors
      }
    }
    catch (e) {}

  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome!'),
        backgroundColor: Colors.pinkAccent[100],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              SizedBox(height: 5),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              SizedBox(height: 35),

              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Gender',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: RadioListTile<int>(
                            title: Text(
                              'M',
                              style: TextStyle(fontSize: 15),
                            ),
                            value: 1,
                            groupValue: _selectedOption,
                            onChanged: (int? value) {
                              setState(() {
                                _selectedOption = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: RadioListTile<int>(
                            title: Text(
                              'F',
                              style: TextStyle(fontSize: 15),
                            ),
                            value: 2,
                            groupValue: _selectedOption,
                            onChanged: (int? value) {
                              setState(() {
                                _selectedOption = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),




              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Sexual Interest',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<int>(
                          title: Text(
                            'M',
                            style: TextStyle(fontSize: 15),
                          ),
                          value: 1,
                          groupValue: _selectedOption2,
                          onChanged: (int? value) {
                            setState(() {
                              _selectedOption2 = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<int>(
                          title: Text(
                            'F',
                            style: TextStyle(fontSize: 15),
                          ),
                          value: 2,
                          groupValue: _selectedOption2,
                          onChanged: (int? value) {
                            setState(() {
                              _selectedOption2 = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<int>(
                          title: Text(
                            'All',
                            style: TextStyle(fontSize: 15),
                          ),
                          value: 3,
                          groupValue: _selectedOption2,
                          onChanged: (int? value) {
                            setState(() {
                              _selectedOption2 = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Date of Birth',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    child: Text(
                      style: TextStyle(fontSize: 20),
                      _selectedDate != null
                          ? 'Selected Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                          : 'Click to Enter Birth Date! ',
                    ),
                  ),
                ],
              ),







              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _saveUserInformation,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                ),
                child: Text(
                  'Sign Up!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.pinkAccent[100],
    );
  }
}


