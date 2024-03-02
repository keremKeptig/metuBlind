import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:metublind/main.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(registerScreen());
}

class registerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

  void _saveUserInformation() async{
    // Kullanıcı bilgilerini veritabanına kaydetme işlemi
    String username = _usernameController.text;
    String password = _passwordController.text;
    int gender = _selectedOption;


    print(username.runtimeType);
    print(password.runtimeType);
    print(gender.runtimeType);

    sendData(username, password, gender); // Veritabanına kaydetme işlemi burada gerçekleştirilir



   // Bilgiler kaydedildikten sonra giriş alanlarını temizleyin
    _usernameController.clear();
    _passwordController.clear();

    // Sayfayı sıfırlayarak, kullanıcı bilgilerinin ekranın herhangi bir yerinde gözükmesini önleyin
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => registerScreen()),
    );
  }


  Future<void> sendData(username,password,gender) async {
    try{
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse('https://blind-metu-rest-api.onrender.com/register');

      Map body = {
        "username" : username,
        "password": password,
        "gender": gender
      };
      http.Response response = await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if(json['code'] == 0) {
          print("okey");
        }
      }
    }
    catch (e) {}





    // final response = await http.post(
    //   var headers:
    //   Uri.parse('https://blind-metu-rest-api.onrender.com/register'),
    //   body: {
    //
    //   },
    // );

    // if (response.statusCode == 200) {
    //   print('Data sent successfully');
    // } else {
    //   print('Failed to send data. Status code: ${response.statusCode}');
    // }
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


            Row( // içinde radio buttonlar var
              children: [
                Expanded(
                  child: RadioListTile<int>(
                    title: Text('Male',
                        style: TextStyle(fontSize: 19),
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
                Expanded(
                  child: RadioListTile<int>(
                    title: Text('Female',
                    style: TextStyle(fontSize: 19)
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


