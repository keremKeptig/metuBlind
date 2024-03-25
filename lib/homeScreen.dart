import 'dart:io';

import 'package:flutter/material.dart';
import 'package:metublind/registerScreen.dart';
import 'package:metublind/signInScreen.dart';
import 'package:metublind/test_screen.dart';
import 'package:metublind/problemForm.dart';

void main() {
  runApp(homeScreen());
}

class homeScreen extends StatelessWidget {
  final String? username;
  const homeScreen({Key? key, this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pinkAccent[100],
          leading: IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => exit(1)),
              );
            },
          ),
        ),
        body: homeForm(username: username),
      ),
    );
  }
}

class homeForm extends StatelessWidget {
  final String? username; // ? -> null olabilir demek, final değişemez demek

  // Constructor'ı güncelleyin, kullanıcı adını parametre olarak alacak şekilde
  const homeForm({Key? key, this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(r'C:\Users\userpc\Desktop\Android_studio\metu_blind\android\images\soulMate.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end, // Align to the bottom
            children: [
              // Your existing code...

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space buttons evenly
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => signInScreen()),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.pink),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      ),
                    ),
                    child: Text(
                      'Matches',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => testScreen(username: username)),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                      ),
                    ),
                    child: Text(
                      'Tests',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20), // Add some space between buttons and "Contact Us" button

              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProblemScreen(username: username)),
                  );
                },
                icon: Icon(
                  Icons.contact_support,
                  color: Colors.blue,
                  size: 60,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
