// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:social/search.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:social/receiverMessage.dart';

// class RecievedMessages extends StatefulWidget {
//   const RecievedMessages({super.key});

//   @override
//   State<RecievedMessages> createState() => _RecievedMessagesState();
// }

// class _RecievedMessagesState extends State<RecievedMessages> {
//   String ipconfig = '192.168.224.26';
//   List<dynamic> outputMessage = [];
//   String email = '';
//   List<dynamic> messagesId = [];
//   List<dynamic> listEmail = [];
//   List<dynamic> unrr = [];
//   Set<dynamic> seenMessages = {}; // To store seen message IDs
//   late WebSocketChannel channel;
//   late WebSocketChannel backseenchannel;
//   late WebSocketChannel backReadchannel;
//   late WebSocketChannel deleteNoUnreadchannel;
//   late WebSocketChannel unreadChannel; // from chats page regarding seenmessages to update here
//   // Unread message count for each email
//   Map<String, int> unreadCounts = {};

//   Future<void> noUnread() async {
//     var myurl = "http://$ipconfig/apisocial/noUnread.php";
//     var res = await http.post(Uri.parse(myurl), body: {'activeEmail': email});
//     if (res.statusCode == 200) {
//       var jsonRes = json.decode(res.body);
//       print('I\'ve got the $jsonRes');

//       // Group messages by email and count the number of unread messages for each email
//       Map<String, int> unreadCountByEmail = {};
//        (var message in jsonRes) {
//         var emailKey = message['email'];
//         if (unreadCountByEmail.containsKey(emailKey)) {
//           unreadCountByEmail[emailKey] = unreadCountByEmail[emailKey]! + 1;
//         } else {
//           unreadCountByEmail[emailKey] = 1;
//         }
//       };


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

    
// // both persons are actively chatting and comes back here seen icon is updated accordingly
//     backseenchannel = IOWebSocketChannel.connect('ws://$ipconfig:8083');
//     backseenchannel.sink.add(json.encode({
//       'recieverEmail': email
//     }));
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
//             //  unreadCounts = {};
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

//     // dont disturb this code below working cracy
// //  backread controls when e.g user goes into reciever screen setting seen icon here to be true or false 
//  backReadchannel = IOWebSocketChannel.connect('ws://$ipconfig:8085');
//     backReadchannel.sink.add(json.encode({
//       'recieverEmail': email
//     }));
//     backReadchannel.stream.listen(
//       (message) {
//         print("Readchannel through backWebSocket: $message");  // Debug print

//           var decodedMessage = json.decode(message);
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
//         print("Readchannel through back WebSocket: $outputMessage");
//       },
//       onError: (error) {
//         print("WebSocket error: $error");
//       },
//       onDone: () {
//         print("WebSocket connection closed");
//       },
//     );


//       unreadChannel = IOWebSocketChannel.connect('ws://$ipconfig:8084');
//     unreadChannel.sink.add(json.encode({
//       'recieverEmail': email
//     }));
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

    

//     deleteNoUnreadchannel = IOWebSocketChannel.connect('ws://$ipconfig:8086');
//      deleteNoUnreadchannel.sink.add(json.encode({
//       'recieverEmail': email
//     }));
//      deleteNoUnreadchannel.stream.listen(
//       (message) {
//         print("delete through backWebSocket: $message");  // Debug print

//           var decodedMessage = json.decode(message);
//         setState(() {
//           outputMessage = outputMessage.map((message) {
//             print('email through ${message['email']}');
//             print('Email decoded through ${decodedMessage['Email']}');
           
//               unreadCounts[message['email']] = 0;
//               unreadCounts[message['activeEmail']] = 0;
//             // }

//             //  if (message['activeEmail'] == email){
//             //    unreadCounts[message['email']] = 0;
//             // }
            
           
//             // if (message['email'] == decodedMessage['Email']) {
             
             
//             // }
//             return message;
//           }).toList();
          
//         });
//         print("delete through back WebSocket: $outputMessage");
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
//       'activeEmail': email,
//     });

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
//           var picUrl = "http://$ipconfig/apisocial/userData.php";

//           var picResponse = await http.post(Uri.parse(picUrl), body: {
//             'email': messageEmail,
//           });

//           if (picResponse.statusCode == 200) {
//             var outResponse = json.decode(picResponse.body);
//             List<dynamic> dataList = outResponse['data'];

//             for (var data in dataList) {
//               lastUserProfilePics[messageEmail] = data['image_01'];
//             }
//           }
//         }

//         List<dynamic> lastMessagesList = lastMessages.values.toList();
//         lastMessagesList.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

//         setState(() {
//           outputMessage = lastMessagesList.map((message) {
//             String messageEmail = message['email'] == email ? message['activeEmail'] : message['email'];
//             message['profilepic'] = lastUserProfilePics[messageEmail];
//             lastMessagesId[messageEmail] = message['id'];
//             print("Assigned profile pic: ${message['profilepic']} for email: $messageEmail"); // Debug print
//             return message;
//           }).toList();
//         });

//         List<dynamic> lastMessagesIdList = lastMessagesId.values.toList();
//         setState(() {
//           messagesId = lastMessagesIdList;
//         });

//         print('"Assigned ids: $messagesId');

//         // print('setting out $outputMessage');
//       }
//     }

//     // await noUnread();
//     await theMessageSeen();
//   }

//   Future<void> _processUnreadMessage(dynamic decodedMessage) async {
//     setState(() {
//       outputMessage = outputMessage.map((message) {
//         print('email eamil through ${message['activeEmail']}');
//         print('email eamil through ${decodedMessage['Email']}');
//         if (message['activeEmail'] == decodedMessage['Email']) {
//           noUnread();
//           print("read the data from unread");
//         }
//         return message;
//       }).toList();
//     });
//     print("unread unread through back WebSocket: $outputMessage");
//   }

//   String _generateEmailPairKey(String email1, String email2) {
//     List<String> emailPair = [email1, email2];
//     emailPair.sort(); // Sort to ensure the key is the same regardless of order
//     return emailPair.join("_");
//   }
//   @override
//   void initState() {
//     super.initState();
//     userMessages();
//   }

//   @override
//   void dispose() {
//     channel.sink.close();
//     backseenchannel.sink.close();
//     unreadChannel.sink.close();
//     deleteNoUnreadchannel.sink.close();
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
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Text('inbox', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600, color: Colors.white)),
//                   ),
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
//             child: GestureDetector(
//                                     onTap: (){
//                                       // Navigator.push(context, MaterialPageRoute(builder: (context) => SearchMessages()));
//                                     },
//                    child: Container(
//                     padding: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
//                     decoration: BoxDecoration(
//                       color:  Color(0xFF248560),
//                       borderRadius: BorderRadius.circular(10)
//                     ),
//                      child: Row(
//                       children: [
//                         Icon(Icons.messenger_rounded, color: Colors.white,),
//                         SizedBox(width: 8,),
//                         Text('Messages', style: TextStyle(color: Colors.white),),
//                       ],
//                                      ),
//                    ),
//                                   ),
                   
//           ),
//           SizedBox(height: 20),
//           Expanded(
//             child: ListView.builder(
//               itemCount: outputMessage.length,
//               itemBuilder: (context, index) {
               
//                 var message = outputMessage[index];
//                 var unreadCount;

//                 // the  message['email'] changes with websocket and db that why its like so below
//                 message['email'] ==  email ? unreadCount = unreadCounts[message['activeEmail']] ?? 0 :
//                  unreadCount = unreadCounts[message['email']] ?? 0; // Get unread count for this email
//                print('ui ui email ${message['email']}');
//                 print('ui ui mesage $message');
//                 print('ui ui mesage $unreadCount');
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
//                                               // message['email'] == email ? Text('you: ', style: TextStyle(fontSize: 15)) : Container(),
//                                               Text(message['myMessage'], style: TextStyle(fontSize: 15)),
//                                             ],
                                            
//                                           ),
//                                           // Display unread count
//                                            if (unreadCount > 0)
//                                              Text('$unreadCount unread messages', style: TextStyle(fontSize: 15, color: Colors.red),),
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
