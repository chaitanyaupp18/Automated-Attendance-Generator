import 'package:Face_recognition/attendViewer.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:mailto/mailto.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert' as convert;
import 'package:Face_recognition/attendViewer.dart';
// import 'form.dart';

class MailPage extends StatefulWidget {
  final List stud;
  MailPage({Key key, this.stud}) : super(key: key);
  @override
  MailPageState createState() => MailPageState();
}

class MailPageState extends State<MailPage> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  
  final g_url1 = {
    "Subject1":
        "<PASTE THE LINK OF GOOGLE SHEET"
  };
  String imgUrl;
  String mail_id;
  String sub_id;
  String excel_url;
  String dropdownValue = "Subject1";
  final _formkey = GlobalKey<FormState>();
  final _formkey1 = GlobalKey<FormState>();

  _sendingMails(String output_path) async {
    final mailtoLink = Mailto(
      to: [mail_id],
      subject: 'Attendance Report for subject: ' +
          sub_id.toUpperCase() +
          ' on ' +
          output_path,
      body: excel_url,
    );
    await launch('$mailtoLink');
  }

  Future<String> get_localPath() async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<void> uploadToStorage(BuildContext context) async {
    // InputElement input = FileUploadInputElement()..accept = 'xlsx/*';
    Widget okButton1 = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AttendViewer()));
      },
    );
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    String students = "";
    for (var i = 0; i < widget.stud.length; i++) {
      if (widget.stud[i] != ' NOT RECOGNIZED' &&
          widget.stud[i] != ' NO FACE SAVED' &&
          widget.stud[i] != 'NOT RECOGNIZED' &&
          widget.stud[i] != 'NO FACE SAVED') {
        students += widget.stud[i] + ",";
      }
    }
    print("\n-------\n");
    print(students);
    print("\n-------\n");
    if (DateTime.now().hour.toInt() < 12) {
      var output_path = '${DateTime.now().day}' +
          '-' +
          '${DateTime.now().month}' +
          '-' +
          '${DateTime.now().year}' +
          '_' +
          '${DateTime.now().hour}' +
          '-' +
          '${DateTime.now().minute}' +
          ' AM';
      Map toJson = {'date': output_path, 'students': students};

      final response1 = await http.post(g_url1[sub_id], body: toJson);
      setState(() {
        if (response1 != null) {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text("Attendance Submitted"),
                content: Text("View Attendance"),
                actions: [okButton1, cancelButton],
              );
            },
          );
        }
      });
    } else {
      var output_path = '${DateTime.now().day}' +
          '-' +
          '${DateTime.now().month}' +
          '-' +
          '${DateTime.now().year}' +
          '_' +
          '${DateTime.now().hour - 12}' +
          '-' +
          '${DateTime.now().minute}' +
          '-' +
          '${DateTime.now().second}' +
          ' PM';
      Map toJson = {'date': output_path, 'students': students};

      final response1 = await http.post(g_url1[sub_id], body: toJson);
      setState(() {
        if (response1 != null) {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text("Attendance Submitted"),
                content: Text("View Attendance"),
                actions: [okButton1, cancelButton],
              );
            },
          );
        }
      });
    }
  }

  OutlineInputBorder _inputformdeco() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
      borderSide:
          BorderSide(width: 1.0, color: Colors.blue, style: BorderStyle.solid),
    );
  }

  Future<void> _savingData() async {
    final validation = _formkey.currentState.validate();
    if (!validation) {
      return;
    }
    _formkey.currentState.save();
  }

  Future<void> _savingData1() async {
    final validation = _formkey1.currentState.validate();
    if (!validation) {
      return;
    }
    _formkey1.currentState.save();
  }

  @override
  Widget build(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Submission Page')),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(
                height: 200.0,
              ),
              Text(
                'Attendance Maker',
                style: TextStyle(
                  fontSize: 35.0,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                borderOnForeground: true,
                child: Center(
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                    onChanged: (String newValue) async {
                      setState(() {
                        dropdownValue = newValue;
                        sub_id = newValue;
                      });
                    },
                    items: <String>[
                      'Subject1',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text("   " + value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Container(
                height: 20.0,
              ),
              SizedBox(height: 50),
              Container(
                height: 10.0,
              ),
              RaisedButton(
                onPressed: () {
                  if (sub_id != null) {
                    uploadToStorage(context);
                    // Navigator.pop(context);
                  } else {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: Text("Subject"),
                          content: Text("Please select the Subject"),
                          actions: [
                            okButton,
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text('Submit'),
                textColor: Colors.black,
                padding: const EdgeInsets.all(5.0),
              ),
              Container(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
