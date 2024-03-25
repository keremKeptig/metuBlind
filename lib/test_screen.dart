import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:metublind/main.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'homeScreen.dart';
import 'dart:convert';

void main() {
  runApp(testScreen());
}

class testScreen extends StatelessWidget {
  final String? username;
  const testScreen({Key? key, this.username}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink,
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
        body: QuestionForm(username: username),
      ),
    );
  }
}




class QuestionForm extends StatefulWidget {
  final String? username; // ? -> null olabilir demek, final değişemez demek

  // Constructor'ı güncelleyin, kullanıcı adını parametre olarak alacak şekilde
  const QuestionForm({Key? key, this.username}) : super(key: key);


  @override
  _QuestionFormState createState() => _QuestionFormState();
}

class _QuestionFormState extends State<QuestionForm> {
  String choice = '';
  var maxID = ' ';
  var qs;
  List<String> objeler = [];
  int currentQuestionIndex = 0;
  String choiceString = '';
  List<List> answers = [];



  @override
  void initState() {
    super.initState();
    // initState içinde getMaxTestID fonksiyonunu çağırıyoruz
    _fetchMaxID(); // getMaxTestID fonksiyonunu çağırıyoruz
  }

  // Asenkron işlemi gerçekleştiren fonksiyon
  Future<void> _fetchMaxID() async {
    maxID = await getMaxTestID();
    print(maxID);
    setState(() {
      // Yüklemenin tamamlandığını bildiriyoruz, widget yeniden oluşturulsun
      _fetchQuestions(); // _fetchQuestions fonksiyonunu çağırıyoruz
    });
  }

  // Asenkron işlemi gerçekleştiren fonksiyon
  Future<void> _fetchQuestions() async {
    try {
      if (maxID == "-1") {
        throw FlutterError("Test is not available right now!");
      } else {
        String? username = widget.username;
        print(username);
        String value = await checkIfSolved(username, maxID); // await kullanarak sonucu al
        print(value);
        if (value.trim() == "0") { // Trim kullanarak boşlukları temizle
          print("girdim kereme");
          Fluttertoast.showToast(msg: "You've already completed the test!");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => homeScreen(username: username)),
          );
          return; // Test zaten yapılmış, işlemi sonlandır
        } else {
          var questions = await getQuestions(maxID);
          setState(() {
            qs = questions;
          });
          List<dynamic> parsedQs = json.decode(qs);
          for (var item in parsedQs) {
            String question = item[0];
            int value = item[1];
            objeler.add(question);
            objeler.add(value.toString());
            String? username = widget.username;
          }
        }
      }
    } catch (e) {
      // Hata oluştuğunda yapılacak işlemler buraya gelecek
      Fluttertoast.showToast(msg: "Test is not available right now!");
      String? username = widget.username;
      // Hata olduğunda ana ekrana yönlendirme işlemini buraya ekleyebilirsiniz.
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => homeScreen(username: username)),
      );
    }
  }





  // Her bir soruyu ekrana yazdırıyorum index index
  void _showNextQuestion() {
    List<String> qid_answer = [];
    String qid = objeler[currentQuestionIndex+1];
    qid_answer.add(qid);
    qid_answer.add(choice);
    answers.add(qid_answer);
    choiceString = choiceString + choice; // kullanıcı her butona bastığında güncellen choice değerini choiceString'e ekliyorum
    setState(() {
      // Indexi artırarak bir sonraki soruyu göster
      currentQuestionIndex = currentQuestionIndex + 2 ;
      // Eğer mevcut indeks, toplam soru sayısından fazla olursa, indeksi sıfırla
      if (currentQuestionIndex >= objeler.length) {
        String? username = widget.username;
        currentQuestionIndex = 0;
        print(choiceString); // örnek choiceString = "TFTFF"
        print(answers);
        Fluttertoast.showToast(msg: "You have completed the test!");
        print(username);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => homeScreen(username: username)), // homeScreene geri dönüyorum testi tamamladıktan sonra
        );
        // burada api çağırabilirim..
        for (int k = 0; k < answers.length; k++) {
          saveAnswers(answers[k][0], username, answers[k][1]);
        }

      }
    });
  }



  @override
  Widget build(BuildContext context) {
    String? username = widget.username;
    if (objeler == null || objeler.isEmpty) {
      return Center(
        child: CircularProgressIndicator(), // Sorular yüklenene kadar bir yükleme işareti görünecek
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink,
          title: Text('Find Your Soulmate !', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20), // Kenar boşlukları ayarla
                decoration: BoxDecoration(
                  color: Colors.white, // Beyaz renkli bir kutu oluştur
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 3),// Köşeleri yuvarla
                ),
                child: Text(
                  objeler[currentQuestionIndex], // Mevcut soruyu göster
                  textAlign: TextAlign.center, // Metni merkeze hizala
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        choice = 'T';
                        _showNextQuestion(); // Bir sonraki soruyu göster
                      });
                    },
                    child: Text('True', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        choice = 'F';
                        _showNextQuestion(); // Bir sonraki soruyu göster
                      });
                    },
                    child: Text('False', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
            ],
          ),
        ),
        backgroundColor: Colors.pinkAccent[100],
      );
    }
  }


}



Future<Object> getQuestions(test_id) async {
  try{
    var headers = {'Content-Type': 'application/json'};
    var url_1 = 'https://blind-metu-rest-api.onrender.com/question/';

    test_id = test_id.replaceAll('\n', ''); // Yeni satır karakterlerini kaldır
    test_id = test_id.trim(); // Başındaki ve sonundaki boşlukları kaldır

    var url_2 = url_1 + test_id;
    var url = Uri.parse(url_2);

    http.Response response = await http.get(url, headers: headers);

    print(url);
    return response.body;


  }
  catch (e) {
    return [];

  }

}


Future<String> getMaxTestID() async {
  try{
    var headers = {'Content-Type': 'application/json'};
    var url = Uri.parse('https://blind-metu-rest-api.onrender.com/question');

    http.Response response = await http.get(url, headers: headers);

    return response.body;


  }
  catch (e) {

  }
  return "-1";

}


Future<void> saveAnswers(q_id, username, choice) async {
  try{
    var headers = {'Content-Type': 'application/json'};
    var url = Uri.parse('https://blind-metu-rest-api.onrender.com/answer/$username/$q_id');

    Map body = {
      "choice" : choice
    };
    http.Response response = await http.post(url, body: jsonEncode(body), headers: headers);

  }
  catch (e) {}

}



Future<String> checkIfSolved(username,testID) async {
  try{
    var headers = {'Content-Type': 'application/json'};
    var url1 = 'https://blind-metu-rest-api.onrender.com/question/$username/';

    testID = testID.replaceAll('\n', ''); // Yeni satır karakterlerini kaldır
    testID = testID.trim(); // Başındaki ve sonundaki boşlukları kaldır

    String testID_string = testID.toString();
    var url_2 = url1 + testID_string;
    var url = Uri.parse(url_2);

    print(url);
    http.Response response = await http.get(url, headers: headers);
    return response.body;


  }
  catch (e) {

  }
  return "-1";

}
