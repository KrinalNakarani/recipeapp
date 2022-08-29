import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider1/ragisterProvider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController Password = TextEditingController();
  bool login = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: email,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Email"),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: Password,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Password"),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    var res =
                        await Provider.of<RagiProvider>(context, listen: false)
                            .loginUser(email.text, Password.text);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("$res")));
                    Navigator.pushReplacementNamed(context, 'home');
                  },
                  child: Text("Login"),
                ),
                GestureDetector(
                  onTap: () {
                    Provider.of<RagiProvider>(context, listen: false)
                        .googleSignIn();
                  },
                  child: Container(
                    height: 100,
                    width: 300,
                    alignment: Alignment.center,
                    child: Text(
                      "Sign in with Google",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'reg');
                  },
                  child: Text(
                    "Create new account! SignUp",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
