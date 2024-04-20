import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyChangePassword());
}

class MyChangePassword extends StatelessWidget {
  const MyChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChangePassword',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FamiliarAdd(title: 'ChangePassword'),
    );
  }
}

class FamiliarAdd extends StatefulWidget {
  const FamiliarAdd({super.key, required this.title});

  final String title;

  @override
  State<FamiliarAdd> createState() => _FamiliarAddState();
}

class _FamiliarAddState extends State<FamiliarAdd> {


  File? _selectedImage;
  String? _encodedImage;
  Future<void> _chooseAndUploadImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
        _encodedImage = base64Encode(_selectedImage!.readAsBytesSync());
        photo = _encodedImage.toString();
      });
    }
  }

  Future<void> _checkPermissionAndChooseImage() async {
    final PermissionStatus status = await Permission.mediaLibrary.request();
    if (status.isGranted) {
      _chooseAndUploadImage();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Permission Denied'),
          content: const Text(
            'Please go to app settings and grant permission to choose an image.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  String photo = '';


  @override
  Widget build(BuildContext context) {

    TextEditingController nameController= new TextEditingController();
    TextEditingController housenameController= new TextEditingController();
    TextEditingController pinController= new TextEditingController();
    TextEditingController postController= new TextEditingController();
    TextEditingController placeController= new TextEditingController();
    TextEditingController EmailController= new TextEditingController();
    TextEditingController phonenoController= new TextEditingController();
    TextEditingController relationController= new TextEditingController();


    return WillPopScope(
      onWillPop: () async{ return true; },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              if (_selectedImage != null) ...{
                InkWell(
                  child:
                  Image.file(_selectedImage!, height: 400,),
                  radius: 399,
                  onTap: _checkPermissionAndChooseImage,
                  // borderRadius: BorderRadius.all(Radius.circular(200)),
                ),
              } else ...{
                // Image(image: NetworkImage(),height: 100, width: 70,fit: BoxFit.cover,),
                InkWell(
                  onTap: _checkPermissionAndChooseImage,
                  child:Column(
                    children: [
                      Image(image: NetworkImage('https://cdn.pixabay.com/photo/2017/11/10/05/24/select-2935439_1280.png'),height: 200,width: 200,),
                      Text('Select Image',style: TextStyle(color: Colors.cyan))
                    ],
                  ),
                ),
              },

              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: nameController,

                  decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Name")),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: housenameController,

                  decoration: InputDecoration(border: OutlineInputBorder(),label: Text("House name")),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: pinController,

                  decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Pin")),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: postController,

                  decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Post")),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: placeController,

                  decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Place")),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: EmailController,

                  decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Email")),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: phonenoController,

                  decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Phone no")),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: relationController,

                  decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Relation")),
                ),
              ),

              ElevatedButton(
                onPressed: () async {

                  String name= nameController.text;
                  String housename= housenameController.text;
                  String pin= pinController.text;
                  String post= postController.text;
                  String place= placeController.text;
                  String Email= EmailController.text;
                  String phoneno= phonenoController.text;
                  String relation= relationController.text;



                  SharedPreferences sh = await SharedPreferences.getInstance();
                  String url = sh.getString('url').toString();
                  String lid = sh.getString('lid').toString();

                  final urls = Uri.parse('$url/Familiar_people_management/');
                  try {
                    final response = await http.post(urls, body: {
                      "name":name,
                      "house_name":housename,
                      "pin": pin,
                      "post":post,
                      "phone_no":phoneno,
                      "place":place,
                      "Email":Email,
                      "Relation":relation,
                      'photo':photo,
                      'lid':lid



                    });
                    if (response.statusCode == 200) {
                      String status = jsonDecode(response.body)['status'];
                      if (status=='ok') {
                        Fluttertoast.showToast(msg: 'Added Successfully');

                      }else {
                        Fluttertoast.showToast(msg: 'Incorrect Password');
                      }
                    }
                    else {
                      Fluttertoast.showToast(msg: 'Network Error');
                    }
                  }
                  catch (e){
                    Fluttertoast.showToast(msg: e.toString());
                  }

                },
                child: Text("Add"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
