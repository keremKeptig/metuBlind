import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:metublind/homeScreen.dart';
import 'package:metublind/main.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(matchScreen());
}

class matchScreen extends StatelessWidget {
  final String? username;
  const matchScreen({Key? key, this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create GlobalKeys for each CheckboxMenu
    final mondayKey = GlobalKey<_CheckboxMenuState>();
    final tuesdayKey = GlobalKey<_CheckboxMenuState>();
    final wednesdayKey = GlobalKey<_CheckboxMenuState>();
    final thursdayKey = GlobalKey<_CheckboxMenuState>();
    final fridayKey = GlobalKey<_CheckboxMenuState>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Your Match!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
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
                  image: AssetImage(r'C:\Users\userpc\Desktop\Android_studio\metu_blind\android\images\backgroundMain.png'), // Corrected asset path
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MatchInfo(username: username),
                  SizedBox(height: 20),
                  CheckboxMenu(key: mondayKey, title: 'Monday'),
                  CheckboxMenu(key: tuesdayKey, title: 'Tuesday'),
                  CheckboxMenu(key: wednesdayKey, title: 'Wednesday'),
                  CheckboxMenu(key: thursdayKey, title: 'Thursday'),
                  CheckboxMenu(key: fridayKey, title: 'Friday'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _submitSelectedTimes(context, [mondayKey, tuesdayKey, wednesdayKey, thursdayKey, fridayKey], username);
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MatchInfo extends StatefulWidget {
  final String? username;
  const MatchInfo({Key? key, this.username}) : super(key: key);

  @override
  _MatchInfoState createState() => _MatchInfoState();
}

class _MatchInfoState extends State<MatchInfo> {
  String matchName = "Loading...";

  @override
  void initState() {
    super.initState();
    // fetchMatchName();
    fetchOverlap();
  }

  // Future<void> fetchMatchName() async {
  //   String name = await getMatchName(widget.username);
  //   setState(() {
  //     matchName = name;
  //     matchName = matchName.substring(1, matchName.length - 2);
  //   });
  // }

  Future<void> fetchOverlap() async {
    String user2 = await getMatchName(widget.username);
    user2 = user2.substring(1, user2.length - 2);

    if(user2 == "No Match")
    {
      matchName = "There is no match.";
      setState(() {
        matchName ;
      });
    }
    else {
      String message = await overlapTimes(widget.username, user2);
      message = message.substring(1, message.length - 2);

      if (message == "null") {
        setState(() {
          //user2 = user2.substring(1, matchName.length - 2);
          matchName = "You have matched with " + user2 +
              ", but the users on both sides need to select a time. ";
          // matchName = matchName.substring(1, matchName.length - 2);
        });
      }
      else {
        setState(() {
          matchName = message;
          matchName = matchName.substring(0, matchName.length);
        });
      }
    }

  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.orange,
        border: Border.all(
          color: Colors.black, // Siyah border
          width: 5.0, // Border genişliği
        ),
      ),
      child: Center(
        child: Text(
          '$matchName',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

}

class CheckboxMenu extends StatefulWidget {
  final String title;
  const CheckboxMenu({Key? key, required this.title}) : super(key: key);

  @override
  _CheckboxMenuState createState() => _CheckboxMenuState();
}

class _CheckboxMenuState extends State<CheckboxMenu> {
  final List<String> _times = ['18-19', '19-20', '20-21', '21-22'];
  final Map<String, bool> _selectedTimes = {};

  @override
  void initState() {
    super.initState();
    for (var time in _times) {
      _selectedTimes[time] = false;
    }
  }

  Map<String, bool> get selectedTimes => _selectedTimes;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Wrap(
            children: _times.map((time) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: _selectedTimes[time],
                    onChanged: (bool? value) {
                      setState(() {
                        _selectedTimes[time] = value ?? false;
                      });
                    },
                  ),
                  Text(time),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

void _submitSelectedTimes(BuildContext context, List<GlobalKey<_CheckboxMenuState>> keys, String? username) async {
  final List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

  print('Selected times:');
  await deleteSlots(username);


  for (int i = 0; i < days.length; i++) {
    final day = days[i];
    final key = keys[i];
    final selectedTimes = key.currentState?.selectedTimes;
    if (selectedTimes != null) {
      selectedTimes.forEach((time, isSelected) async {
        if (isSelected) { // Sadece true olanları yazdır

          List<String> parts = time.split('-');
          int firstValue = int.parse(parts[0].trim());
          int secondValue = int.parse(parts[1].trim());
          await submitSlots(day, firstValue, secondValue, username);
          print(secondValue);
        }
      });
    }
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Selected times submitted!'),
      duration: Duration(seconds: 2),
    ),
  );
}


Future<String> overlapTimes(user1,user2) async {
  try{
    var headers = {'Content-Type': 'application/json'};
    var url = Uri.parse('https://blind-metu-rest-api.onrender.com/match_slots');

    Map body = {
      "user1": user1,
      "user2": user2
    };
    http.Response response = await http.post(url, body: jsonEncode(body), headers: headers);
    return response.body;
  }
  catch (e) {

  }
  return "-1";

}



Future<void> submitSlots(day, start_time, end_time, username) async {
  try{
    var headers = {'Content-Type': 'application/json'};
    var url = Uri.parse('https://blind-metu-rest-api.onrender.com/slots');

    Map body = {
      "day": day,
      "start_time": start_time,
      "end_time": end_time,
      "username": username
    };
    http.Response response = await http.post(url, body: jsonEncode(body), headers: headers);

  }
  catch (e) {}

}


Future<String> getMatchName(String? username) async {
  try {
    var headers = {'Content-Type': 'application/json'};
    var url = Uri.parse('https://blind-metu-rest-api.onrender.com/fetchmatch/$username');

    http.Response response = await http.get(url, headers: headers);

    return response.body;
  } catch (e) {
    // Error handling
  }
  return "-1";
}

Future<void> deleteSlots(username) async {
  try{
    var headers = {'Content-Type': 'application/json'};
    var url = Uri.parse('https://blind-metu-rest-api.onrender.com/slots/$username');


    http.Response response = await http.delete(url, headers: headers);

  }
  catch (e) {}

}