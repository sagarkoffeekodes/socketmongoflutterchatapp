import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saggichatapp/auth/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dashboard/homescreen.dart';
import '../providers/autheticationProvider/UserRegistrationProvider.dart';
import 'forgetpassword.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthProvider? authProvider;
  String isLogin = "";
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  // Text editing controllers for form fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    prefs.setBool('isLoggedIn', true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getDeviceId();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Email field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email address.';
                  }
                  if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                    return 'Please enter a valid email address.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              // Password field
              TextFormField(
                controller: _passwordController,
                obscureText: _isObscure,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                    hintText: "Password"),
                 validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              authProvider!.isLoginLoading
                  ? CircularProgressIndicator(
                      color: Colors.blue,
                      backgroundColor: Colors.red,
                    )
                  : SizedBox.shrink(),
              // Login button
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    var data = {
                      "email": _emailController.text,
                      "password": _passwordController.text
                    };
                    authProvider!
                        .loginPost(data, "login", context)
                        .then((value) {
                      print("Response: $value");

                      if (authProvider!.isLoginSuccess) {
                        var token = value['token'];
                        saveToken(token);

                        print("Token: $token");
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => homeScreen()));
                      }
                    });
                  }
                },
                child: Text('Login'),
              ),
              // Forgot password text
              // TextButton(
              //   onPressed: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => ForgotPasswordPage(),
              //         ));
              //   },
              //   child: Text('Forgot password?'),
              // ),

              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(),
                      ));
                },
                child: Text('Back to Register?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
