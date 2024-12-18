// // import 'dart:convert';
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:http/http.dart' as http;


// // class MobileMessage extends StatefulWidget {
// //    final String dataUrl;
// //   const MobileMessage({super.key, required this.dataUrl});

  

// //   @override
// //   State<MobileMessage> createState() => _MobileMessageState();
// // }

// // class _MobileMessageState extends State<MobileMessage> {
// //   String ipconfig = '192.168.55.26';
// //   List<dynamic> outputMessage = [];
// //   String person = 'user';
// //   String userName = '';
// //   String email = '';
// //   String activeEmail = '';
// //   var userData;
// //    String storeName = '';
// //   var mainImage;
// //   File? _image;
// //   final picker = ImagePicker();

// //   TextEditingController messageController = TextEditingController();



// //    Future<void> userDetails() async{

// //   SharedPreferences preferences = await SharedPreferences.getInstance();
// //   setState(() {
// //     email = preferences.getString('email') ?? '';
// //     // this email is the user currently logged in
// //   });

// //   setState(() {
// //     activeEmail = widget.dataUrl;
// //     allMessage();
// //     userProfile();
// //   });

   
 
// //      var url = "http://$ipconfig/apisocial/store_data.php";

// //     var response = await http.post(Uri.parse(url),
// //     body: {
// //         'email': activeEmail
// //     },
// //     );
// //    if(response.statusCode == 200){
// //     var jsonResponse = json.decode(response.body);
// //     if(jsonResponse['success'] == 'login successful'){
   
// //     setState(() {
// //       userData = jsonResponse['data'][0];
// //       storeName = userData['storeName'];
// //       // address = userData['address'];
// //       // storeType = userData['storeType'];
// //       mainImage = userData['image_01'];
// //     }); 
// //     // print(email);
// //     // print(userData);
// //     }
// //    }
// //    }

// //     Future<void> _getImageFromGallery() async {
    
// //   final pickedImage = await picker.pickImage(source: ImageSource.gallery);

// //     setState(() {
// //       if (pickedImage != null) {
// //         _image = File(pickedImage.path);
// //       } else {
// //         print('No image selected.');
// //       }
// //     });
// //   }

// //   Future<void> messageMe() async {
// //   final uri = Uri.parse("http://$ipconfig/apisocial/message.php");
// //   var request = http.MultipartRequest('POST', uri);
// //   request.fields['myMessage'] = messageController.text;
// //   request.fields['activeEmail'] = activeEmail;
// //   request.fields['email'] = email;
// //   request.fields['name'] = userName;
// //   request.fields['person'] = person;


// //   if (_image != null) {
// //     var pic = await http.MultipartFile.fromPath("image_01", _image!.path);
// //     request.files.add(pic);
// //   }

// //   var response = await request.send();

// //   if (response.statusCode == 200) {
// //     userDetails();
// //     allMessage();

// //      setState(() {
// //       messageController.clear();
// //     });

// //     // Clear image
// //     setState(() {
// //       _image = null;
// //     });

// //     }
// //   }

// // void allMessage() async {
// //   var myurl = "http://$ipconfig/apisocial/allMessage.php";
// //   var res = await http.post(Uri.parse(myurl),
// //   body: {
// //   'email': email,
// //   'activeEmail' : activeEmail
// //   });
// //   var jsonRes = json.decode(res.body);
// //   if (res.statusCode == 200) {
// //     setState(() {
// //       outputMessage = jsonRes;
// //     });
// //     print(jsonRes);
// //     print(outputMessage);
// //   }
// // }

// // Future<void> userProfile() async{
  
// //      var url = "http://$ipconfig/apisocial/userData.php";
// //     var response = await http.post(Uri.parse(url),
// //     body: {
// //         'email': email
// //     },
// //     );
// //    if(response.statusCode == 200){
// //     var jsonResponse = json.decode(response.body);
// //     if(jsonResponse['success'] == 'login successful'){
    
// //     setState(() {
// //        userData = jsonResponse['data'][0];
// //        userName = userData['name'];
// //       //  print('addressName: $addressName');
// //     }); 
      
// //     }
// //    }
// // }
     

// //  void cancelImage() {
// //     setState(() {
// //      _image = null;
// //     });
// //   }




    
// //   @override
// //   void initState(){
// //     super.initState();
// //     userDetails();
    
// //   }
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //      appBar: AppBar(
// //       title: Row(
// //         children: [
// //           // Text(storeName),
// //           Text('AMAKA'),

// //           SizedBox(width: 10,),
// //           Container(
// //            width: 50,
// //            height: 50,
// //         child: ClipRRect(
// //           borderRadius: BorderRadius.circular(100),
// //           child: Image.network(
// //                                   "http://$ipconfig/apisocial/registered_img/$mainImage",
// //                                   fit: BoxFit.cover, // Ensure the image covers the entire space
// //                                 ),
// //         ),
// //       ),
// //         ],
// //       ),
// //      ),

// //       body: Container(
// //         decoration: BoxDecoration(
// //            image: DecorationImage(
// //               image: NetworkImage("http://$ipconfig/apisocial/registered_img/$mainImage"), // Replace 'background_image.jpg' with your image asset path
// //               fit: BoxFit.cover, // You can adjust the fit as needed
// //             ),
// //         ),
// //         child: Column(
// //           children: [
        
// //             Expanded(
// //             child: ListView.builder(
// //               itemCount: outputMessage.length,
// //               itemBuilder: (context, index) {
// //                 var message = outputMessage[index];
// //                 return Container(
// //                   padding: EdgeInsets.all(10),
// //                   child: 
// //                    message['person'] == 'user' ? 

// //                    Expanded( 
// //                     child: Column(
                      
// //                       crossAxisAlignment: CrossAxisAlignment.end,
// //                       children: [
// //                         Container(
// //                           padding: EdgeInsets.all(10),
// //                           decoration: BoxDecoration(
// //                             borderRadius: BorderRadius.circular(20),
// //                             color: Colors.green[200],
// //                           ),
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               Text(message['myMessage'], style: TextStyle(fontSize: 20,),),
// //                               Text(message['email']),
// //                               // Text(comment['id'].toString(),),
// //                             ],
// //                           ),
// //                         ),
// //                         SizedBox(height: 10),
                    
// //                         message['image_01'].isEmpty ? Container():
// //                         Container(
// //                           color: Colors.black45,
// //                           width: 100,
// //                           child: Image.network(
// //                             "http://$ipconfig/practice/uploaded_img/${message['image_01']}",
// //                             // fit: BoxFit.cover, 
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   )
                  
// //                    :
                  
// //                    Expanded( 
                    
// //                     child: Column(
                      
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Container(
// //                           padding: EdgeInsets.all(10),
// //                           decoration: BoxDecoration(
// //                             borderRadius: BorderRadius.circular(20),
// //                             color: Colors.white,
// //                           ),
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               Text(message['myMessage'], style: TextStyle(fontSize: 20,),),
// //                               Text(message['email']),
// //                               // Text(comment['id'].toString(),),
// //                             ],
// //                           ),
// //                         ),
// //                         SizedBox(height: 10),
                    
// //                         message['image_01'].isEmpty ? Container():
// //                         Container(
// //                           color: Colors.black45,
// //                           width: 100,
// //                           child: Image.network(
// //                             "http://$ipconfig/practice/uploaded_img/${message['image_01']}",
// //                             // fit: BoxFit.cover, 
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                                      ),
// //                 );
// //               },
// //             ),
// //           ),
        
// //            Container(
// //             color: Colors.white,
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 _image != null ? Row(
// //                   children: [
// //                     Container(
// //                        padding: EdgeInsets.only(left: 20),
// //                       width: 80,
// //                       height: 80,
// //                       child: Image.file(
// //                         _image!,
// //                         fit: BoxFit.cover,
// //                       ),
// //                     ),
// //                     IconButton(onPressed: (){cancelImage();}, icon: Icon(Icons.cancel_outlined))
// //                   ],
// //                 ) : Container(),
        
// //             BottomAppBar(
// //              color: Colors.white,
// //                   child: Row(
// //                     children: <Widget>[
// //                       IconButton(
// //                         onPressed: (){ _getImageFromGallery(); },
// //                         icon: Icon(Icons.photo_library_rounded),
// //                       ),
// //                       Expanded(
// //                         child: Container(
// //                   decoration: BoxDecoration(
                  
// //                    border: Border.all(
// //                     color: Colors.black,
// //                     width: 1
// //                    ),
// //                                    borderRadius: BorderRadius.circular(50)
// //                   ),
// //                           child: Padding(
// //                             padding: const EdgeInsets.symmetric(horizontal: 10),
// //                             child: TextField(
// //                               controller: messageController,
// //                               decoration: InputDecoration(
// //                                 hintText: 'Type your message...',
// //                                 // border: OutlineInputBorder(),
// //                                border: InputBorder.none
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                       SizedBox(width: 8.0),
// //                       IconButton(
// //                         icon: Icon(Icons.send),
// //                         onPressed: () { messageMe(); },
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //            ],
// //             ),
// //           ),
        
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }



// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class MobileMessage extends StatefulWidget {
//   final String dataUrl;
//   const MobileMessage({super.key, required this.dataUrl});

//   @override
//   State<MobileMessage> createState() => _MobileMessageState();
// }

// class _MobileMessageState extends State<MobileMessage> {
//   String ipconfig = '192.168.104.26';
//   List<dynamic> outputMessage = [];
//   String person = 'user';
//   bool userSeenMessage = false;
//   String userName = '';
//   String email = '';
//   String activeEmail = '';
//   var lastMessage;
//   var mLastId;
//   List<int> unstoredId = [];
//   List<String> unstoredMessage = [];
//   var userData;
//   String storeName = '';
//   var mainImage;
//   String profileImage = '';
//   File? _image;
//   final picker = ImagePicker();
//   late WebSocketChannel channel;
//   late WebSocketChannel seenchannel;
//   late WebSocketChannel statusChannel;

//   late WebSocketChannel channel_2;
//   late WebSocketChannel seenchannel_2;
//   late WebSocketChannel statusChannel_2;
//   // late WebSocketChannel backseenchannel;

//   TextEditingController messageController = TextEditingController();

//   Future<void> messageSeen() async {
//   seenchannel_2.sink.add(json.encode({
//     'action': 'message_seen',
//     'person': 'reciever',
//     'recipientEmail': email,
//     'Email': email
//   }));
// }

// // Future<void> backMessageSeen() async {
// //   backseenchannel.sink.add(json.encode({
// //     'action': 'message_seen',
// //     'person': 'reciever',
// //     'recipientEmail': email,
// //     'activeEmail' : activeEmail
// //   }));
// // }

//  Future<void> userDetails() async {
//   SharedPreferences preferences = await SharedPreferences.getInstance();

//   channel = IOWebSocketChannel.connect('ws://$ipconfig:8081');
//   seenchannel = IOWebSocketChannel.connect('ws://$ipconfig:8082');
//   statusChannel = IOWebSocketChannel.connect('ws://$ipconfig:8080');

//   channel_2 = IOWebSocketChannel.connect('ws://$ipconfig:8081');
//   seenchannel_2 = IOWebSocketChannel.connect('ws://$ipconfig:8082');
//   statusChannel_2 = IOWebSocketChannel.connect('ws://$ipconfig:8083');
//   // backseenchannel = IOWebSocketChannel.connect('ws://$ipconfig:8084');


  

//   setState(() {
//     email = preferences.getString('email') ?? '';
//     activeEmail = widget.dataUrl;
//   });

//    await messageSeen();
//   // Set up the WebSocket stream listener once
//   channel.sink.add(json.encode({
//     'recieverEmail': activeEmail
//   }));
//   channel.stream.listen(
//     (message) {
//       print("Message received via WebSocket: $message");
//       setState(() {
//         outputMessage.add(json.decode(message));
//       });
//     },
//     onError: (error) {
//       print("WebSocket error: $error");
//     },
//     onDone: () {
//       print("WebSocket connection closed");
//     },
//   );


//    statusChannel_2.stream.listen(
//       (message) {
//         print("status Message received via WebSocket: $message");  // Debug print
//         // setState(() {
//         //   outputMessage.add(json.decode(message));
//         // });
//         messageSeen();
//       },
//       onError: (error) {
//         print("WebSocket error: $error");
//       },
//       onDone: () {
//         print("WebSocket connection closed");
//       },
//     );

//     // Send the initial WebSocket message
//     statusChannel_2.sink.add(json.encode({
//       'recieverEmail': activeEmail
//     }));


//   // Initialize the data and user profile
//   await allMessage();
//   await userProfile();
//   await MessageLastId();
//   await recieverMessageLastId();

//   // WebSocket message to be sent
//   seenchannel.sink.add(json.encode({
//     'recieverEmail': email
//   }));

  

//    await seenchannel.stream.listen(
//   (message) {
//     print("Message received via WebSocket: $message");  // Debug print
//     var decodedMessage = json.decode(message);
//    print('seenMessageseenMessage $decodedMessage');
//     if (decodedMessage['action'] == 'message_seen') {
//       // Update the state to mark the message as seen
//       setState(() {
//         userSeenMessage = true;
//         print('seenMessageseenMessage');
//       });
//     } 
//   },
//   onError: (error) {
//     print("WebSocket error: $error");
//   },
//   onDone: () {
//     print("WebSocket connection closed");
//   },
// );
// }

// Future<void> _getImageFromGallery() async {
//   final pickedImage = await picker.pickImage(source: ImageSource.gallery);
//   setState(() {
//     _image = pickedImage != null ? File(pickedImage.path) : null;
//   });
// }

// Future<void> allMessage() async {
//   var myurl = "http://$ipconfig/apisocial/allMessage_2.php";
//   var res = await http.post(Uri.parse(myurl), body: {
//     'email': activeEmail,
//     'activeEmail': email
//   });


    


//   if (res.statusCode == 200) {

//     var jsonRes = json.decode(res.body);
//     setState(() {
//       outputMessage = jsonRes;
//     });
//     print('here is output $outputMessage');
//   }
// }

// // first fetch last message id wrt activeemailand email and then fetch 
//  Future<void> MessageLastId() async {
//     var myurl = "http://$ipconfig/apisocial/MessageLastId.php";
//     var res = await http.post(Uri.parse(myurl), body: {
//       'activeEmail': activeEmail,
//       'email': email,
//       'person': 'user'
//     });

//     if (res.statusCode == 200) {
//       var jsonRes = json.decode(res.body);
//      setState(() {
//          mLastId = jsonRes[0]['id'];
//          lastMessage = jsonRes[0]['myMessage'];
//       });
      
//  print('got $jsonRes');
//  print('mlastId $mLastId');
//  print(email);
//  fetchMessageSeen();
//     }
   
//   }

// // new get last id frm reciever then insert into messageseen
//  Future<void> recieverMessageLastId() async {
//     var myurl = "http://$ipconfig/apisocial/MessageLastId.php";
//     var res = await http.post(Uri.parse(myurl), body: {
//       'activeEmail': activeEmail,
//       'email': email,
//       'person': 'reciever'
//     });

//     if (res.statusCode == 200) {
//       var jsonRes = json.decode(res.body);
//       List<dynamic> out = jsonRes;

//       setState(() {
//        unstoredId.clear();
//         unstoredMessage.clear();

//         out.forEach((message) {
//           print('got for each $message');
//           unstoredId.add(message['id']);
//           unstoredMessage.add(message['myMessage']);
//         });
//       });

//       // print('got $jsonRes');
//       // print('mlastId $unstoredId');
//       // print(email);

//       MessageSeen();
//     }
//   }
    
//     // list of inserted ids and messages not in messageseen in order to get no of unseen message 
//   Future<void> MessageSeen() async {
//      if (unstoredId.isNotEmpty){
//     var myurl = "http://$ipconfig/apisocial/MessageSeen_2.php";
//     var res = await http.post(Uri.parse(myurl), body: {
//       'activeEmail': activeEmail,
//       'email': email,
//       'messageId': unstoredId.join(','),
//       'Lmessage': unstoredMessage.join(',')
//     });

//     if (res.statusCode == 200) {
//       var jsonRes = json.decode(res.body);
//       if (jsonRes['success'] == 'Message sent successfully') {
//         print(unstoredId.toString());
//         print(activeEmail);
//         print('heres the last data $jsonRes');
//       }
//     }
//   }
//   }

  
  
// // then fetch if in messageseen setstate to true
// Future<void> fetchMessageSeen() async {
//     var myurl = "http://$ipconfig/apisocial/fetchMessageSeen.php";
//     var res = await http.post(Uri.parse(myurl), body: {
//       'activeEmail': email,
//       'email': activeEmail,
//       'messageId' : mLastId.toString()
//     });

//     if (res.statusCode == 200) {
//       var jsonRes = json.decode(res.body);
//       if(jsonRes['success'] == 'successful'){
//         print('trying something $jsonRes');
//       setState(() {
//         userSeenMessage = true;
//       });
//       }
//     }
//   }


//   // Future<void> MessageSeen() async {
//   //   var myurl = "http://$ipconfig/apisocial/MessageSeen.php";
//   //   var res = await http.post(Uri.parse(myurl), body: {
//   //     'activeEmail': activeEmail,
//   //     'email': email,
//   //     'messageId' : mLastId.toString(),
//   //     'Lmessage' : lastMessage
//   //   });

//   //   if (res.statusCode == 200) {
//   //     var jsonRes = json.decode(res.body);
//   //     if(jsonRes['success'] == 'Message sent successfully'){

//   //     print(mLastId.toString());
//   //     print(activeEmail);
//   //     print('heres the last data $jsonRes');

//   //     setState(() {
//   //       userSeenMessage = true;
//   //     });
//   //     }
//   //   }
//   // }



// Future<void> messageMe() async {
//   print("messageMe function called");
//   setState(() {
//       userSeenMessage = false;
//     });

//   final uri = Uri.parse("http://$ipconfig/apisocial/message.php");
//   var request = http.MultipartRequest('POST', uri);
//   request.fields['myMessage'] = messageController.text;
//   request.fields['activeEmail'] = activeEmail;
//   request.fields['email'] = email;
//   request.fields['orderedActiveEmail'] = activeEmail;
//   request.fields['orderedEmail'] = email;
//   request.fields['name'] = userName;
//   request.fields['person'] = person;
//   request.fields['profilepic'] = profileImage;

//   print("Request prepared: ${request.fields}");

//   if (_image != null) {
//     var pic = await http.MultipartFile.fromPath("image_01", _image!.path);
//     request.files.add(pic);
//   }

//   var response = await request.send();
//   print("Response status: ${response.statusCode}");

//   if (response.statusCode == 200) {
//     // Send the message via WebSocket
//     channel.sink.add(json.encode({
//       'myMessage': messageController.text,
//       'activeEmail': activeEmail,
//       'email': email,
//       'name': userName,
//       'person': person,
//       'recipientEmail': activeEmail,
//       'profilepic': profileImage,
//       'image_01': _image != null ? _image!.path.split('/').last : ''
//     }));
//     print("Message sent via WebSocket");
   
//    await MessageLastId();

//     setState(() {
//       messageController.clear();
//       _image = null;
//     });


//  // Check if the receiver is connected and set userSeenMessage
// //  if reciever is connected seenchannel will send back here a meassage
//       statusChannel.sink.add(json.encode({
//         'action': 'check_status',
//         'recipientEmail': activeEmail,
//       }));

//        await allMessage();
    
//   } else {
//     print("Failed to send message to server");
//   }
// }

// Future<void> userProfile() async {
//   var url = "http://$ipconfig/apisocial/userData.php";
//   var response = await http.post(Uri.parse(url), body: {'email': email});
//   if (response.statusCode == 200) {
//     var jsonResponse = json.decode(response.body);
//     if (jsonResponse['success'] == 'login successful') {
//       setState(() {
//         userData = jsonResponse['data'][0];
//         userName = userData['name'];
//         profileImage = userData['image_01'];
//       });
//       print('here is image $profileImage');
//     }
//   }
// }


// @override
// void initState() {
//   super.initState();
//   userDetails();
 
// }


//   @override
//   void dispose() {
//   channel.sink.close();
//   seenchannel.sink.close();
//   statusChannel.sink.close();
//   channel_2.sink.close();
//   seenchannel_2.sink.close();
//   statusChannel_2.sink.close();
//   super.dispose();
// }


//   void cancelImage() {
//     setState(() {
//       _image = null;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             Text('AMAKA'),
//             SizedBox(width: 10),
//             if (mainImage != null)
//               Container(
//                 width: 50,
//                 height: 50,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(100),
//                   child: Image.network(
//                     "http://$ipconfig/apisocial/registered_img/$mainImage",
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('images/sperf.JPG'), // Fallback image
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Column(

//           children: [
//             Text('data'),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: outputMessage.length,
//                 itemBuilder: (context, index) {
//                   var message = outputMessage[index];
//                   // index is from the listview(range) being assigned to isLastMessage and if any from the range equal to the last outputmessage then is true(bool) and that is the last value
//                   final isLastMessage = index == outputMessage.length - 1;
//                   return Container(
//                     padding: EdgeInsets.only(left: 10, right: 10),
//                     child: 
//                     message['person'] == 'reciever' ? 

//                     Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
                   
//      Flexible(
//       child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//      children: [
//       Row(
//       mainAxisAlignment: MainAxisAlignment.start,
                            
//       children: [
                                         
//     Flexible(
//     child: Container(
//      padding: EdgeInsets.all(10),
//      decoration: BoxDecoration(
//      color: Colors.white
//            ),
//      child: Text(
//     '${message['myMessage']}',
//      style: TextStyle(
//     fontSize: 20,
//     ),
//       ),
//           ),
//         ),
                                         
//             ],
//     ),
                        
//   SizedBox(height: 10),
//     message['image_01'].isEmpty
//         ? Container()
//            : Container(
//                   color: Colors.black45,
//                   width: 100,
//                   child: Image.network(
//                     "http://$ipconfig/practice/uploaded_img/${message['image_01']}",
//                     // fit: BoxFit.cover,
//                   ),
//                 ),
//                         ],
//                       ),
//                     ),
//                      SizedBox(width: 50), // This keeps the gap from the right side
//                   ],
//                 )
                  
//                    :

//                        Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                     SizedBox(width: 50), // This keeps the gap from the left side
//                     Flexible(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
                                         
//     Flexible(
//     child: Container(
//      padding: EdgeInsets.all(10),
//      decoration: BoxDecoration(
//      color: Colors.green[200]
//            ),
//      child: Text(
//     '${message['myMessage']}rjgnlwkrjgnlbiutwbgiuwg44bwgnliwu4gnliuwtgnliu4bguitblui4bglitug',
//         style: TextStyle(
//         fontSize: 20,
//          ),
//       ),
//       ),
//       ),
                                         
//     SizedBox(width: 5), // Add some space between text and icons
//     userSeenMessage && isLastMessage ?
//     Column(
//     children: [
//     Icon(
//    Icons.check,
//    color: Colors.blue,
//     ),
//      Icon(
//       Icons.check,
//        color: Colors.blue,
//        ),
//        ],
//       )
//      : userSeenMessage == false && isLastMessage ? Icon(
//     Icons.check,
//     color: Colors.black,
//      ) : Container()
//       ],
//         ),
                        
//                           SizedBox(height: 10),
//                           message['image_01'].isEmpty
//                               ? Container()
//                               : Container(
//                   color: Colors.black45,
//                   width: 100,
//                   child: Image.network(
//                     "http://$ipconfig/practice/uploaded_img/${message['image_01']}",
//                     // fit: BoxFit.cover,
//                   ),
//                 ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
                  
//                   //  Expanded( 
                    
//                   //   child: Row(
//                   //     mainAxisAlignment: MainAxisAlignment.end,
//                   //     children: [
//                   //       Column(
                          
//                   //         // crossAxisAlignment: CrossAxisAlignment.end,
//                   //         children: [
//                   //           Container(
//                   //             padding: EdgeInsets.all(10),
//                   //             decoration: BoxDecoration(
//                   //               borderRadius: BorderRadius.circular(20),
//                   //               color: Colors.green[200],
//                   //             ),
//                   //             child: Column(
//                   //               crossAxisAlignment: CrossAxisAlignment.start,
//                   //               children: [
//                   //                 Text(message['myMessage'], style: TextStyle(fontSize: 20,),),
//                   //                 Text(message['email']),
//                   //                 // Text(comment['id'].toString(),),
//                   //               ],
//                   //             ),
//                   //           ),
//                   //           SizedBox(height: 10),
                        
//                   //           message['image_01'].isEmpty ? Container():
//                   //           Container(
//                   //             color: Colors.black45,
//                   //             width: 100,
//                   //             child: Image.network(
//                   //               "http://$ipconfig/practice/uploaded_img/${message['image_01']}",
//                   //               // fit: BoxFit.cover, 
//                   //             ),
//                   //           ),
//                   //         ],
//                   //       ),
//                   //       userSeenMessage && isLastMessage ? Column(
//                   //         children: [
//                   //           Icon(Icons.check, color: Colors.blue,),
//                   //            Icon(Icons.check, color: Colors.blue,),
//                   //         ],
//                   //       ) : userSeenMessage == false && isLastMessage ? Icon(Icons.check, color: Colors.black,)
//                   //       : Container()
                        
//                   //     ],
//                   //   ),
//                   //                    ),
//                 );
//               },
//             ),
//           ),

//             buildInputArea(),
//           ],
//         ),
//       ),
//     );
//   }

//   // Widget buildMessageBubble(Map<String, dynamic> message, bool isUser) {
//   //   return Column(
//   //     crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//   //     children: [
//   //       Row(
//   //         children: [
//   //           Container(
//   //             padding: EdgeInsets.all(10),
//   //             decoration: BoxDecoration(
//   //               borderRadius: BorderRadius.circular(20),
//   //               color: isUser ? Colors.green[200] : Colors.white,
//   //             ),
//   //             child: Column(
//   //               crossAxisAlignment: CrossAxisAlignment.start,
//   //               children: [
//   //                 Text(
//   //                   message['myMessage'],
//   //                   style: TextStyle(fontSize: 20),
//   //                 ),
//   //                 Text(message['email']),
//   //               ],
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //       SizedBox(height: 10),
//   //       // if (message['image_01'].isNotEmpty)
//   //       //   Container(
//   //       //     color: Colors.black45,
//   //       //     width: 100,
//   //       //     child: Image.network(
//   //       //       "http://$ipconfig/practice/uploaded_img/${message['image_01']}",
//   //       //     ),
//   //       //   ),
//   //     ],
//   //   );
    
//   // }

//   Widget buildInputArea() {
//     return Container(
//       color: Colors.white,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (_image != null)
//             Row(
//               children: [
//                 Container(
//                   padding: EdgeInsets.only(left: 20),
//                   width: 80,
//                   height: 80,
//                   child: Image.file(
//                     _image!,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: cancelImage,
//                   icon: Icon(Icons.cancel_outlined),
//                 ),
//               ],
//             ),
//           BottomAppBar(
//             color: Colors.white,
//             child: Row(
//               children: <Widget>[
//                 IconButton(
//                   onPressed: _getImageFromGallery,
//                   icon: Icon(Icons.photo_library_rounded),
//                 ),
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.black, width: 1),
//                       borderRadius: BorderRadius.circular(50),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                       child: TextField(
//                         controller: messageController,
//                         decoration: InputDecoration(
//                           hintText: 'Type your message...',
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 8.0),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: (){messageMe();},
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
