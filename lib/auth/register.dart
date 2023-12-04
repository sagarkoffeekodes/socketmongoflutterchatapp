import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/autheticationProvider/UserRegistrationProvider.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  AuthProvider? authProvider;
  bool _isObscure = true;
  bool re_isObscure = true;
  final _formKey = GlobalKey<FormState>();

  // Text editing controllers for form fields
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
        title: Text('Register'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Username field
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your username.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
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
                  border: OutlineInputBorder(),

                  hintText: "Password",),

                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password.';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              // Confirm Password field
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: re_isObscure,
                decoration: InputDecoration(



                  suffixIcon: IconButton(
                    icon: Icon(
                      re_isObscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        re_isObscure = !re_isObscure;
                      });
                    },
                  ),
                  border: OutlineInputBorder(),

                  hintText: "Password",),

                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please confirm your password.';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              // Loader widget

              authProvider!.isRegisterLoading
                  ? CircularProgressIndicator(
                      color: Colors.blue,
                backgroundColor: Colors.red,
                    )
                  : SizedBox.shrink(),

              SizedBox(height: 20.0),
              // Register button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    var data = {
                      "name": _usernameController.text,
                      "email": _emailController.text,
                      "image": "qw",
                      "password": _passwordController.text
                    };

                    await authProvider!.registerPost(data, "register", context);
                    if (authProvider!.isRegisterSuccess) {
                      print("register done  or not");
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    }
                  }
                },
                child: Text('Register'),
              ),

              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ));
                },
                child: Text('Back to login?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
