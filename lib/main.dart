
import 'package:aioptics/signup.dart';
import 'package:aioptics/ui/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';



void main() {
  runApp(const MyIp());
}

class MyIp extends StatelessWidget {
  const MyIp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyIpPage(title: 'Login'),
    );
  }
}

class MyIpPage extends StatefulWidget {
  const MyIpPage({super.key, required this.title});

  final String title;

  @override
  State<MyIpPage> createState() => _MyIpPageState();
}

class _MyIpPageState extends State<MyIpPage> {


  TextEditingController IpController = new TextEditingController();




  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async{ return true; },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),


        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: IpController,
                  decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Ip")),
                ),
              ),

              ElevatedButton(
                onPressed: () {


                  _send_data();

                },
                child: Text("connect"),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _send_data() async{


    String ip=IpController.text;



    SharedPreferences sh = await SharedPreferences.getInstance();
    sh.setString("url","http://" + ip + ":8000/myapp");
    sh.setString("img_url","http://" + ip + ":8000");
    sh.setString("imgurl","http://" + ip + ":8000");
    PageController controller = PageController(initialPage: 0);
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => LoginScreen(controller: controller,),));
  }

}
