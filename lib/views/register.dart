import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_tutor/views/login.dart';

class register extends StatefulWidget {
  register({Key? key}) : super(key: key);

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  late double screenHeight, screenWidth;
  var _image;
  File? _croppedFile;
  String pathAsset = 'assets/images/user.png';
  TextEditingController emailCtrl = new TextEditingController();
  TextEditingController nameCtrl = new TextEditingController();
  TextEditingController phNumCtrl = new TextEditingController();
  TextEditingController passCtrl = new TextEditingController();
  TextEditingController addressCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
            child: GestureDetector(
              onTap: () => {_takePictureDialog()},
              child: SizedBox(
                height: screenHeight / 3.5,
                width: screenWidth,
                child: _image == null
                  ? Image.asset(pathAsset)
                  : Image.file(_image)
              )
            ),
          ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: TextField(
                      controller: emailCtrl,
                      decoration: InputDecoration(
                        hintText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: TextField(
                      controller: nameCtrl,
                      decoration: InputDecoration(
                        hintText: "Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)
                        ),
                      ),
                      keyboardType: TextInputType.name,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: TextField(
                      controller: phNumCtrl,
                      decoration: InputDecoration(
                        hintText: "Phone Number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: TextField(
                      controller: passCtrl,
                      decoration: InputDecoration(
                        hintText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)
                        ),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: TextField(
                      controller: addressCtrl,
                      decoration: InputDecoration(
                        hintText: "Address",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)
                        ),
                      ),
                      keyboardType: TextInputType.streetAddress,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 32),
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: screenWidth,
                      height: 50,
                        child: ElevatedButton(
                          child: const Text("Register"),
                          onPressed: _RegisterUser,
                        ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _RegisterUser() {
    String _email     = emailCtrl.text;
    String _name      = nameCtrl.text;
    String _phNumber  = phNumCtrl.text;
    String _pass      = passCtrl.text;
    String _address   = addressCtrl.text;
    
    
    if (_email.isNotEmpty && _name.isNotEmpty && _phNumber.isNotEmpty && _pass.isNotEmpty && _address.isNotEmpty) {
      http.post(Uri.parse("http://192.168.0.108/my_tutor/mobile/php/register_user.php"),
      body: {
        "email": _email, 
        "name":_name, 
        "phNumber":_phNumber, 
        "password": _pass, 
        "address":_address,
        }).then((response) {
            print(response.body);
            if(response.body=="success"){
              Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => login()));
            }
        }
      );
    }
  }

  _takePictureDialog() {
    showDialog(
      context: context, 
      builder: (BuildContext Context){
        return AlertDialog(
          title: const Text(
            "Select From",
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                onPressed: () => {
                  Navigator.of(context).pop(),
                  _galeryPicker(),
                },
                 icon: const Icon(Icons.browse_gallery), 
                 label: const Text("Gallery")
                 ),
              TextButton.icon(
                onPressed: () => {
                  Navigator.of(context).pop(),
                  _cameraPicker(),
                },
                 icon: const Icon(Icons.camera_alt), 
                 label: const Text("Camera")
                 )
            ],
          ),
        );
      }
    );
  }

  _galeryPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
  }

  _cameraPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
     
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
  }
}