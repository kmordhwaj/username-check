import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usernamecheck/home.dart';
import 'package:usernamecheck/user_data.dart';

class Home2 extends StatefulWidget {
  const Home2({Key? key}) : super(key: key);

  @override
  State<Home2> createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  bool _isTimerDone = false;
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 2), () => setState(() => _isTimerDone = true));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !_isTimerDone) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData && _isTimerDone && snapshot.data != null) {
          Provider.of<UserData>(context, listen: false).currentUserId =
              snapshot.data!.uid;
          return const Home();
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
