import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saggichatapp/providers/autheticationProvider/UserRegistrationProvider.dart';

import 'splashscreen/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(

      providers: [

        ChangeNotifierProvider(create: (context) => AuthProvider()),


      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:  SplashScreen(),
      ),
    );
  }
}

