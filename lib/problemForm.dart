import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:metublind/homeScreen.dart';
import 'package:metublind/main.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';


void main() {
  runApp(ProblemScreen());
}
class ProblemScreen extends StatelessWidget {
  final String? username;
  const ProblemScreen({Key? key, this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Problem/Advice Form', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
          backgroundColor: Colors.pinkAccent[100],
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            // Arka plan resmi için Container kullanıyoruz
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(r'C:\Users\PC\StudioProjects\metublind\android\images\backgroundMain.png'), // Arka plan resmi buraya
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: ProblemForm(username: username),
            ),
          ],
        ),
      ),
    );
  }
}

class ProblemForm extends StatefulWidget {
  final String? username;
  const ProblemForm({Key? key, this.username}) : super(key: key);
  @override
  _ProblemFormState createState() => _ProblemFormState();
}

class _ProblemFormState extends State<ProblemForm> {
  TextEditingController _commentController = TextEditingController();

  void _sendComment(message, username) async {
    print(message);
    print(username);
    sendReport(message, username);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Comment sent: $message')),
    );
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(r'C:\Users\userpc\Desktop\Android_studio\metu_blind\android\images\backgroundMain.png'), // Arkaplandaki resmin yolunu belirtin
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 51.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'You can contact us by filling out the form! If you have any complaints or any elements of the application that have a negative impact on you, or if you want to send us your advice and opinions, you can fill out the following form!',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 35.0),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _commentController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Type your comment here...',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple, width: 10.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () {
                          _sendComment(_commentController.text, widget.username);
                        },
                        child: Text('Send'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }




}


Future<void> sendReport(message, username) async {
  var headers = {'Content-Type': 'application/json'};
  var url = Uri.parse('https://blind-metu-rest-api.onrender.com/problemform/$username');

  Map body = {
    "comment" : message
  };
  http.Response response = await http.post(url, body: jsonEncode(body), headers: headers);


}