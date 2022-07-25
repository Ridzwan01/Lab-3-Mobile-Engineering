import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_tutor/constants.dart';
import 'package:my_tutor/views/login.dart';
import 'package:my_tutor/views/subject.dart';

class addsubject extends StatefulWidget {
  addsubject({Key? key}) : super(key: key);

  @override
  State<addsubject> createState() => _addsubjectState();
}

class _addsubjectState extends State<addsubject> {
  late double screenHeight, screenWidth;
  var _image;
  File? _croppedFile;
  String pathAsset = 'assets/images/user.png';
  TextEditingController nameCtrl = new TextEditingController();
  TextEditingController descCtrl = new TextEditingController();
  TextEditingController priceCtrl = new TextEditingController();
  TextEditingController tutorCtrl = new TextEditingController();
  TextEditingController sessionCtrl = new TextEditingController();
  TextEditingController ratingCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Subject'),
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
                      controller: nameCtrl,
                      decoration: InputDecoration(
                        hintText: "Subject Name",
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
                      controller: descCtrl,
                      decoration: InputDecoration(
                        hintText: "Subject Description",
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
                      controller: priceCtrl,
                      decoration: InputDecoration(
                        hintText: "Subject Price",
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
                      controller: tutorCtrl,
                      decoration: InputDecoration(
                        hintText: "Tutor ID",
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
                      controller: sessionCtrl,
                      decoration: InputDecoration(
                        hintText: "Subject Session",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)
                        ),
                      ),
                      keyboardType: TextInputType.streetAddress,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: TextField(
                      controller: ratingCtrl,
                      decoration: InputDecoration(
                        hintText: "Subject Rating",
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
                          child: const Text("Add Subject"),
                          onPressed: _addSubject,
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

  void _addSubject() {
    String _name     = nameCtrl.text;
    String _desc     = descCtrl.text;
    String _price    = priceCtrl.text;
    String _tutor    = tutorCtrl.text;
    String _session  = sessionCtrl.text;
    String _rating   = ratingCtrl.text;
    
    
    if (_name.isNotEmpty && _desc.isNotEmpty && _price.isNotEmpty && _tutor.isNotEmpty && _session.isNotEmpty && _rating.isNotEmpty) {
      http.post(Uri.parse(CONSTANTS.server + "/my_tutor/mobile/php/add_subject.php"),
      body: {
        "name"     : _name, 
        "desc"     :_desc, 
        "price"    :_price, 
        "tutor"    : _tutor, 
        "session"  :_session,
        "rating"   :_rating,
        }).then((response) {
            print(response.body);
            if(response.body=="success"){
              Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => subjectScreen()));
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