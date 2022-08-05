import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usernamecheck/home1.dart';
import 'package:usernamecheck/loginscreen.dart';
import 'package:usernamecheck/registerscreen.dart';
import 'package:usernamecheck/user_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences.getInstance().then((prefs) {
    var darkModeOn = prefs.getBool('darkMode') ?? false;

    //Set Navigation bar color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: darkModeOn ? Colors.black : Colors.white,
        systemNavigationBarIconBrightness:
            darkModeOn ? Brightness.light : Brightness.dark));

    runApp(MultiProvider(providers: [
      ChangeNotifierProvider<UserData>(create: (context) => UserData()),
    ], child: const MyApp()));
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isTimerDone = false;

  @override
  void initState() {
    Timer(
        const Duration(seconds: 2), () => setState(() => _isTimerDone = true));
    super.initState();
  }

  Widget _getScreenId() {
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
          return const Home1(
            isCameFromLogin: false,
          );
        } else {
          return const LogInScreen();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'Stardew',
      theme: ThemeData.dark(),
      home: _getScreenId(),
      routes: {
        LogInScreen.id: (context) => const LogInScreen(),
        RegisterScreen.id: (context) => const RegisterScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
