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
      home: const SendReview(title: 'Login'),
    );
  }
}

class SendReview extends StatefulWidget {
  const SendReview({Key? key, required this.title});

  final String title;

  @override
  State<SendReview> createState() => _SendReviewState();
}

class _SendReviewState extends State<SendReview> {
  TextEditingController reviewController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
            "Send Review",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: reviewController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Review",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a review';
                      }
                      return null;
                    },
                    maxLines: null, // Allow multiline
                    keyboardType: TextInputType.multiline,
                    minLines: 5, // Set minimum lines
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String review = reviewController.text.toString();

                      SharedPreferences sh = await SharedPreferences.getInstance();
                      String url = sh.getString('url').toString();
                      String lid = sh.getString('lid').toString();

                      final urls = Uri.parse('$url/Send_Review/');
                      try {
                        final response = await http.post(urls, body: {
                          'Reviews': review,
                          'lid': lid,
                        });
                        if (response.statusCode == 200) {
                          String status = jsonDecode(response.body)['status'];
                          if (status == 'ok') {
                            Fluttertoast.showToast(msg: 'Review sent');
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyHomePage(title: 'Home',)),
                            );
                          } else {
                            Fluttertoast.showToast(msg: 'Failed to send review ');
                          }
                        } else {
                          Fluttertoast.showToast(msg: 'Network Error');
                        }
                      } catch (e) {
                        Fluttertoast.showToast(msg: e.toString());
                      }
                    }
                  },
                  child: Text("Review"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
