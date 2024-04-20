import 'dart:convert';

import 'package:aioptics/blind%20edit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BlindView(title: 'Flutter Demo Home Page'),
    );
  }
}

class BlindView extends StatefulWidget {
  const BlindView({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<BlindView> createState() => _BlindViewState();
}

class _BlindViewState extends State<BlindView> {
  _BlindViewState() {
    view_notification();
  }

  List<String> id_ = [];
  List<String> name_ = [];
  List<String> photo_ = [];
  List<String> housename_ = [];
  List<String> pin_ = [];
  List<String> post_ = [];
  List<String> contact_ = [];
  List<String> Gender_ = [];
  List<String> Email_ = [];
  List<String> place_ = [];
  List<String> DOB_ = [];

  Future<void> view_notification() async {
    List<String> id = [];
    List<String> name = [];
    List<String> photo = [];
    List<String> housename = [];
    List<String> pin = [];
    List<String> post = [];
    List<String> Gender = [];
    List<String> Email = [];
    List<String> contact = [];
    List<String> DOB = [];
    List<String> place = [];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/Blind_view/';

      var data = await http.post(Uri.parse(url), body: {
        "lid": lid,
      });
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      print(arr.length);

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        name.add(arr[i]['name'].toString());
        housename.add(arr[i]['house_name'].toString());
        pin.add(arr[i]['pin'].toString());
        post.add(arr[i]['post'].toString());
        contact.add(arr[i]['contact'].toString());
        Gender.add(arr[i]['Gender'].toString());
        Email.add(arr[i]['Email'].toString());
        DOB.add(arr[i]['DOB'].toString());
        place.add(arr[i]['place'].toString());
        photo.add(sh.getString("img_url").toString() + arr[i]['Photo']);
      }

      setState(() {
        id_ = id;
        name_ = name;
        photo_ = photo;
        housename_ = housename;
        pin_ = pin;
        post_ = post;
        Gender_ = Gender;
        Email_ = Email;
        contact_ = contact;
        DOB_ = DOB;
        place_ = place;
      });

      print(statuss);
    } catch (e) {
      print("Error ------------------- " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          "Blind Person",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: id_.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Card(
                  elevation: 8,
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Image.network(
                        photo_[index],
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      ListTile(
                        title: Text(name_[index]),
                        subtitle: Text(Email_[index]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(housename_[index]),
                            Text(pin_[index]),
                            Text(post_[index]),
                            Text(DOB_[index]),
                            Text(contact_[index]),
                            Text(Gender_[index]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: ElevatedButton(
                    onPressed: () async {
                      SharedPreferences sh =
                      await SharedPreferences.getInstance();
                      sh.setString("bid", id_[index]);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlindEdit(title: 'Login'),
                        ),
                      );
                    },
                    child: const Text("Edit"),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 80,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("Delete"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
