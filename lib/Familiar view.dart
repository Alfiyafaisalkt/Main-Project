
import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FamiliarView(title: 'Flutter Demo Home Page'),
    );
  }
}

class FamiliarView extends StatefulWidget {
  const FamiliarView({super.key, required this.title});


  final String title;

  @override
  State<FamiliarView> createState() => _FamiliarViewState();
}

class _FamiliarViewState extends State<FamiliarView> {

  _FamiliarViewState() {
    view_notification();
  }

  List<String> id_ = <String>[];
  List<String> name_ = <String>[];
  List<String> photo_ = <String>[];
  List<String> housename_ = <String>[];
  List<String> pin_ = <String>[];
  List<String> post_ = <String>[];
  List<String> phoneno_ = <String>[];
  List<String> Gender_ = <String>[];
  List<String> Email_ = <String>[];
  List<String> Relation_ = <String>[];



  Future<void> view_notification() async {
    List<String> id = <String>[];
    List<String> name = <String>[];
    List<String> photo = <String>[];
    List<String> housename = <String>[];
    List<String> pin = <String>[];
    List<String> post = <String>[];
    List<String> phoneno = <String>[];
    List<String> Gender = <String>[];
    List<String> Email = <String>[];
    List<String> Relation = <String>[];


    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String img_url = sh.getString('img_url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/View_familiar_people/';

      var data = await http.post(Uri.parse(url), body: {

      "lid":lid,
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
        phoneno.add(arr[i]['phone_no'].toString());
        // Gender.add(arr[i]['Gender'].toString());
        Email.add(arr[i]['Email'].toString());
        Relation.add(arr[i]['Relation'].toString());
        photo.add(img_url+ arr[i]['photo'].toString());

      }

      setState(() {
        id_ = id;
        name_=name;
        housename_=housename;
        pin_=pin;
        post_=post;
        phoneno_=phoneno;
        Email_=Email;
        Relation_=Relation;
        photo_=photo;

      });

      print(statuss);
    } catch (e) {
      print("Error ------------------- " + e.toString());
      //there is error during converting file image to base64 encoding.
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          leading: BackButton( ),
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.primary,

          title: Text(widget.title),
        ),
        body: ListView.builder(
          physics: BouncingScrollPhysics(),
          // padding: EdgeInsets.all(5.0),
          // shrinkWrap: true,
          itemCount: id_.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              onLongPress: () {
                print("long press" + index.toString());
              },
              title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Card(
                        child:
                        Row(
                            children: [
                              CircleAvatar(radius: 50,backgroundImage: NetworkImage(photo_[index])),
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text(name_[index]),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text(housename_[index]),
                                  ), Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text(pin_[index]),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text(post_[index]),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text(phoneno_[index]),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text(Email_[index]),
                                  ),
                                ],
                              ),
                              // ElevatedButton(
                              //   onPressed: () async {
                              //
                              //     final pref =await SharedPreferences.getInstance();
                              //     pref.setString("did", id_[index]);
                              //
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(builder: (context) => ViewSchedule()),
                              //     );
                              //
                              //
                              //
                              //
                              //   },
                              //   child: Text("Schedule"),
                              // ),
                            ]
                        )

                        ,
                        elevation: 8,
                        margin: EdgeInsets.all(10),
                      ),
                    ],
                  )),
            );
          },
        )
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
