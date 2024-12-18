// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:social/receiverMessage.dart';

// class RecievedMessages extends StatefulWidget {
//   const RecievedMessages({super.key});

//   @override
//   State<RecievedMessages> createState() => _RecievedMessagesState();
// }

// class _RecievedMessagesState extends State<RecievedMessages> {
//   String ipconfig = '192.168.104.26';
//   List<dynamic> outputMessage = [];
//   String email = '';
//   List<dynamic> messagesId = [];
//   Set<dynamic> seenMessages = {};  // To store seen message IDs
//   late WebSocketChannel channel;
//   late WebSocketChannel seenchannel_2;

//   // Unread message count for each email
//   Map<String, int> unreadCounts = {};

//   Future<void> noUnread() async {
//     var myurl = "http://$ipconfig/apisocial/noUnread.php";
//     var res = await http.post(Uri.parse(myurl), body: {
//       'activeEmail': email
      
//     });
//     if (res.statusCode == 200) {
//       var jsonRes = json.decode(res.body);
//       print('I\'ve got the $jsonRes');

//       // Group messages by email and count the number of unread messages for each email
//       Map<String, int> unreadCountByEmail = {};
//       for (var message in jsonRes) {
//         var emailKey = message['email'];
//         if (unreadCountByEmail.containsKey(emailKey)) {
//           unreadCountByEmail[emailKey] = unreadCountByEmail[emailKey]! + 1;
//         } else {
//           unreadCountByEmail[emailKey] = 1;
//         }
//       }

//       // Update the state with unread counts
//       setState(() {
//         unreadCounts = unreadCountByEmail;
//       });
//     }
//   }

//   Future<void> theMessageSeen() async {
//     var myurl = "http://$ipconfig/apisocial/allMessageSeen.php";
//     var res = await http.post(Uri.parse(myurl), body: {
//       'messagesId': json.encode(messagesId)
//     });

//     if (res.statusCode == 200) {
//       var jsonRes = json.decode(res.body);
//       print("Server response: $jsonRes");  // Debug print
//       setState(() {
//         seenMessages = Set.from(jsonRes['success']);
//         outputMessage = outputMessage.map((message) {
//           if (seenMessages.contains(message['id'])) {
//             message['recieverSeenMessage'] = true;
//             print("Updated messages: ${message['id']}");
//           }
//           return message;
//         }).toList();
//         print("Updated messages: $outputMessage");  // Debug print
//       });
//     }
//   }

//   Future<void> userMessages() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     setState(() {
//       email = preferences.getString('email') ?? '';
//     });

//     channel = IOWebSocketChannel.connect('ws://$ipconfig:8081');
//     channel.sink.add(json.encode({
//       'recieverEmail': email
//     }));

//     await noUnread();

//     channel.stream.listen(
//       (message) {
//         print("Message received through WebSocket: $message");  // Debug print

//         var decodedMessage = json.decode(message);

//         setState(() {
//           Map<String, dynamic> lastMessages = {
//             for (var msg in outputMessage) msg['email']: msg
//           };

//           // Update the message
//           var emailKey = decodedMessage['email'];
//           if (lastMessages.containsKey(emailKey)) {
//             var existingMessage = lastMessages[emailKey];
//             decodedMessage['profilepic'] = existingMessage['profilepic'];
//             decodedMessage['name'] = existingMessage['name'];
//           }

//           lastMessages[emailKey] = decodedMessage;
//           outputMessage = [decodedMessage, ...lastMessages.values.where((msg) => msg['email'] != decodedMessage['email']).toList()];
//         });
//         print("The output message through WebSocket: $outputMessage");
//       },
//       onError: (error) {
//         print("WebSocket error: $error");
//       },
//       onDone: () {
//         print("WebSocket connection closed");
//       },
//     );

//     seenchannel_2 = IOWebSocketChannel.connect('ws://$ipconfig:8082');
//     seenchannel_2.sink.add(json.encode({
//       'recieverEmail': email
//     }));
//     seenchannel_2.stream.listen(
//       (message) {
//         print("Message received through backWebSocket: $message");  // Debug print

//         var decodedMessage = json.decode(message);
//         setState(() {
//           outputMessage = outputMessage.map((msg) {
//             if (msg['email'] == decodedMessage['Email']) {
//               msg['recieverSeenMessage'] = true;
//             }
//             return msg;
//           }).toList();
//         });
//         print("The output message through back WebSocket: $outputMessage");
//       },
//       onError: (error) {
//         print("WebSocket error: $error");
//       },
//       onDone: () {
//         print("WebSocket connection closed");
//       },
//     );

//     var url = "http://$ipconfig/apisocial/recieved_messages.php";

//     var response = await http.post(Uri.parse(url), body: {
//       'activeEmail': email
//     });

//     if (response.statusCode == 200) {
//       var jsonResponse = json.decode(response.body);

//       // Create maps to store the last profile picture and name for each unique email
//       Map<String, String> lastUserProfilePics = {};
//       Map<String, String> lastUserNames = {};

//       // Iterate through the messages to find the last profile picture and name for each email though same activeEmail
//       for (var message in jsonResponse) {
//         if (message['person'] == 'user') {
//           lastUserProfilePics[message['email']] = message['profilepic'];
//           lastUserNames[message['email']] = message['name'];
//         }
//       }

//       // Create a map to store the last message for each unique email
//       Map<String, dynamic> lastMessages = {};
//       Map<String, dynamic> lastMessagesId = {};

//       // Iterate through the messages again to assign the correct profile picture and name
//       for (var message in jsonResponse) {
//         String messageEmail = message['email'];
//         if (lastUserProfilePics.containsKey(messageEmail)) {
//           message['profilepic'] = lastUserProfilePics[messageEmail];
//           message['name'] = lastUserNames[messageEmail];
//         }
//         message['recieverSeenMessage'] = false; // Initialize as false
//         lastMessages[messageEmail] = message;
//         lastMessagesId[messageEmail] = message['id'];
//       }

//       // Convert the map values back to a list
//       List<dynamic> lastMessagesList = lastMessages.values.toList();
//       List<dynamic> lastMessagesIdList = lastMessagesId.values.toList();

//       setState(() {
//         // Prepend the new messages to the top of the list
//         outputMessage = lastMessagesList..sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
//         messagesId = lastMessagesIdList;
//         print(lastMessagesIdList);
//       });

//       print('Last User Profile outputMessage: $outputMessage');
//       print('Last User Names: $lastUserNames');
//       await theMessageSeen();
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     userMessages();
//   }

//   @override
//   void dispose() {
//     channel.sink.close();
//     seenchannel_2.sink.close(); // Close the second WebSocket channel
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 30, right: 30),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Chats', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.green[400],
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Text('inbox', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600, color: Colors.white),),
//                   )),
//               ],
//             ),
//           ),
//           SizedBox(height: 20,),
//           Container(
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: Colors.black,
//                 width: 1,
//               ),
//               borderRadius: BorderRadius.circular(50),
//             ),
//             child: TextField(
//               decoration: InputDecoration(
//                 suffixIcon: IconButton(onPressed: (){}, icon: Icon(Icons.search)),
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//           SizedBox(height: 20,),
//           Expanded(
//             child: ListView.builder(
//               itemCount: outputMessage.length,
//               itemBuilder: (context, index) {
//                 var message = outputMessage[index];
//                 var unreadCount = unreadCounts[message['email']] ?? 0;  // Get unread count for this email

//                 return Container(
//                   padding: EdgeInsets.all(10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         padding: EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => MobileMessage(dataUrl: message['email']),
//                                   ),
//                                 );
//                               },
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     children: [
//                                       message['profilepic'].isEmpty ? 
//                                        Container(
//                                          width: 80,
//                                          height: 80,
//                                          decoration: BoxDecoration(
//                                            color: Colors.black12,
//                                            border: Border.all(
//                                              color: Colors.white,
//                                              width: 5,
//                                            ),
//                                            borderRadius: BorderRadius.circular(100),
//                                          ),
//                                          child: Icon(Icons.person_add_alt_rounded, size: 80, color: Colors.white,),
//                                        )
//                                        :
//                                        Container(
//                                          width: 80,
//                                          height: 80,
//                                          child: ClipRRect(
//                                            borderRadius: BorderRadius.circular(100),
//                                            child: Image.network(
//                                              "http://$ipconfig/apisocial/profile_img/${message['profilepic']}",
//                                              fit: BoxFit.cover, // Ensure the image covers the entire space
//                                            ),
//                                          ),
//                                        ),
//                                        SizedBox(width: 10,),
//                                        Column(
//                                          crossAxisAlignment: CrossAxisAlignment.start,
//                                          children: [
//                                            Text(message['person'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600,),),
//                                            Row(
//                                              children: [
//                                                message['recieverSeenMessage'] == true && message['person'] == 'reciever'? Icon(Icons.double_arrow) : Container(),
//                                                message['person'] == 'reciever' ? Text('you: ', style: TextStyle(fontSize: 15,),) : Container(),
//                                                Text(message['myMessage'], style: TextStyle(fontSize: 15,),),
//                                              ],
//                                            ),
//                                            // Display unread count
//                                            if (unreadCount > 0)
//                                              Text('$unreadCount unread messages', style: TextStyle(fontSize: 15, color: Colors.red),),
//                                          ],
//                                        ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
