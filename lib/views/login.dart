import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_tutor/constants.dart';
import 'package:my_tutor/views/mainscreen.dart';
import 'package:my_tutor/views/register.dart';

class login extends StatefulWidget {
  login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  late double screenHeight, screenWidth;
  bool remember = false;
  TextEditingController emailCtrl = new TextEditingController();
  TextEditingController passCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 16, 32, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: screenHeight / 2.5,
                    width: screenWidth,
                    child: Image.asset('assets/images/Untitled_Artwork.jpg')
                  ),
                  const Text(
                    "Login User",
                    style: TextStyle(fontSize: 20),
                  ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: const Text(
                          'Sign in',
                          style: TextStyle(fontSize: 15),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (content) => register()));
                        },
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(value: remember, onChanged: _onChanged),
                      const Text("Remember Me"),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 32),
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: screenWidth,
                      height: 50,
                        child: ElevatedButton(
                          child: const Text("login"),
                          onPressed: _loginUser,
                        ),
                    ),
                  )
                ]
              )
            )
          ],
        )
      )
    );
  }

  void _onChanged(bool? value) {
  }

  void _loginUser() {
    String _email = emailCtrl.text;
    String _pass = passCtrl.text;
    if (_email.isNotEmpty && _pass.isNotEmpty) {
      http.post(Uri.parse(CONSTANTS.server + "/my_tutor/mobile/php/login_user.php"),
      body: {"email": _email, "password": _pass}).then((response) {
        print(response.body);
        if(response.body=="success"){
            Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (content) => mainScreen()));
        }
      });
    }
  }
}