import 'package:firebase_auth/firebase_auth.dart';

class MessagedFirebaseAuthException extends FirebaseAuthException {
  final String _message;
  MessagedFirebaseAuthException(this._message) : super(code: _message);
  @override
  String get message => _message;
  @override
  String toString() {
    return message;
  }
}
