import 'package:firebase_messaging/firebase_messaging.dart';

class Config{
  final String API_URL = 'http://localhost:3000';

  Map<String, String> headers(String jwt) => {
    'thepuppyplace': jwt
  };

  Future<String?> get fcm_token async{
    FirebaseMessaging fcm = FirebaseMessaging.instance;
    return fcm.getToken();
  }
}