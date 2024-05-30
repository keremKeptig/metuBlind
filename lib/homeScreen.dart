import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Add this import for HTTP requests
import 'package:metublind/matchScreen.dart';
import 'package:metublind/registerScreen.dart';
import 'package:metublind/signInScreen.dart';
import 'package:metublind/test_screen.dart';
import 'problemForm.dart';

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
              exit(0); // Use exit(0) to exit the app
            },
          ),
        ),
        body: homeForm(username: username),
      ),
    );
  }
}

class homeForm extends StatelessWidget {
  final String? username;

  const homeForm({Key? key, this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(r'C:\Users\userpc\Desktop\Android_studio\metu_blind\android\images\soulMate.jpg'
                ), // Adjust the asset path as needed
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => matchScreen(username: username)),
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
                  SizedBox(height: 20),
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