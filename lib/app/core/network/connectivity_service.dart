import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  Future<bool> hasConnection() async {
    final result = await Connectivity().checkConnectivity();

    print('CONNECTIVITY RESULT = $result');

    return !result.contains(ConnectivityResult.none);
  }
}