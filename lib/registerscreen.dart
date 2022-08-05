import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:usernamecheck/loginscreen.dart';
import 'package:usernamecheck/messeged_firebaseauth_exception.dart';
import 'package:usernamecheck/signin_exceptions.dart';
import 'package:usernamecheck/signup_exceptions.dart';
import 'package:usernamecheck/user_data.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  static const String id = 'register_screen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //formkey
  final _formKey = GlobalKey<FormState>();

  final bool _isLoading = false;

  //authentication
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  //editing controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController secondNameController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 1.9,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 1.3,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
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
                                  horizontal: 20.0, vertical: 10.0),
                              child: TextFormField(
                                controller: firstNameController,
                                autofocus: false,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                                decoration: const InputDecoration(
                                    labelText: 'First Name',
                                    prefixIcon: Icon(CupertinoIcons.person_fill,
                                        color: Colors.white),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    labelStyle: TextStyle(
                                        fontSize: 15, color: Colors.white)),
                                validator: (value) {
                                  RegExp regex = RegExp(r'^.{1,}$');
                                  if (value!.isEmpty) {
                                    return "Please Enter Your First Name";
                                  }
                                  if (!regex.hasMatch(value)) {
                                    return "First Name Should be at least of 1 characters";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  firstNameController.text = value!;
                                },
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              child: TextFormField(
                                controller: secondNameController,
                                autofocus: false,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                                decoration: const InputDecoration(
                                    labelText: 'Second Name (Surname)',
                                    prefixIcon: Icon(CupertinoIcons.person_fill,
                                        color: Colors.white),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    labelStyle: TextStyle(
                                        fontSize: 15, color: Colors.white)),
                                validator: (value) {
                                  RegExp regex = RegExp(r'^.{1,}$');
                                  if (value!.isEmpty) {
                                    return "Please Enter Your Second Name";
                                  }
                                  if (!regex.hasMatch(value)) {
                                    return "Name Should be at least of 1 characters";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  secondNameController.text = value!;
                                },
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              child: TextFormField(
                                controller: emailController,
                                autofocus: false,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                                decoration: const InputDecoration(
                                    labelText: 'Email',
                                    prefixIcon:
                                        Icon(Icons.mail, color: Colors.white),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    labelStyle: TextStyle(
                                        fontSize: 15, color: Colors.white)),
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return " Please Enter Your Email";
                                  }
                                  if (!RegExp(
                                          "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                      .hasMatch(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  emailController.text = value!;
                                },
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              child: TextFormField(
                                controller: passwordController,
                                autofocus: false,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                                decoration: const InputDecoration(
                                    labelText: 'Password',
                                    prefixIcon: Icon(Icons.vpn_key,
                                        color: Colors.white),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    labelStyle: TextStyle(
                                        fontSize: 15, color: Colors.white)),
                                obscureText: true,
                                validator: (value) {
                                  RegExp regex = RegExp(r'^.{6,}$');
                                  if (value!.trim().isEmpty) {
                                    return " Please Enter Your Password";
                                  }
                                  if (!regex.hasMatch(value)) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  if (value.trim().length > 12) {
                                    return 'Password must be at most 12 characters';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  passwordController.text = value!;
                                },
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              child: TextFormField(
                                controller: confirmPasswordController,
                                autofocus: false,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                                decoration: const InputDecoration(
                                    labelText: 'Confirm Password',
                                    prefixIcon:
                                        Icon(Icons.lock, color: Colors.white),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    labelStyle: TextStyle(
                                        fontSize: 15, color: Colors.white)),
                                obscureText: true,
                                validator: (value) {
                                  if (confirmPasswordController.text !=
                                      passwordController.text) {
                                    return " Password doesn't matched";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  confirmPasswordController.text = value!;
                                },
                                textInputAction: TextInputAction.done,
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            if (_isLoading) const CircularProgressIndicator(),
                            if (!_isLoading)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 8,
                                    primary: Colors.red,
                                    fixedSize: const Size(200, 40),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    bool? signUpStatus = false;
                                    String? snackbarMessage;
                                    try {
                                      final signUpFuture = signUp(
                                          email: emailController.text,
                                          password: passwordController.text,
                                          firstName: firstNameController.text,
                                          secondName: secondNameController.text,
                                          context: context);
                                      signUpFuture.then(
                                          (value) => signUpStatus = value);
                                      signUpStatus = await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return FutureProgressDialog(
                                            signUpFuture,
                                            message: const Text(
                                              "Creating new account",
                                              style:
                                                  TextStyle(color: Colors.pink),
                                            ),
                                          );
                                        },
                                      );
                                      if (signUpStatus == true) {
                                        snackbarMessage =
                                            "Almost there, Please choose your username";
                                      } else {
                                        throw FirebaseSignUpAuthUnknownReasonFailureException();
                                      }
                                    } on MessagedFirebaseAuthException catch (e) {
                                      snackbarMessage = e.message;
                                    } catch (e) {
                                      snackbarMessage = e.toString();
                                    } finally {
                                      Logger().i(snackbarMessage);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(snackbarMessage!),
                                        ),
                                      );
                                      if (signUpStatus == true) {
                                        Navigator.pop(context);
                                      }
                                    }
                                  }
                                },
                                child: const Text(
                                  'Register ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            const SizedBox(height: 20.0),
                            if (!_isLoading)
                              ElevatedButton(
                                onPressed: () => Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                        builder: (context) =>
                                            const LogInScreen())),
                                style: ElevatedButton.styleFrom(
                                    elevation: 8,
                                    primary: Colors.blue,
                                    fixedSize: const Size(200, 40),
                                    alignment: Alignment.center,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))),
                                child: const Center(
                                  child: Text(
                                    'Back to LogIn',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              )
                          ],
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

  Future<bool> signUp(
      {required String email,
      required String password,
      required String firstName,
      required String secondName,
      required BuildContext context}) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      final String id = userCredential.user!.uid;

      // ignore: use_build_context_synchronously
      Provider.of<UserData>(context, listen: false).cameFromRegisterScreen =
          true;
      final DateTime dateNow = DateTime.now();
      final Timestamp timeNow = Timestamp.fromDate(dateNow);
      if (userCredential.user!.emailVerified == false) {
        await userCredential.user!.sendEmailVerification();
      }
      await FirebaseFirestore.instance.collection('users').doc(id).set({
        'id': id,
        'firstName': firstName,
        'secondName': secondName,
        'email': email,
        'timeCreated': timeNow,
      });
      // ignore: use_build_context_synchronously
      Provider.of<UserData>(context, listen: false).currentUserId = id;
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          throw FirebaseSignUpAuthEmailAlreadyInUseException();
        case "invalid-email":
          throw FirebaseSignUpAuthInvalidEmailException();
        case "operation-not-allowed":
          throw FirebaseSignUpAuthOperationNotAllowedException();
        case "weak-password":
          throw FirebaseSignUpAuthWeakPasswordException();
        default:
          throw FirebaseSignInAuthException(message: e.code);
      }
    } catch (e) {
      rethrow;
    }
  }
}
