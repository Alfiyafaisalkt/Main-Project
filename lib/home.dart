
import 'dart:convert';
import 'package:aioptics/ui/screens/login_screen.dart';
import 'package:http/http.dart' as http;

import 'package:aioptics/Familiar%20view.dart';
import 'package:aioptics/FamiliarUpdate.dart';
import 'package:aioptics/blind%20management.dart';
import 'package:aioptics/blind%20view.dart';
import 'package:aioptics/changepassword.dart';
import 'package:aioptics/emergency%20alert.dart';
import 'package:aioptics/familiar%20people%20management.dart';
import 'package:aioptics/send%20complaint.dart';
import 'package:aioptics/send%20review.dart';
import 'package:aioptics/view%20replay.dart';
import 'package:aioptics/view%20review.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart ';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            ',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController ipcontroller=new TextEditingController();

  _MyHomePageState()
  {
    senddata();
  }



  String Name="";
  String Gender="";
  String Dob="";
  String House_name="";
  String Place="";
  String Post="";
  String Pin="";
  String Email="";
  String Photo="";


  void senddata()async{



    SharedPreferences sh=await SharedPreferences.getInstance();
    String url=sh.getString('url').toString();
    String lid=sh.getString('lid').toString();
    final urls=Uri.parse(url+"/userviewprofile/");
    try{
      final response=await http .post(urls,body:{
        'lid':lid,
      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status=='ok') {
          Fluttertoast.showToast(msg: 'Success');

          setState(() {
            Name=jsonDecode(response.body)['Name'].toString();
            Gender=jsonDecode(response.body)['Gender'].toString();
            Dob=jsonDecode(response.body)['Dob'].toString();
            House_name=jsonDecode(response.body)['House_name'].toString();
            Place=jsonDecode(response.body)['Place'].toString();
            Post=jsonDecode(response.body)['Post'].toString();
            Pin=jsonDecode(response.body)['Pin'].toString();
            Email=jsonDecode(response.body)['Email'].toString();
            Photo=sh.getString('imgurl').toString()+jsonDecode(response.body)['Photo'].toString();
          });


        }else {
          Fluttertoast.showToast(msg: 'Not Found');
        }
      }
      else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    }
    catch (e){
      Fluttertoast.showToast(msg: e.toString());
    }

  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(
          color: Colors.white,
          icon: const Icon(Icons.logout),

          onPressed: () {
            PageController controller = PageController(initialPage: 0);
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => LoginScreen(controller: controller,),));
          },
        ),],
        backgroundColor: Color.fromARGB(250, 30, 90, 105),

        title: Text(widget.title),
      ),
      body:
      SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox(
              height: 280,
              width: double.infinity,
              child: Image.network(
                Photo,
                fit: BoxFit.fill,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16.0, 240.0, 16.0, 16.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16.0),
                        margin: EdgeInsets.only(top: 16.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: const EdgeInsets.only(left: 110.0),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          Name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                        // Text(
                                        //   '$email',
                                        //   style: Theme.of(context)
                                        //       .textTheme
                                        //       .bodyText1,
                                        // ),
                                        SizedBox(
                                          height: 40,
                                        )
                                      ],
                                    ),
                                    Spacer(),
                                    CircleAvatar(
                                      backgroundColor: Colors.blueAccent,
                                      child: IconButton(
                                          onPressed: () {

                                            // Navigator.push(context, MaterialPageRoute(
                                            //   builder: (context) => edit_userfull(),));

                                            },
                                          icon: Icon(
                                            Icons.edit_outlined,
                                            color: Colors.white,
                                            size: 18,
                                          )),
                                    )
                                  ],
                                )),
                            SizedBox(height: 10.0),
                            Row(
                              children: [

                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            image:  DecorationImage(
                                image: NetworkImage(
                                    Photo),
                                fit: BoxFit.cover)),
                        margin: EdgeInsets.only(left: 20.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      children:  [
                        ListTile(
                          title: Text("Profile Information"),
                        ),
                        Divider(),
                        // ListTile(
                        //   title: Text("Date of Birth"),
                        //   subtitle: Text("12 September 2001"),
                        //   leading: Icon(Icons.calendar_view_day),
                        // ),
                        // ListTile(
                        //   title: Text('Qualifiactaion'),
                        //   subtitle: Text("Bachelor Degree"),
                        //   leading: Icon(Icons.school_outlined),
                        // ),


                        ListTile(
                          title: Text("Gender"),
                          subtitle: Text(Gender),
                          leading: Icon(Icons.male_sharp),
                        ),
                        ListTile(
                          title: Text("Dob"),
                          subtitle: Text(Dob),
                          leading: Icon(Icons.male_sharp),
                        ),

                        ListTile(
                          title: Text('House'),
                          subtitle: Text(House_name),
                          leading: Icon(Icons.mail_outline),
                        ),
                        ListTile(
                          title: Text('Place'),
                          subtitle: Text(Place),
                          leading: Icon(Icons.mail_outline),
                        ),
                        ListTile(
                          title: Text('Post'),
                          subtitle: Text(Post),
                          leading: Icon(Icons.mail_outline),
                        ),
                        ListTile(
                          title: Text('Pincode'),
                          subtitle: Text(Pin),
                          leading: Icon(Icons.mail_outline),
                        ),
                        ListTile(
                          title: Text('Email'),
                          subtitle: Text(Email),
                          leading: Icon(Icons.mail_outline),
                        ),



                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: 60,
              left: 20,
              child: MaterialButton(
                minWidth: 0.2,
                elevation: 0.2,
                color: Colors.white,
                child: const Icon(Icons.arrow_back_ios_outlined,
                    color: Colors.indigo),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                onPressed: () {

                  // Navigator.push(context, MaterialPageRoute(builder: (context) =>Home (),));



                },
              ),
            ),
          ],
        ),
      ),




      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color:  Color.fromARGB(195, 29, 155, 187),


              ),
              child:
              Column(children: [

                Text(
                  'AI Optics',
                  style: TextStyle(fontSize: 20,color: Colors.grey[200]),
                ),
                CircleAvatar(radius: 50,backgroundImage: NetworkImage(Photo)),




              ])


              ,
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(title: "",),));
              },
            ),
            ListTile(
              leading: Icon(Icons.blind),
              title: const Text(' Blind people Add '),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddBlind(title: '',),));
              },
            ),
            ListTile(
              leading: Icon(Icons.view_array),
              title: const Text(" Blind people view "),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => BlindView(title: '',),));
              },
            ),

            ListTile(
              leading: Icon(Icons.task_alt),
              title: const Text(' Familiar people Add'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => FamiliarAdd(title: '',),));
              },
            ),

            ListTile(
              leading: Icon(Icons.request_page),
              title: const Text(' Familiar people View '),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => FamiliarView(title: '',),));
              },
            ),
            ListTile(
              leading: Icon(Icons.emergency),
              title: const Text(' Emergency Alert '),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => EmergencyAlert(title: "",),));
              },
            ),

            ListTile(
              leading: Icon(Icons.rate_review),
              title: const Text(' Send Review '),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => SendReview(title: "blind location",),));
              },
            ),
            ListTile(
              leading: Icon(Icons.reviews),
              title: const Text(' View Review '),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => ViewReviewPage(title: "blind location",),));
              },
            ),

            ListTile(
              leading: Icon(Icons.password),
              title: const Text(' Complaints '),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => ViewReplyPage(title: "Complaints",),));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: const Text(' Change Password '),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyChangePasswordPage(title: "Change Password",),));
              },
            ),

            ListTile(
              leading: Icon(Icons.logout),
              title: const Text('LogOut'),
              onTap: () {    PageController controller = PageController(initialPage: 0);
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => LoginScreen(controller: controller,),));

                // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
              },
            ),
          ],
        ),
      ),





    );

  }

}
