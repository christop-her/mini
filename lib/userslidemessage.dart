import 'package:flutter/material.dart';
import 'package:mini/ipconfig.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// import '../screens/call_page.dart';

class ChatAppslide extends StatefulWidget {
  final String dataUrl; // Doctor's email
  const ChatAppslide({super.key, required this.dataUrl});

  @override
  State<ChatAppslide> createState() => _ChatAppslideState();
}

class _ChatAppslideState extends State<ChatAppslide> {
  String email = '';
  String storename = '';
  var userData;
  var DoctorEmail;
  List<String> lastMessage = []; 
  List<String> mLastId = [];
  List<dynamic> outputMessage = [];
  late IO.Socket socket;

  TextEditingController messageController = TextEditingController();

 

  Future<void> doctorDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString('email') ?? '';
    });
    setState(() {
      DoctorEmail = widget.dataUrl;
    });
print('userdata ${widget.dataUrl}');
    // _showLoadingDialog(context);
    var url = "http://$ipconfig/apisocial/store_data.php";
    var response = await http.post(Uri.parse(url), body: {
      'email': widget.dataUrl, // Sending doctor's email to get their data
    });
    // Navigator.pop(context);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['message'] == 'login successful') {
        setState(() {
          userData = jsonResponse['data'][0];
          storename = userData['storeName'];
        });
        print('userdata $userData');
       
        
        allMessage();
        messageLastId();
      }else{
        print(jsonResponse);
      }
    }
    initSocket();
  }

  void initSocket() {
  
    socket = IO.io('http://$ipconfig:3000', IO.OptionBuilder()
        .setTransports(['websocket']) 
        .disableAutoConnect() 
        .build());
    socket.connect();

    socket.onConnect((_) {
      print('Connected to Socket.io server');

      socket.emit('register', email); 
      socket.emit('reload_register', email);
    });

    socket.emit('reload message', json.encode( 
       {
      'mymessage': 'reload message',
      'doctoremail': widget.dataUrl, 
      'email': email, 
    }));

    socket.on('reload message', (data) {
      print('reload message: $data');
      setState(() {
        outputMessage.add(json.decode(data));
      });
      print('reload from node $data');
    });

    socket.on('chat message', (data) {
      print('Receivedd message: $data');
     
     setState(() {
        outputMessage.add(json.decode(data));
      });
    
      print('output from node $outputMessage');
    });

    socket.onDisconnect((_) {
      print('Disconnected from Socket.io server');
    });
  }




//       Future<void> messageSeen() async {
//   print('Response body:');
//   var myurl = "https://healthtok.onrender.com/MessageSeen_2.php";
  
//   // Convert lists to comma-separated strings
//   String messageIds = mLastId.join(',');
//   String lastMessages = lastMessage.join(',');

//   var res = await http.post(Uri.parse(myurl), body: {
//     'DoctorEmail': DoctorEmail,
//     'email': email,
//     'messageId': messageIds,
//     'Lmessage': lastMessages,
//   });

//   if (res.statusCode == 200) {
//     var responseBody = res.body;
//     print('Response body: $responseBody');

//     var jsonRes = json.decode(responseBody);
//     if (jsonRes is List) {
//       for (var item in jsonRes) {
//         print('Item: $item');
//         if (item['success'] == 'Message sent successfully') {
//           print('heres the last data ${item['messageId']}');
//         } else if (item['success'] == 'Message already exists') {
//           print('Message already exists for ${item['messageId']}');
//         } else {
//           print('Unexpected success value: ${item['success']}');
//         }
//       }
//     } else {
//       print('Response is not a list: $jsonRes');
//     }
//   } else {
//     print('HTTP request failed with status code: ${res.statusCode}');
//   }
// }

  // first fetch last message id wrt activeemailand email and then fetch 
// Future<void> messageLastId() async {
 
  
//   var myurl = "https://healthtok.onrender.com/MessageLastId.php";
//   var res = await http.post(Uri.parse(myurl), body: {
//     'email': email,
//     'DoctorEmail': DoctorEmail,
//   });


//   if (res.statusCode == 200) {
//     var jsonRes = json.decode(res.body);

//     List<String> mLastIdList = [];
//     List<String> lastMessageList = [];
// print('now getting the $jsonRes');
//     // Iterate through the JSON response and extract id and myMessage values
//     for (var item in jsonRes) {
//       mLastIdList.add(item['id'].toString());
//       lastMessageList.add(item['mymessage']);
//     }
//     setState(() {
//       //By collecting all the data first in mLastIdList etc and then updating the state once in mLastId etc, you ensure that the state is updated efficiently.
//       mLastId = mLastIdList;
//       lastMessage = lastMessageList;
//     });

//     print('now getting the $lastMessage');

//     messageSeen();
//   }
// }


Future<void> messageLastId() async {
 
  
  var myurl = "http://$ipconfig/apisocial/MessageLast.php";
  var res = await http.post(Uri.parse(myurl), body: {
    'email': DoctorEmail,
    'doctoremail': email,
  });

  if (res.statusCode == 200) {
    
    var jsonRes = json.decode(res.body);
print('object $jsonRes');
    // List<String> mLastIdList = [];
    // List<String> lastMessageList = [];
    // // Iterate through the JSON response and extract id and myMessage values
    // for (var item in jsonRes['data']) {
    //   mLastIdList.add(item['id'].toString());
    //   lastMessageList.add(item['mymessage']);
    // }
    // setState(() {
    //   //By collecting all the data first in mLastIdList etc and then updating the state once in mLastId etc, you ensure that the state is updated efficiently.
    //   mLastId = mLastIdList;
    //   lastMessage = lastMessageList;
    // });

    // print('now getting the $lastMessage');

    // messageSeen();
  }
}



  Future<void> sendMessage() async {
    if (messageController.text.isEmpty) return;

    var messageData = {
      'mymessage': messageController.text,
      'doctoremail': widget.dataUrl,
      'email': email, 
    };

    socket.emit('chat message', json.encode(messageData));
    messageController.clear();
     
    // setState(() {
    //   outputMessage.add(messageData);
    // });

    print('output from node $outputMessage');
    allMsg();
  }

   Future<void> allMsg() async {
    var myurl = "http://$ipconfig/apisocial/allusersmessage.php";
    var res = await http.post(Uri.parse(myurl), body: {
      'doctoremail': widget.dataUrl,
      'email': email,
    });
    if (res.statusCode == 200) {
      var jsonRes = json.decode(res.body);
      setState(() {
        outputMessage = jsonRes;
      });
      
    }
    // await messageLastId();
  }

  Future<void> allMessage() async {
    _showLoadingDialog(context);
    var myurl = "http://$ipconfig/apisocial/allusersmessage.php";
    var res = await http.post(Uri.parse(myurl), body: {
      'doctoremail': widget.dataUrl,
      'email': email,
    });
    Navigator.pop(context);
    if (res.statusCode == 200) {
      var jsonRes = json.decode(res.body);
      setState(() {
        outputMessage = jsonRes;
      });
      print('All messages: $outputMessage');
    }
    // await messageLastId();
  }

  _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Set background color to white
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Optional: to make it a square
          ),
          content: Container(
            height: 44.0, // Adjust the height
            width: 44.0, // Adjust the width to make it a square
            child: Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(Color(0xFF010043)),
              ),
            ),
          ),
        );
      },
    );
  }


   @override
  void initState() {
    super.initState();
    doctorDetails();
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(storename, style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF010043),
        actions: [
          IconButton(
            icon: Icon(Icons.video_call),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => CallPage(callID: 'test',)),
              // );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (String result) {
              // Handle selection logic
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'patient_record',
                child: Text('Patient Record'),
              ),
              const PopupMenuItem<String>(
                value: 'more',
                child: Text('More'),
              ),
              const PopupMenuItem<String>(
                value: 'my_file',
                child: Text('My File'),
              ),
              const PopupMenuItem<String>(
                value: 'my_data',
                child: Text('My Data'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: outputMessage.isEmpty
                ? Center(child: Text('No messages'))
                : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: outputMessage.length,
                    padding: EdgeInsets.all(8.0),
                    itemBuilder: (context, index) {
                      
                      final messages = outputMessage[index];
                      return ChatBubble(
                        text: messages['mymessage'],
                        isSender: messages['email'] == email ? true : false,
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: sendMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF010043),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 20.0),
                    child: Text(
                      "Send",
                      style: TextStyle(color: Colors.white),
                    ),
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

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSender;

  const ChatBubble({required this.text, required this.isSender});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.all(15),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 2 / 3,
        ),
        decoration: BoxDecoration(
          color: isSender ? Color(0xFF010043) : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isSender ? 20 : 0),
            topRight: Radius.circular(isSender ? 0 : 20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSender ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class VideoCallScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Center(
            child: Text(
              'Video Call Screen',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                ),
                child: Icon(Icons.call_end, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
