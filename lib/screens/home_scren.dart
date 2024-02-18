import 'package:biometrics_login_app/components/biometric_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.username});

  final String username;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _secureStorage = const FlutterSecureStorage();
  final String KEY_USERNAME = "KEY_USERNAME";
  final String KEY_PASSWORD = "KEY_PASSWORD";
  final String KEY_COMPANY = "KEY_COMPANY";
  final String KEY_LOCAL_AUTH_ENABLED = "KEY_LOCAL_AUTH_ENABLED";
  final String REQUIRE_BIOMETRIC_LOGIN_SELECT_YES =
      "REQUIRE_BIOMETRIC_LOGIN_SELECT_YES";
  var localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _requestFingerprintAuthentication();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _requestFingerprintAuthentication() async {
    String yesOrNo =
        await _secureStorage.read(key: "REQUIRE_BIOMETRIC_LOGIN_SELECT_YES") ??
            "false";

    print("yesOrNo $yesOrNo");

    if (await localAuth.canCheckBiometrics) {
      if (yesOrNo == "false") {
        await showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return BiometricBottomSheet(action: _onEnableLocalAuth);
          },
        );
      }
    }
  }

  void _onEnableLocalAuth() async {
    await _secureStorage.write(key: KEY_LOCAL_AUTH_ENABLED, value: "true");
    await _secureStorage.write(
        key: REQUIRE_BIOMETRIC_LOGIN_SELECT_YES, value: "true");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg1.jpeg"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Welcome",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w800,
                color: Colors.amber[800],
              ),
            ),
            Text(
              "${widget.username}",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Colors.amber[900],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
