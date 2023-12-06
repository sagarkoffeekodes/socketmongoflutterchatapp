import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ChatScreen extends StatefulWidget {
  final String selectedUser;
  final io.Socket socket;

  const ChatScreen({Key? key, required this.selectedUser, required this.socket})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  io.Socket? socket;
  final FocusNode textFocusNode = FocusNode();
  TextEditingController messageController = TextEditingController();
  List<String> messagesList = [];

  @override
  void initState() {
    super.initState();
    initSocket();
  }

  void initSocket() {


    // socket!.connect();

    widget.socket!.on('privateMessage', (data) {
      print('Received privateMessage: $data');
      setState(() {
        messagesList.add('${data['message']}');
      });
    });
    widget.socket!.on('errorMessage', (message) {
      print('Error: $message');
    });
  }

  void sendPrivateMessage() {
    final to = widget.selectedUser;
    final message = messageController.text.trim();

    if (to.isNotEmpty && message.isNotEmpty) {
      widget.socket!.emit('privateMessage', {'to': to, 'message': message});
      setState(() {
        messagesList.add('You to $to: $message');
        messageController.clear();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Socket.IO Chat - ${widget.selectedUser}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messagesList.length,
              itemBuilder: (context, index) {
                final isCurrentUserMessage =
                    messagesList[index].startsWith('You');


                return Align(
                  alignment: isCurrentUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      color:
                          isCurrentUserMessage ? Colors.lightBlue : Colors.grey,
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
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    sendPrivateMessage();
                  },
                  child: Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.socket!.dispose();
    super.dispose();
  }
}

// class _ChatScreenState extends State<ChatScreen> {
//
//   TextEditingController messageController = TextEditingController();
//   List<Map<String, String>> messagesList = [];
//   bool isMounted = false;
//   @override
//   void dispose() {
//     isMounted = false;
//     messageController.dispose();
//
//     // Disconnect the socket when the screen is disposed
//     widget.socket.disconnect();
//
//     // Dispose of the socket
//     widget.socket.dispose();
//
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     isMounted = true;
//      recMessage();
//   }
//   void recMessage(){
//     widget.socket.on('privateMessage', (data) {
//       print('Received privateMessage: $data');
//       // Ensure the widget is still mounted before calling setState
//       if (isMounted) {
//         setState(() {
//           messagesList.add({'from': data['from'], 'message': data['message']});
//         });
//       }
//     });
//   }
//   void sendMessage(String message) {
//     // Send a private message to the selected user
//     widget.socket.emit('privateMessage', {
//       'to': widget.selectedUser,
//       'message': message,
//     });
//
//     // Update the UI with the sent message if the widget is mounted
//     if (isMounted) {
//       setState(() {
//         messagesList.add({'from': 'You', 'message': message});
//       });
//     }
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Chat with ${widget.selectedUser}"),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: messagesList.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   // Differentiate sent and received messages based on 'from' field
//                   title: Text(
//                     '${messagesList[index]['from']}: ${messagesList[index]['message']}',
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: messageController,
//                     decoration: InputDecoration(
//                       hintText: 'Type your message...',
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: () {
//                     sendMessage(messageController.text);
//                     messageController.clear();
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
