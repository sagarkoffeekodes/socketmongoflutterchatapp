import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ChatScreen extends StatefulWidget {
  final String username;

  ChatScreen({required this.username});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  io.Socket? socket;
  String? currentUser;
  TextEditingController usernameController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  TextEditingController recipientController = TextEditingController();
  TextEditingController roomController = TextEditingController();

  List<String> userList = [];
  List<String> messagesList = [];

  final FocusNode textFocusNode = FocusNode();


  @override
  void initState() {
    super.initState();
    initSocket();
  }

  void initSocket() {
    socket = io.io('https://chatapp1-d12f.onrender.com/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket!.connect();
    socket!.emit('setUsername', widget.username);

    socket!.on('userList', (data) {
      print('Received userList data: $data');
      setState(() {
        // userList.clear(); // Clear the existing list
        userList = List<String>.from(data);
      });
    });

    socket!.on('privateMessage', (data) {
      print('Received privateMessage: $data');
      setState(() {
        messagesList.add('${data['from']}: ${data['message']}');
      });
    });
    // socket!.on('roomMessage', (data) {
    //   setState(() {
    //     messagesList.add('${data['from']} (Room): ${data['message']}');
    //   });
    // });

    socket!.on('errorMessage', (message) {
      print('Error: $message');
    });
  }

  void setUsername() {
    final username = usernameController.text.trim();
    if (username.isNotEmpty) {
      socket!.emit('setUsername', username);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Username cannot be empty'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void sendPrivateMessage() {

    final to = userList[selectedIndex!].toString();
    print("current user ${to}");
    final message = messageController.text.trim();
    final room = roomController.text.trim();

    if (to.isNotEmpty && message.isNotEmpty) {
      socket!
          .emit('privateMessage', {'to': to, 'message': message, 'room': room});
      setState(() {
        messagesList.add('You to $to: $message');
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Recipient and message cannot be empty'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  // void joinRoom() {
  //   final room = roomController.text.trim();
  //   if (room.isNotEmpty) {
  //     socket!.emit('joinRoom', room);
  //   }
  // }
  //
  // void leaveRoom() {
  //   final room = roomController.text.trim();
  //   if (room.isNotEmpty) {
  //     socket!.emit('leaveRoom', room);
  //   }
  // }
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
        title: Text('Socket.IO Chat - ${widget.username}'),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      print("return message ${messagesList[index]}");

                      final isCurrentUserMessage = messagesList[index].startsWith(
                          'You'); // Adjust this condition based on your message format

                      return Align(
                        alignment: isCurrentUserMessage
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          margin: EdgeInsets.symmetric(vertical: 4.0),
                          decoration: BoxDecoration(
                            color: messagesList[index].startsWith('You')
                                ? Colors.lightBlue
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            messagesList[index],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                            labelText: 'Type a message...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      ElevatedButton(
                        onPressed:(){
                          sendPrivateMessage();
                          setState(() {
                            messageController.clear();
                            FocusScope.of(context).requestFocus(FocusNode());
                          });
                        },
                        child: Text('Send'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
