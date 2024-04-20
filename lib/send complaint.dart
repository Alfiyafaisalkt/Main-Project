import 'package:aioptics/home.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyLogin());
}

class MyLogin extends StatelessWidget {
  const MyLogin({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SendComplaint(title: 'Login'),
    );
  }
}

class SendComplaint extends StatefulWidget {
  const SendComplaint({Key? key, required this.title});

  final String title;

  @override
  State<SendComplaint> createState() => _SendComplaintState();
}

class _SendComplaintState extends State<SendComplaint> {
  final TextEditingController complaintController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(

                    controller: complaintController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Complaint",
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null, // Allow multiline input
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your complaint';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String complaint = complaintController.text;

                        SharedPreferences sh = await SharedPreferences.getInstance();
                        String url = sh.getString('url').toString();
                        String lid = sh.getString('lid').toString();

                        final urls = Uri.parse('$url/Send_Complaint/');
                        try {
                          final response = await http.post(urls, body: {
                            'complaint': complaint,
                            'lid': lid,
                          });
                          if (response.statusCode == 200) {
                            String status = jsonDecode(response.body)['status'];
                            if (status == 'ok') {
                              Fluttertoast.showToast(msg: 'Complaint sent');
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => MyHomePage(title: 'Home')),
                              );
                            } else {
                              Fluttertoast.showToast(msg: 'Failed to send complaint');
                            }
                          } else {
                            Fluttertoast.showToast(msg: 'Network Error');
                          }
                        } catch (e) {
                          Fluttertoast.showToast(msg: e.toString());
                        }
                      }
                    },
                    child: Text(
                      "Send Complaint",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      primary: Colors.deepPurple,
                      foregroundColor:  Colors.white// Button color
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
