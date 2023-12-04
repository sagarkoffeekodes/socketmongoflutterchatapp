import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../splashscreen/splashscreen.dart';
import 'chatuser/chatusers.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({Key? key}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  io.Socket? socket;
  TextEditingController usernameController = TextEditingController();
  List<String> userList = [];

  @override
  void initState() {
    super.initState();
  }

  initSocket(BuildContext context) {
    socket = io.io('https://chatapp1-d12f.onrender.com/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket!.connect();

    // Handle connection event
    socket!.on('connect', (_) {
      print('Connected to the server');

      // Set the username when connected
      socket!.emit('setUsername', usernameController.text);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(username: usernameController.text),
        ),
      );
    });

    // Handle user list updates
    socket!.on('userList', (data) {
      setState(() {
        userList = List<String>.from(data);
      });
    });

    // You can handle other events like 'roomMessage' similarly

    // Close the connection when the screen is disposed
    socket!.onDisconnect((_) => socket!.disconnect());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome to Dashboard"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
              // Clear all data in shared preferences
              prefs.setBool('isLoggedIn', false);
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => SplashScreen()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Enter your username',
                hintText: 'e.g., JohnDoe',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.red),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Connect to the server when the button is pressed
                await initSocket(context);
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ChatScreen(username: usernameController.text),
                //   ),
                // );
              },
              child: Text('Connect'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Disconnect the socket when the screen is disposed
    socket!.dispose();
    super.dispose();
  }
}
