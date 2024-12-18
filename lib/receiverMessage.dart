import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:mini/ipconfig.dart';

class MobileMessage extends StatefulWidget {
   final String dataUrl;
  const MobileMessage({super.key, required this.dataUrl});

  

  @override
  State<MobileMessage> createState() => _MobileMessageState();
}

class _MobileMessageState extends State<MobileMessage> {
  bool recieverSeenMessage = false;
  bool userSeenMessage = false;
  List<dynamic> outputMessage = [];
  String person = 'reciever';
  String email = '';
  String activeEmail = '';
  List<String> lastMessage = []; 
  List<String> mLastId = [];
  var dLastId;
  var dLastmessage;
  var userData;
  String storeName = '';
  var mainImage;
  File? _image;
  final picker = ImagePicker();
  late WebSocketChannel channel;
  late WebSocketChannel seenchannel;
  late WebSocketChannel backseenchannel;
  late WebSocketChannel backReadchannel;
  late WebSocketChannel statusChannel;
  late WebSocketChannel unreadChannel;
  late WebSocketChannel deleteNoUnreadchannel;
  // late WebSocketChannel channel_2;
  // late WebSocketChannel seenchannel_2;
  // late WebSocketChannel statusChannel_2;

  TextEditingController messageController = TextEditingController();



 
  Future<void> messageSeen() async {
  seenchannel.sink.add(json.encode({
    'action': 'message_seen',
    'recipientEmail': activeEmail
  }));
}
 Future<void> memessageSeen() async {
  backseenchannel.sink.add(json.encode({
    'action': 'message_seen',
    'recipientEmail': email,
    'Email': activeEmail
  }));
}

Future<void> unRead() async {
  unreadChannel.sink.add(json.encode({
    'action': 'message_seen',
    'recipientEmail': activeEmail,
    'Email': email
  }));
}

Future<void> backRead() async {
  backReadchannel.sink.add(json.encode({
    'action': 'message_seen',
    'recipientEmail': activeEmail,
    'Email': email
  }));
}

Future<void> deleteNoUnread() async {
  deleteNoUnreadchannel.sink.add(json.encode({
    'action': 'message_seen',
    'recipientEmail': email,
    'Email': activeEmail
  }));
}

//  Future<void> backMessageSeen() async {
//   backseenchannel.sink.add(json.encode({
//     'action': 'message_seen',
//     'person': 'reciever',
//     'recipientEmail': email,
//     'activeEmail' : activeEmail
//   }));
// }





  Future<void> initializeWebSocket() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
    email = preferences.getString('email') ?? '';
    activeEmail = widget.dataUrl;
    });

  
    // websocket for message to apear at chatlist
  channel = IOWebSocketChannel.connect('ws://$ipconfig:8081');
          
  channel.sink.add(json.encode({
    'recieverEmail': activeEmail
  }));
  channel.stream.listen(
    (message) {
      print("Message received via WebSocket: $message");
      setState(() {
        outputMessage.add(json.decode(message));
      });
    },
    onError: (error) {
      print("WebSocket error: $error");
    },
    onDone: () {
      print("WebSocket connection closed");
    },
  );
    
     
     userDetails();
     
     await allMessage();
     directMessageLastId();
     await MessageLastId();

    // when user or reciever comes into same page
    seenchannel = IOWebSocketChannel.connect('ws://$ipconfig:8082');
    //to update chat list screen if seen
    backseenchannel = IOWebSocketChannel.connect('ws://$ipconfig:8083');
    //both on page websocket 
    statusChannel = IOWebSocketChannel.connect('ws://$ipconfig:8080');
    // get noUnread for chat list screen after sender sends a message here while reciever is in chat list
    unreadChannel = IOWebSocketChannel.connect('ws://$ipconfig:8084');
    // update chatlist page when seen here by same person
    backReadchannel = IOWebSocketChannel.connect('ws://$ipconfig:8085');

    deleteNoUnreadchannel = IOWebSocketChannel.connect('ws://$ipconfig:8086');

    // channel_2 = IOWebSocketChannel.connect('ws://$ipconfig:8081');
    // seenchannel_2 = IOWebSocketChannel.connect('ws://$ipconfig:8082');
    // statusChannel_2 = IOWebSocketChannel.connect('ws://$ipconfig:8083');
      //  memessageSeen();
    await messageSeen();
    
    // backMessageSeen();
    // channel.stream.listen(
    //   (message) {
    //     print("Message received via WebSocket: $message");  // Debug print
    //     setState(() {
    //       outputMessage.add(json.decode(message));
    //     });
    //   },
    //   onError: (error) {
    //     print("WebSocket error: $error");
    //   },
    //   onDone: () {
    //     print("WebSocket connection closed");
    //   },
    // );

    // // Send the initial WebSocket message
    // channel.sink.add(json.encode({
    //   'recieverEmail': activeEmail
    // }));


//       statusChannel.stream.listen(
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
//     statusChannel.sink.add(json.encode({
//       'recieverEmail': email
//     }));



//  backseenchannel.sink.add(json.encode({
//     'recieverEmail': activeEmail
//   }));

//    await backseenchannel.stream.listen(
//   (message) {
//     print("ooooooooooooo: $message");  // Debug print
//     var decodedMessage = json.decode(message);
//    print('ooooooooooooooo $decodedMessage');
    
//       // Update the state to mark the message as seen
//       setState(() {
//         recieverSeenMessage = true;
//         // backMessageSeen();
//         print('ooooooooooooooooooo');
//       });
// // check if recieverSeenMessage = true then send back for back functionality to show seen state
//       // if(recieverSeenMessage = true){
//       //   backMessageSeen();
//       // }

//   },
//   onError: (error) {
//     print("WebSocket error: $error");
//   },
//   onDone: () {
//     print("WebSocket connection closed");
//   },
// );

   



  seenchannel.sink.add(json.encode({
    'recieverEmail': email
  }));

   await seenchannel.stream.listen(
  (message) {
    print("Message received via WebSocket: $message");  // Debug print
    var decodedMessage = json.decode(message);
   print('seenMessageseenMessage $decodedMessage');
    if (decodedMessage['action'] == 'message_seen') {
      // Update the state to mark the message as seen
      setState(() {
        recieverSeenMessage = true;
        memessageSeen();
        deleteNoUnread();
        // backMessageSeen();
        print('seenMessageseenMessage');
      });
// check if recieverSeenMessage = true then send back for back functionality to show seen state
      // if(recieverSeenMessage = true){
      //   backMessageSeen();
      // }


    } 
  },
  onError: (error) {
    print("WebSocket error: $error");
  },
  onDone: () {
    print("WebSocket connection closed");
  },
);


  statusChannel.sink.add(json.encode({
    'recieverEmail': activeEmail
  }));


 await statusChannel.stream.listen(
  (message) async{
    print("Message received via WebSocket: $message");  // Debug print
    var decodedMessage = json.decode(message);
   print('pppppppMessageseenMessage $decodedMessage');
    if (decodedMessage['action'] == 'message_sent') {
      // Update the state to mark the message as seen
      setState(() {
        print('ppppppppMessageseenMessage');
        recieverSeenMessage = true;
        memessageSeen();
        deleteNoUnread();
        // backMessageSeen();
        print('ppppppppMessageseenMessage');
      });

      // if both on page and message is sent insert into messageseen box
     var myurl = "http://$ipconfig/apisocial/MessageLastId_2.php";
  var res = await http.post(Uri.parse(myurl), body: {
    'email': email,
    'activeEmail': activeEmail,
  });


  if (res.statusCode == 200) {
    
    var jsonRes = json.decode(res.body);
    

    setState(() {
       dLastId = jsonRes[0]['id'];
       dLastmessage = jsonRes[0]['myMessage'];
    });

    print('now getting the $dLastmessage');
    print('now getting the $dLastId');

    onPageInsertMessage();
  }

    }

  },
  onError: (error) {
    print("WebSocket error: $error");
  },
  onDone: () {
    print("WebSocket connection closed");
  },
);
  

    await unRead();

    if (recieverSeenMessage != true)
{
  await backRead();
  print('back connection');
}
   deleteNoUnread(); 
  
  }

  Future<void> userDetails() async {
  
    var url = "http://$ipconfig/apisocial/store_data.php";
    var response = await http.post(Uri.parse(url), body: {
      'email': activeEmail,
    });

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['message'] == 'login successful') {
        setState(() {
          var userData = jsonResponse['data'][0];
          storeName = userData['storeName'];
          mainImage = userData['image_01'];
        });

      }
    }


  }

  // // first fetch last message id wrt activeemailand email and then fetch
  //fetch last text id then check if seen 
 Future<void> directMessageLastId() async {
    var myurl = "http://$ipconfig/apisocial/MessageLastId_2.php";
    var res = await http.post(Uri.parse(myurl), body: {
      'activeEmail': activeEmail,
      'email': email,
    });

    if (res.statusCode == 200) {
      var jsonRes = json.decode(res.body);
     setState(() {
         dLastId = jsonRes[0]['id'];
        //  lastMessage = jsonRes[0]['myMessage'];
      });
      
 print('got $jsonRes');
 print('mlastId $dLastId');
 fetchMessageSeen();
    }
   
  }

  // Future<void> userMessageLastId() async {
  //   var myurl = "http://$ipconfig/apisocial/MessageLastId.php";
  //   var res = await http.post(Uri.parse(myurl), body: {
  //     'activeEmail': email,
  //     'email': activeEmail,
  //     'person': 'user'
  //   });

  //   print(email);
  //   print(activeEmail);

  //   if (res.statusCode == 200) {
  //     var jsonRes = json.decode(res.body);
  //     setState(() {
  //       //  mLastId = jsonRes[0]['id'];
  //       //  lastMessage = jsonRes[0]['myMessage'];
  //     });
  //     print('here the last data $mLastId');
        // MessageSeen();
  //   }
  // }

Future<void> onPageInsertMessage() async {
  print('messageId is $dLastId');
    var myurl = "http://$ipconfig/apisocial/MessageSeen.php";
    var res = await http.post(Uri.parse(myurl), body: {
      'activeEmail': activeEmail,
      'email': email,
      'messageId' : dLastId.toString(),
      'Lmessage' : dLastmessage
    });

    if (res.statusCode == 200) {
      var jsonRes = json.decode(res.body);
      if(jsonRes['success'] == 'Message sent successfully'){
      print('is done ');
      }
    }
  }

 Future<void> MessageSeen() async {
  var myurl = "http://$ipconfig/apisocial/MessageSeen_2.php";
  
  // Convert lists to comma-separated strings
  String messageIds = mLastId.join(',');
  String lastMessages = lastMessage.join(',');

  var res = await http.post(Uri.parse(myurl), body: {
    'activeEmail': activeEmail,
    'email': email,
    'messageId': messageIds,
    'Lmessage': lastMessages,
  });

  if (res.statusCode == 200) {
    var responseBody = res.body;
    print('Response body: $responseBody'); // Print the entire response body

    var jsonRes = json.decode(responseBody);
    if (jsonRes is List) {
      for (var item in jsonRes) {
        print('Item: $item'); // Print each item in the response
        if (item['success'] == 'Message sent successfully') {
          print('heres the last data ${item['messageId']}');
        } else if (item['success'] == 'Message already exists') {
          print('Message already exists for ${item['messageId']}');
        } else {
          print('Unexpected success value: ${item['success']}'); // Log unexpected success values
        }
      }
    } else {
      print('Response is not a list: $jsonRes'); // Log if the response is not a list
    }
  } else {
    print('HTTP request failed with status code: ${res.statusCode}');
  }
}



// first fetch last message id wrt activeemailand email and then fetch 
Future<void> MessageLastId() async {
  // print('now getting the $mLastId');
 
  
  var myurl = "http://$ipconfig/apisocial/MessageLastId.php";
  var res = await http.post(Uri.parse(myurl), body: {
    'email': email,
    'activeEmail': activeEmail,
  });


  if (res.statusCode == 200) {
  //   print('now getting the active $activeEmail');
  // print('now getting the email $email');
    var jsonRes = json.decode(res.body);

    // Initialize empty lists for mLastId and lastMessage
    List<String> mLastIdList = [];
    List<String> lastMessageList = [];

    // Iterate through the JSON response and extract id and myMessage values
    for (var item in jsonRes) {
      mLastIdList.add(item['id'].toString());
      lastMessageList.add(item['myMessage']);
    }

    // Update the state with the new lists
    setState(() {
      //By collecting all the data first in mLastIdList etc and then updating the state once in mLastId etc, you ensure that the state is updated efficiently.
      mLastId = mLastIdList;
      lastMessage = lastMessageList;
    });

    print('now getting the $lastMessage');
    print('now getting the $mLastId');

    MessageSeen();
    fetchMessageSeen();
  }
}



 //new then fetch if in messageseen setstate to true
Future<void> fetchMessageSeen() async {
  print('messageId is $dLastId');
    var myurl = "http://$ipconfig/apisocial/fetchMessageSeen.php";
    var res = await http.post(Uri.parse(myurl), body: {
      'activeEmail': activeEmail,
      'email': email,
      'messageId' : dLastId.toString()
    });

    if (res.statusCode == 200) {
      var jsonRes = json.decode(res.body);
      if(jsonRes['success'] == 'successful'){
      setState(() {
        recieverSeenMessage = true;
        memessageSeen();
        
      });
      }
    }
  }
  
  Future<void> _getImageFromGallery() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage != null ? File(pickedImage.path) : null;
    });
  }

  Future<void> messageMe() async {
    
     setState(() {
      recieverSeenMessage = false;
    });

    final uri = Uri.parse("http://$ipconfig/apisocial/reciever_message.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['myMessage'] = messageController.text;
    request.fields['activeEmail'] = activeEmail;
    request.fields['email'] = email;
    request.fields['orderedActiveEmail'] = activeEmail;
    request.fields['orderedEmail'] = email;
    request.fields['person'] = person;

    if (_image != null) {
      var pic = await http.MultipartFile.fromPath("image_01", _image!.path);
      request.files.add(pic);
    }

    var response = await request.send();


    // Send the message via WebSocket
    channel.sink.add(json.encode({
      'myMessage': messageController.text,
      'activeEmail': email,
      'email': activeEmail,
      'person': person,
      'recipientEmail': activeEmail,
      'image_01': _image != null ? _image!.path.split('/').last : ''
    }));
   
    
   
  
statusChannel.sink.add(json.encode({
    'action': 'message_seen',
    'recipientEmail': email
  }));
  
 
  await backRead();

    if (response.statusCode == 200) {
      
    setState(() {
        messageController.clear();
        _image = null;
        
      });
    
    await allMessage();
    await deleteNoUnread();
    await unRead();
    }
  }

  Future<void> allMessage() async {
    print('object');
    var myurl = "http://$ipconfig/apisocial/allMessage_2.php";
    var res = await http.post(Uri.parse(myurl), body: {
      'activeEmail': email,
      'email': activeEmail
    });

     print('object $activeEmail');

    if (res.statusCode == 200) {
      var jsonRes = json.decode(res.body);
      setState(() {
        outputMessage = jsonRes;
      });
      // print('for the new $outputMessage');
    }
  }

  void deleteMessage(Map<String, dynamic> comment) async {
    var url = "http://$ipconfig/practice/comment_like_box.php";
    var response = await http.post(Uri.parse(url), body: {
      'commentId': comment['id'].toString(),
      'email': email
    });

    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success'] == 'like successful') {
      print('success');
    }
  }

  void cancelImage() {
    setState(() {
      _image = null;
    });
  }

   @override
  void initState() {
    super.initState();
    initializeWebSocket();
  }


  @override
void dispose() {
  channel.sink.close();
  seenchannel.sink.close();
  statusChannel.sink.close();
  unreadChannel.sink.close();
  backseenchannel.sink.close();
  deleteNoUnreadchannel.sink.close();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[200],
     appBar: AppBar(
      title: Row(
        children: [
          // Text(storeName),
          Text('AMAKA'),

          SizedBox(width: 10,),
          Container(
           width: 50,
           height: 50,
        // child: ClipRRect(
        //   borderRadius: BorderRadius.circular(100),
        //   child: Image.network(
        //                           "http://$ipconfig/apisocial/registered_img/$mainImage",
        //                           fit: BoxFit.cover, // Ensure the image covers the entire space
        //                         ),
        // ),
      ),
        ],
      ),
     ),

      body: Container(
        // decoration: BoxDecoration(
        //    image: DecorationImage(
        //       image: NetworkImage("http://$ipconfig/apisocial/registered_img/$mainImage"), // Replace 'background_image.jpg' with your image asset path
        //       fit: BoxFit.cover, // You can adjust the fit as needed
        //     ),
        // ),
        child: Column(
          children: [
        SizedBox(height: 20,),
            Expanded(
            child: ListView.builder(
              
              itemCount: outputMessage.length,
              itemBuilder: (context, index) {
                var message = outputMessage[index];
                return Container(
                 
                  child: 
                  
                   message['activeEmail'] == email ? 

                    Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                   
     Flexible(
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Row(
      mainAxisAlignment: MainAxisAlignment.start,
                            
      children: [
                                         
    Flexible(
    child: Container(
     padding: EdgeInsets.all(10),
     decoration: BoxDecoration(
     color: Colors.white
           ),
     child: Text(
    '${message['myMessage']}',
     style: TextStyle(
    fontSize: 20,
    ),
      ),
          ),
        ),
                                         
            ],
    ),
                        
  SizedBox(height: 10),
    message['image_01'].isEmpty
        ? Container()
           : Container(
                  color: Colors.black45,
                  width: 100,
                  child: Image.network(
                    "http://$ipconfig/practice/uploaded_img/${message['image_01']}",
                    // fit: BoxFit.cover,
                  ),
                ),
                        ],
                      ),
                    ),
                     SizedBox(width: 50), // This keeps the gap from the right side
                  ],
                )


                  
                   :
                  
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    SizedBox(width: 50), // This keeps the gap from the left side
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                                         
    Flexible(
    child: Container(
     padding: EdgeInsets.all(10),
     decoration: BoxDecoration(
     color: Colors.green[200]
           ),
     child: Text(
    '${message['myMessage']}rjgnlwkrjgnlbiutwbgiuwg44bwgnliwu4gnliuwtgnliu4bguitblui4bglitug',
        style: TextStyle(
        fontSize: 20,
         ),
      ),
      ),
      ),
                                         
    SizedBox(width: 5), // Add some space between text and icons
    recieverSeenMessage
    ? Column(
    children: [
    Icon(
   Icons.check,
   color: Colors.blue,
    ),
     Icon(
      Icons.check,
       color: Colors.blue,
       ),
       ],
      )
     : Icon(
    Icons.check,
    color: Colors.black,
     ),
      ],
        ),
                        
                          SizedBox(height: 10),
                          message['image_01'].isEmpty
                              ? Container()
                              : Container(
                  color: Colors.black45,
                  width: 100,
                  child: Image.network(
                    "http://$ipconfig/practice/uploaded_img/${message['image_01']}",
                    // fit: BoxFit.cover,
                  ),
                ),
                        ],
                      ),
                    ),
                  ],
                ),


                );
              },
            ),
          ),
        
           Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _image != null ? Row(
                  children: [
                    Container(
                       padding: EdgeInsets.only(left: 20),
                      width: 80,
                      height: 80,
                      child: Image.file(
                        _image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    IconButton(onPressed: (){cancelImage();}, icon: Icon(Icons.cancel_outlined))
                  ],
                ) : Container(),
        
            BottomAppBar(
             color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: (){ _getImageFromGallery(); },
                        icon: Icon(Icons.photo_library_rounded),
                      ),
                      Expanded(
                        child: Container(
                  decoration: BoxDecoration(
                  
                   border: Border.all(
                    color: Colors.black,
                    width: 1
                   ),
                                   borderRadius: BorderRadius.circular(50)
                  ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              controller: messageController,
                              decoration: InputDecoration(
                                hintText: 'Type your message...',
                                // border: OutlineInputBorder(),
                               border: InputBorder.none
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () { messageMe(); },
                      ),
                    ],
                  ),
                ),
           ],
            ),
          ),
        
          ],
        ),
      ),
    );
  }
}