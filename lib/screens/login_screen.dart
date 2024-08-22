import 'package:biometrics_login_app/screens/home_scren.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController =
      TextEditingController(text: "");
  final TextEditingController passwordController =
      TextEditingController(text: "");
  bool _obscureText = true;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String KEY_USERNAME = "KEY_USERNAME";
  final String KEY_PASSWORD = "KEY_PASSWORD";
  final String KEY_LOCAL_AUTH_ENABLED = "KEY_LOCAL_AUTH_ENABLED";
  final String REQUIRE_BIOMETRIC_LOGIN_SELECT_YES =
      "REQUIRE_BIOMETRIC_LOGIN_SELECT_YES";
  RegExp regex = new RegExp(r'^.{3,}$');
  var localAuth = LocalAuthentication();
  final _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    sharedPrefrences();

    Future.delayed(Duration(seconds: 3), () {
      _readFromStorage();
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _seeOrHidePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> sharedPrefrences() async {
    String? isLocalAuthEnabled =
        await _secureStorage.read(key: "KEY_LOCAL_AUTH_ENABLED");

    print("isLocalAuthEnabled $isLocalAuthEnabled");
    if (isLocalAuthEnabled == "true") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Biometric authentication is enabled.",
          style: TextStyle(fontSize: 16),
        ),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 5),
        content: Text(
          "Biometric authentication is disabled.",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ));
    }
  }

  // Read values
  Future<void> _readFromStorage() async {
    String isLocalAuthEnabled =
        await _secureStorage.read(key: "KEY_LOCAL_AUTH_ENABLED") ?? "false";

    if ("true" == isLocalAuthEnabled) {
      bool didAuthenticate = await localAuth.authenticate(
          localizedReason: 'Please authenticate to sign in',
          options: const AuthenticationOptions(useErrorDialogs: false));

      if (didAuthenticate) {
        usernameController.text =
            await _secureStorage.read(key: KEY_USERNAME) ?? '';
        passwordController.text =
            await _secureStorage.read(key: KEY_PASSWORD) ?? '';

        print("UN" + usernameController.text);
        print("PW" + passwordController.text);
        signInSuceessful();
      }
    } else {
      usernameController.text = '';
      passwordController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg1.jpeg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(children: [
          SizedBox(height: 20),
          Image.asset('assets/images/logo.png', width: 200, height: 200),
          Center(
            child: Form(
              key: _key,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                width: MediaQuery.of(context).size.width * 0.9,
                child: SingleChildScrollView(
                  child: Column(children: [
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: TextFormField(
                        controller: usernameController,
                        autofocus: false,
                        onSaved: (value) {
                          usernameController.text = value!;
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        style: TextStyle(
                            fontSize: 14, height: 1.2, color: Colors.black),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50)),
                          labelText: "Username",
                          labelStyle:
                              TextStyle(color: Colors.black87, fontSize: 14),
                          prefixIconConstraints: BoxConstraints(minWidth: 40),
                          prefixIcon:
                              Icon(color: Colors.grey, Icons.person, size: 25),
                          hintText: "Enter the username",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Username is required..");
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        obscureText: true,
                        controller: passwordController,
                        autofocus: false,
                        onSaved: (value) {
                          passwordController.text = value!;
                          FocusScope.of(context).unfocus();
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        style: TextStyle(
                            fontSize: 14, height: 1.2, color: Colors.black),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50)),
                          labelText: "Password",
                          labelStyle:
                              TextStyle(color: Colors.black87, fontSize: 14),
                          prefixIconConstraints: BoxConstraints(minWidth: 40),
                          prefixIcon: Icon(
                              color: Colors.grey,
                              Icons.password_outlined,
                              size: 25),
                          suffixIcon: IconButton(
                            color: Colors.grey[700],
                            onPressed: _seeOrHidePassword,
                            icon: Icon(
                                _obscureText == true
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 25),
                          ),
                          hintText: "Enter the password",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Password is required..");
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "Forgot Password ?",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ElevatedButton(
                        child: Text(
                          "Sign in",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                Colors.black.withOpacity(0.7)),
                            shape: WidgetStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                            minimumSize: WidgetStateProperty.all(
                              Size(MediaQuery.of(context).size.width, 55),
                            )),
                        onPressed: () {
                          signInSuceessful();
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                    Align(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          text: "Don't you have an account? ",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Sign up",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ]),
      ),
    ));
  }

  Future<void> signInSuceessful() async {
    if (_key.currentState!.validate()) {
      // Add backend API integration here
      await _secureStorage.write(
          key: KEY_USERNAME, value: usernameController.text);
      await _secureStorage.write(
          key: KEY_PASSWORD, value: passwordController.text);

      Future.delayed(Duration(seconds: 1), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(username: usernameController.text),
          ),
        );
      });
    }
  }
}
