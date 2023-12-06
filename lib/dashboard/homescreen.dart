import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saggichatapp/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../Utils/Preferences.dart';
import '../providers/autheticationProvider/UserRegistrationProvider.dart';
import '../splashscreen/splashscreen.dart';
import 'chatuser/chatusers.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({Key? key}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {

  AuthProvider? authProvider;
  String? currentUser;
  List<String> userList = [];

  io.Socket? socket;
  TextEditingController usernameController = TextEditingController();
  var ueserID;
  // Get user ID
  String? userIdutils;
  Future<void> saveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     // userIdutils = Preferences.getUserId();

    ueserID = prefs.getString('idUser');
   print("IIIDDD ${userIdutils}");
    // prefs.setBool('isLoggedIn', true);
  }

  @override
  void initState() {
    super.initState();

    authProvider = Provider.of<AuthProvider>(context, listen: false);
    saveToken();
    initSocket();
    getuserDetails();
  }

  void initSocket() {
    socket = io.io('https://chatapp1-d12f.onrender.com/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket!.connect();
    socket!.on('connect', (_) {
      print('Connected to server');
      socket!.emit('setUsername', userName);

      socket!.on('userList', (data) {
        print('Received userList data: $data');
        setState(() {
          // userList.clear(); // Clear the existing list
          userList = List<String>.from(data);
        });
      });
      // if (userName != null) {
      // }
    });


   /* socket!.on('privateMessage', (data) {
      print('Received privateMessage: $data');
      setState(() {
        messagesList.add('${data['from']}: ${data['message']}');
      });
    });*/
    // socket!.on('roomMessage', (data) {
    //   setState(() {
    //     messagesList.add('${data['from']} (Room): ${data['message']}');
    //   });
    // });

    socket!.on('errorMessage', (message) {
      print('Error: $message');
    });
  }
  String? userName;
  int? selectedIndex;

  getuserDetails() async {

    await authProvider!.getUserById(userIdutils.toString(), context)
        .then((value){
      print(value['name']);
      userName =  value['name'];
      print("User Name: $userName");
      print(value['name']);

      if (authProvider!.isgetSuccess) {
        print("register done  or not");
      }

    });

  }
  @override
  void dispose() {
    socket!.disconnected;
    // Disconnect the socket when the screen is disposed
    socket!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${userName}"),
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
                  MaterialPageRoute(builder: (_) => LoginPage()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Text(
            'User Online',
            style: TextStyle(
                fontSize: 16,
                color: Colors.black26,
                fontWeight: FontWeight.bold),
          ),
          Container(
            height: MediaQuery.of(context).size.height /
                6.3, // Adjust the height as needed
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: userList.length,
              itemBuilder: (context, index) {
                currentUser = userList[index];
                print("its give current index ? ${currentUser}");
                // currentUser = userList[selectedIndex!];

                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            selectedUser: userList[index],
                            socket: socket!,
                          ),
                        ),
                      );
                    });


                    print("Selected index: $selectedIndex");
                    print("Selected user: ${userList[selectedIndex!]}");
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: index == selectedIndex ? Colors.blue : null,
                      // Change the color for selected item
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.blue,
                              // Set your desired background color
                              child: Text(
                                currentUser != null && currentUser!.isNotEmpty
                                    ? currentUser![0]
                                    .toUpperCase() // Display the first letter in uppercase
                                    : '',
                                style: TextStyle(
                                    color: Colors.white,
                                    // Set your desired text color
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(currentUser.toString().trim()),
                                Icon(
                                  Icons.do_not_disturb_on_total_silence_rounded,
                                  color: Colors.green.shade600,
                                  size: 10,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

        ],
      ),
    );
  }


}
