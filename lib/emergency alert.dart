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
      home: const EmergencyAlert(title: 'Flutter Demo Home Page'),
    );
  }
}

class EmergencyAlert extends StatefulWidget {
  const EmergencyAlert({super.key, required this.title});


  final String title;

  @override
  State<EmergencyAlert> createState() => _EmergencyAlertState();
}

class _EmergencyAlertState extends State<EmergencyAlert> {

  _EmergencyAlertState() {
    view_notification();
  }

  List<String> id_ = <String>[];
  List<String> la_ = <String>[];
  List<String> lo_ = <String>[];
  List<String> name_ = <String>[];
  List<String> photo_ = <String>[];
  List<String> date_ = <String>[];


  Future<void> view_notification() async {
    List<String> id = <String>[];
    List<String> la = <String>[];
    List<String> lo = <String>[];
    List<String> name = <String>[];
    List<String> photo = <String>[];
    List<String> date = <String>[];


    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/Emergency_alert_view/';

      var data = await http.post(Uri.parse(url), body: {

        "lid": lid,
      });
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      print(arr.length);

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        date.add(arr[i]['date']);
        name.add(arr[i]['name']);
        photo.add(sh.getString("img_url").toString()+arr[i]['photo']);
        la.add(arr[i]['la']);
        lo.add(arr[i]['lo']);
      }

      setState(() {
        id_ = id;
        date_=date;
        name_=name;
        photo_=photo;
        la_=la;
        lo_=lo;
      });

      print(statuss);
    } catch (e) {
      print("Error ------------------- " + e.toString());
      //there is error during converting file image to base64 encoding.
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(color:Colors.white,onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => HomeNew()),);

          },),
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .primary,
          title: Text("Emergency Alert",style: TextStyle(color: Colors.white),),
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
                  margin: EdgeInsets.all(20.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage(photo_[index]),
                            ),
                            SizedBox(width: 16),
                            Text(
                              date_[index],
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Name:'+name_[index],
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Latitude: '+ lo_[index],
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Longitude: '+la_[index],
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    )




                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Image.asset(
                  //       photo_[index],
                  //       width: 150,
                  //       height: 150,
                  //       fit: BoxFit.cover,
                  //     ),
                  //     SizedBox(width: 16.0),
                  //     Expanded(
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             'Name:'+ name_[index],
                  //             style: TextStyle(fontSize: 16.0),
                  //           ),
                  //           SizedBox(height: 8.0),
                  //           Text(
                  //             'Latitude:'+ la_[index],
                  //             style: TextStyle(fontSize: 16.0),
                  //           ),
                  //           SizedBox(height: 8.0),
                  //           Text(
                  //             'Longitude:'+lo_[index],
                  //             style: TextStyle(fontSize: 16.0),
                  //           ),
                  //           SizedBox(height: 16.0),
                  //           ElevatedButton(
                  //             onPressed: () {
                  //               // _launchMapsUrl(latitude, longitude);
                  //             },
                  //             child: Text('Open in Google Maps'),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ),
              ),
                    ],
                  )),
            );
          },
        ),



      ),
    );
  }
}
