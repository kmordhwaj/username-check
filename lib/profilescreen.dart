import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String? currentUserId;
  const ProfileScreen({Key? key, this.currentUserId}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Column();
  }
}
