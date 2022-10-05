import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/util/error_messages.dart';

class Network{

  static Network get instance => Network();


  Future<ConnectivityResult> get check async{
    return Connectivity().checkConnectivity().then((result) {
      print(result);
      switch(result){
        case ConnectivityResult.wifi:
          break;
        case ConnectivityResult.mobile:
          break;
        case ConnectivityResult.none:
          showToast(ErrorMessages.network_please);
      }
      return result;
    });
  }
}