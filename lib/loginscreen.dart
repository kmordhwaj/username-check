// ignore_for_file: avoid_print, use_rethrow_when_possible

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:usernamecheck/home1.dart';
import 'package:usernamecheck/registerscreen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);
  static const String id = 'login_screen';

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  //formkey
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  bool isAuth = false;

  //editing controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  //authentication
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.15,
                    fit: BoxFit.cover,
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10.0),
                        child: TextFormField(
                          controller: emailController,
                          autofocus: false,
                          style: const TextStyle(
                              fontSize: 25, color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            labelStyle:
                                TextStyle(fontSize: 15, color: Colors.white),
                            prefixIcon: Icon(Icons.mail, color: Colors.white),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Your Email";
                            }
                            if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return "Please Enter Valid Email";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            emailController.text = value!;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10.0),
                        child: TextFormField(
                          controller: passwordController,
                          autofocus: false,
                          style: const TextStyle(
                              fontSize: 25, color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            labelStyle:
                                TextStyle(fontSize: 15, color: Colors.white),
                            prefixIcon:
                                Icon(Icons.vpn_key, color: Colors.white),
                          ),
                          obscureText: true,
                          validator: (value) {
                            RegExp regex = RegExp(r'^.{6,}$');
                            if (value!.isEmpty) {
                              return "Please Enter Your Password";
                            }
                            if (!regex.hasMatch(value)) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            passwordController.text = value!;
                          },
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      if (_isLoading) const CircularProgressIndicator(),
                      if (!_isLoading)
                        ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                              elevation: 8,
                              primary: Colors.blue,
                              fixedSize: const Size(200, 40),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      const SizedBox(height: 15.0),
                      if (!_isLoading)
                        ElevatedButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, RegisterScreen.id),
                          style: ElevatedButton.styleFrom(
                              elevation: 8,
                              primary: Colors.red,
                              fixedSize: const Size(200, 40),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          child: const Text(
                            'Register',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _submit() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();
      //Logging the user
      try {
        await loginUser(
                emailController.text.trim(), passwordController.text.trim())
            .then((id) => {
                  Fluttertoast.showToast(msg: 'logged in successfully'),
                  print('here is the error'),
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const Home1(
                            isCameFromLogin: true,
                          )))
                });
      } on PlatformException catch (e) {
        Fluttertoast.showToast(msg: e.message!);
        setState(() {
          _isLoading = false;
        });
        rethrow;
      }
    }
  }

  static Future<void> loginUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on PlatformException catch (err) {
      throw (err);
    }
  }
}
