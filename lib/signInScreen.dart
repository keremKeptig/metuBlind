import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:metublind/main.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(signInScreen());
}

class signInScreen extends StatelessWidget {
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


  void _saveUserInformation() async{
    // Kullanıcı bilgilerini veritabanına kaydetme işlemi
    String username = _usernameController.text;
    String password = _passwordController.text;


    print(username.runtimeType);
    print(password.runtimeType);

    sendData(username, password); // Veritabanına kaydetme işlemi burada gerçekleştirilir



    // Bilgiler kaydedildikten sonra giriş alanlarını temizleyin
    _usernameController.clear();
    _passwordController.clear();

  }


  Future<void> sendData(username,password) async {
    try{
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse('https://blind-metu-rest-api.onrender.com/login');

      Map body = {
        "username" : username,
        "password": password
      };
      http.Response response = await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 201) {
        print("amdsadsadsa");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
        );
      }else if(response.statusCode == 401){
        Fluttertoast.showToast(msg: "Invalid credentials");
      }else{
        Fluttertoast.showToast(msg: "Server Busy, Please try again");
      }
    }
    catch (e) {}

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


              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _saveUserInformation,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                ),
                child: Text(
                  'Sign In!',
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


