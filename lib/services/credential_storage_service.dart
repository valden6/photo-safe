
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CredentialStorageService {

  Future<void> setPwd(String pwd) async {
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    await secureStorage.write(key: 'pwd', value: pwd);
  }

  Future<void> setFakePwd(String fakePwd) async {
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    await secureStorage.write(key: 'fakePwd', value: fakePwd);
  }

  Future<int> checkPwd(String pwd) async {
    int valid = 0;
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    final String? pwdStorage = await secureStorage.read(key: 'pwd');
    final String? fakePwdStorage = await secureStorage.read(key: 'fakePwd');
    if(pwdStorage == pwd){
      valid = 1;
    } else if(fakePwdStorage == pwd){
      valid = 2;
    }
    return valid;
  }

  static final CredentialStorageService _credentialStorageService = CredentialStorageService._internal();
  factory CredentialStorageService() {
    return _credentialStorageService;
  }
  CredentialStorageService._internal();

}

final CredentialStorageService credentialStorageService = CredentialStorageService();
