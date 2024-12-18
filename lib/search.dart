// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:social/receiverMessage.dart';

// class SearchMessages extends StatefulWidget {
//   const SearchMessages({super.key});

//   @override
//   State<SearchMessages> createState() => _SearchMessagesState();
// }

// class _SearchMessagesState extends State<SearchMessages> {
//   String ipconfig = '192.168.96.26';
//   List<dynamic> outputMessage = [];
//   String email = '';
//   List<dynamic> messagesId = [];
//   List<dynamic> listEmail = [];
//   List<dynamic> unrr = [];
//   Set<dynamic> seenMessages = {}; // To store seen message IDs
//   late WebSocketChannel channel;
//   late WebSocketChannel backseenchannel;
//   late WebSocketChannel backReadchannel;
//   late WebSocketChannel unreadChannel; // from chats page regarding seenmessages to update here
//   // Unread message count for each email
//   Map<String, int> unreadCounts = {};

//   // Add this to your state
//   TextEditingController searchController = TextEditingController();
//   List<dynamic> filteredMessages = [];

//   @override
//   void initState() {
//     super.initState();
//     userMessages();
//     // Initialize the filteredMessages list with all messages
//     searchController.addListener(_filterMessages);
//   }

//   Future<void> noUnread() async {
//     var myurl = "http://$ipconfig/apisocial/noUnread.php";
//     var res = await http.post(Uri.parse(myurl), body: {'activeEmail': email});
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
//         unrr = unreadCounts.values.toList();
//       });
//       print('I\'ve got the number $unreadCounts.t'); 
//       print('I\'ve got the number $unrr');
//     }
//   }

//   Future<void> theMessageSeen() async {
//     var myurl = "http://$ipconfig/apisocial/allMessageSeen.php";
//     var res = await http.post(Uri.parse(myurl), body: {'messagesId': json.encode(messagesId)});

//     if (res.statusCode == 200) {
//       var jsonRes = json.decode(res.body);
//       print("Server response: $jsonRes"); // Debug print
//       setState(() {
//         seenMessages = Set.from(jsonRes['success']);
//         outputMessage = outputMessage.map((message) {
//           if (seenMessages.contains(message['id'])) {
//             message['recieverSeenMessage'] = true;
//             print("Updated messages: ${message['id']}");
//           }
//           return message;
//         }).toList();
//         print("Updated messages: $outputMessage"); // Debug print
//       });
//     }
//   }

//   Future<void> UniqueEmails() async {
//     print('object');
//   }

//   Future<void> userMessages() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     email = preferences.getString('email') ?? '';

//     await noUnread();

//     unreadChannel = IOWebSocketChannel.connect('ws://$ipconfig:8084');
    
//     channel = IOWebSocketChannel.connect('ws://$ipconfig:8081');
//     channel.sink.add(json.encode({'recieverEmail': email}));

//     channel.stream.listen(
//       (message) {
//         print("Message received through WebSocket: $message"); // Debug print

//         var decodedMessage = json.decode(message);

//         setState(() {
//           Map<String, dynamic> lastMessages = {
//             for (var msg in outputMessage) _generateEmailPairKey(msg['activeEmail'], msg['email']): msg
//           };

//           // Update the message
//           String emailPairKey = _generateEmailPairKey(decodedMessage['activeEmail'], decodedMessage['email']);

//           if (lastMessages.containsKey(emailPairKey)) {
//             var existingMessage = lastMessages[emailPairKey];
//             decodedMessage['profilepic'] = existingMessage['profilepic'];
//             decodedMessage['name'] = existingMessage['name'];
//           }

//           // Insert or update the message at the top of the list
//           lastMessages[emailPairKey] = decodedMessage;
//           outputMessage = [decodedMessage, ...lastMessages.values.where((msg) => msg != decodedMessage).toList()];
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

//     backseenchannel = IOWebSocketChannel.connect('ws://$ipconfig:8083');
//     backseenchannel.sink.add(json.encode({'recieverEmail': email}));
//     backseenchannel.stream.listen(
//       (message) {
//         print("backseenchannel through backWebSocket: $message");  // Debug print

//         var decodedMessage = json.decode(message);
//         setState(() {
//           outputMessage = outputMessage.map((message) {
//             print('email eamil through ${message['email']}');
//             print('email eamil through ${decodedMessage['Email']}');
//             if (message['email'] == decodedMessage['Email']) {
//               message['recieverSeenMessage'] = true;
//             }
//             return message;
//           }).toList();
//         });
//         print("backseenchannel through back WebSocket: $outputMessage");
//       },
//       onError: (error) {
//         print("WebSocket error: $error");
//       },
//       onDone: () {
//         print("WebSocket connection closed");
//       },
//     );
    
//     backReadchannel = IOWebSocketChannel.connect('ws://$ipconfig:8085');
//     backReadchannel.sink.add(json.encode({'recieverEmail': email}));
//     backReadchannel.stream.listen(
//       (message) {
//         print("Readchannel through backWebSocket: $message");  // Debug print

//         var decodedMessage = json.decode(message);
//         setState(() {
//           outputMessage = outputMessage.map((message) {
//             print('email eamil through ${message['email']}');
//             print('email eamil through ${decodedMessage['recipientEmail']}');
//             if (message['email'] == decodedMessage['recipientEmail']) {
//               unreadCounts = {};
//             }
//             return message;
//           }).toList();
//         });
//         print("Readchannel through back WebSocket: $outputMessage");
//       },
//       onError: (error) {
//         print("WebSocket error: $error");
//       },
//       onDone: () {
//         print("WebSocket connection closed");
//       },
//     );

//     unreadChannel.sink.add(json.encode({'recieverEmail': email}));
//     unreadChannel.stream.listen(
//       (message) async {
//         print("unread through backWebSocket: $message");  // Debug print

//         var decodedMessage = json.decode(message);
//         await _processUnreadMessage(decodedMessage);
//       },
//       onError: (error) {
//         print("WebSocket error: $error");
//       },
//       onDone: () {
//         print("WebSocket connection closed");
//       },
//     );

//     var url = "http://$ipconfig/apisocial/recieved_messages.php";
//     var response = await http.post(Uri.parse(url), body: {'activeEmail': email});

//     if (response.statusCode == 200) {
//       var jsonResponse = json.decode(response.body);

//       Map<String, dynamic> lastMessages = {};
//       Set<String> processedEmails = Set();

//       for (var message in jsonResponse) {
//         String messageEmail = message['email'] == email ? message['activeEmail'] : message['email'];
//         message['recieverSeenMessage'] = false;

//         // Create a unique key for the email pair
//         List<String> emailPair = [message['email'], message['activeEmail']];
//         emailPair.sort(); // Sort to ensure the key is the same regardless of order
//         String emailPairKey = emailPair.join("_");

//         // Only keep the latest message for each unique email pair
//         if (!lastMessages.containsKey(emailPairKey) || message['timestamp'].compareTo(lastMessages[emailPairKey]['timestamp']) > 0) {
//           lastMessages[emailPairKey] = message;
//         }

//         if (!processedEmails.contains(messageEmail)) {
//           processedEmails.add(messageEmail);
//         }
//       }

//       var myurl = "http://$ipconfig/apisocial/chatList.php";
//       var myresponse = await http.post(Uri.parse(myurl), body: {
//         'activeEmail': email,
//         'email': json.encode(processedEmails.toList()),
//       });

//       if (myresponse.statusCode == 200) {
//         var theResponse = json.decode(myresponse.body);
//         Map<String, String> lastUserProfilePics = {};
//         Map<String, dynamic> lastMessagesId = {};

//         for (var message in theResponse) {
//           String messageEmail = message['email'] == email ? message['activeEmail'] : message['email'];
//           var picUrl = "http://$ipconfig/apisocial/profile_img/${message['profilepic']}";

//           List<String> emailPair = [message['email'], message['activeEmail']];
//           emailPair.sort();
//           String emailPairKey = emailPair.join("_");

//           if (lastMessages.containsKey(emailPairKey)) {
//             lastMessages[emailPairKey]['profilepic'] = message['profilepic'];
//             lastMessages[emailPairKey]['name'] = message['name'];
//             lastMessagesId[emailPairKey] = lastMessages[emailPairKey];
//           }

//           lastUserProfilePics[messageEmail] = picUrl;
//         }

//         setState(() {
//           outputMessage = lastMessages.values.toList();
//           messagesId = lastMessagesId.values.map((message) => message['id']).toList();
//         });

//         await theMessageSeen();
//       }
//     } else {
//       print("Server error: ${response.statusCode}");
//     }
//   }

//   Future<void> _processUnreadMessage(decodedMessage) async {
//     var senderEmail = decodedMessage['senderEmail'];
//     var recipientEmail = decodedMessage['recipientEmail'];
//     print('sender $senderEmail');
//     print('sender $recipientEmail');

//     if (recipientEmail == email) {
//       unreadCounts[senderEmail] = (unreadCounts[senderEmail] ?? 0) + 1;
//     } else {
//       unreadCounts[recipientEmail] = (unreadCounts[recipientEmail] ?? 0) + 1;
//     }

//     print('Unread count updated for $senderEmail or $recipientEmail: ${unreadCounts[senderEmail] ?? unreadCounts[recipientEmail]}');

//     setState(() {});
//   }

//   void _filterMessages() {
//     setState(() {
//       if (searchController.text.isEmpty) {
//         filteredMessages = outputMessage;
//       } else {
//         filteredMessages = outputMessage.where((message) {
//           return message['email'].toLowerCase().contains(searchController.text.toLowerCase()) ||
//                  message['activeEmail'].toLowerCase().contains(searchController.text.toLowerCase()) ||
//                  message['person'].toLowerCase().contains(searchController.text.toLowerCase()) ||
//                  message['myMessage'].toLowerCase().contains(searchController.text.toLowerCase());
//         }).toList();
//       }
//     });
//   }

//   String _generateEmailPairKey(String email1, String email2) {
//     List<String> emailPair = [email1, email2];
//     emailPair.sort();
//     return emailPair.join("_");
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     channel.sink.close();
//     backseenchannel.sink.close();
//     unreadChannel.sink.close();
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
//                 Text('Chats', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600)),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.green[400],
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                   // child: Padding(
//                   //   const EdgeInsets.all(10.0),
//                   //   child: Text('inbox', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600, color: Colors.white)),
//                   // ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 20),
//           Container(
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: Colors.black,
//                 width: 1,
//               ),
//               borderRadius: BorderRadius.circular(50),
//             ),
//             child: TextField(
//               controller: searchController,
//               decoration: InputDecoration(
//                 suffixIcon: IconButton(
//                   onPressed: () {},
//                   icon: Icon(Icons.search),
//                 ),
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//           SizedBox(height: 20),
//           Expanded(
//             child: ListView.builder(
//               itemCount: filteredMessages.length,
//               itemBuilder: (context, index) {
//                 var message = filteredMessages[index];
//                 var unreadCount = message['email'] == email
//                     ? unreadCounts[message['activeEmail']] ?? 0
//                     : unreadCounts[message['email']] ?? 0;

//                 String messageEmail = message['email'] == email ? message['activeEmail'] : message['email'];
//                 String? profilePicUrl = message['profilepic'] != null
//                     ? "http://$ipconfig/apisocial/profile_img/${message['profilepic']}"
//                     : null;

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
//                                     builder: (context) => MobileMessage(dataUrl: messageEmail),
//                                   ),
//                                 );
//                               },
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Container(
//                                         width: 80,
//                                         height: 80,
//                                         child: ClipRRect(
//                                           borderRadius: BorderRadius.circular(100),
//                                           child: profilePicUrl == null
//                                               ? Icon(Icons.person_add_alt_rounded, size: 80, color: Colors.white)
//                                               : Image.network(profilePicUrl, fit: BoxFit.cover),
//                                         ),
//                                       ),
//                                       SizedBox(width: 10),
//                                       Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Text(message['person'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
//                                           Text(message['email'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
//                                           Text(message['activeEmail'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
//                                           Row(
//                                             children: [
//                                               message['recieverSeenMessage'] == true
//                                                   ? Icon(Icons.double_arrow)
//                                                   : Container(),
//                                               Text(message['myMessage'], style: TextStyle(fontSize: 15)),
//                                             ],
//                                           ),
//                                           if (unreadCount > 0)
//                                             Text(
//                                               '$unreadCount unread messages',
//                                               style: TextStyle(fontSize: 15, color: Colors.red),
//                                             ),
//                                         ],
//                                       ),
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
