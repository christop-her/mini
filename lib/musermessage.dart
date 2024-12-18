import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mini/usermessage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import 'package:socket_io_client/socket_io_client.dart' as IO;



class umessage_tab_all extends StatefulWidget {
  const umessage_tab_all({super.key});

  @override
  _TabBarExampleState createState() => _TabBarExampleState();
}

class _TabBarExampleState extends State<umessage_tab_all>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String ipconfig = '192.168.193.26';
  List<dynamic> outputMessage = [];
  String email = '';
  List<dynamic> messagesId = [];
  List<String> doctorEmails = [];
  bool isLoading = true;
  late WebSocketChannel channel;
  late WebSocketChannel reloadChatListchannel;
    late IO.Socket socket;

  Map<String, int> unreadCounts = {};
  Future<void> _noUnread(doctor_emails) async {
    print('I\'ve got the doctors $doctor_emails');
     print('I\'ve got the doctors $email');
    var myurl = "http://$ipconfig/apisocial/noPatientUnread2.php";
    var res = await http.post(Uri.parse(myurl), body: {
      'email': email,
      'doctoremail': json.encode(doctor_emails),
      });

    if (res.statusCode == 200) {
      var jsonRes = json.decode(res.body);
      print('I\'ve got the $jsonRes');

      // Group messages by both email and DoctorEmail, and count unread messages for each email
      Map<String, int> unreadCountByEmail = {};
      for (var message in jsonRes['data']) {
        // Count unread messages for both sender and receiver emails
        var emailKey = message['email'];

        if (unreadCountByEmail.containsKey(emailKey)) {
          unreadCountByEmail[emailKey] = unreadCountByEmail[emailKey]! + 1;
        } else {
          unreadCountByEmail[emailKey] = 1;
        }
      }

      // Update the state with unread counts
      setState(() {
        unreadCounts = unreadCountByEmail;
      });
      print('Unread counts: $unreadCounts'); // For debugging
    }
  }

  Future<void> _userMessages() async {
    // _tabController = TabController(length: 3, vsync: this);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    email = preferences.getString('email') ?? '';
    initSocket();

    setState(() {
      isLoading = true;
    });
    var url = "http://$ipconfig/apisocial/recieved_messages.php";

    var response = await http.post(Uri.parse(url), body: {
      'doctoremail': email,
    });

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print('i want the resp $jsonResponse');
      Map<String, dynamic> lastMessages = {};
      Set<String> processedEmails = {};

      for (var message in jsonResponse) {
        String messageEmail = message['email'] == email
            ? message['doctoremail']
            : message['email'];
        message['recieverSeenMessage'] = false;

        // Create a unique key for the email pair
        List<String> emailPair = [message['email'], message['doctoremail']];
        emailPair
            .sort(); // Sort to ensure the key is the same regardless of order
        String emailPairKey = emailPair.join("_");

        // Only keep the latest message for each unique email pair
        if (!lastMessages.containsKey(emailPairKey) ||
            message['timestamp']
                    .compareTo(lastMessages[emailPairKey]['timestamp']) >
                0) {
          lastMessages[emailPairKey] = message;
        }

        if (!processedEmails.contains(messageEmail)) {
          processedEmails.add(messageEmail);
          setState(() {
            doctorEmails = processedEmails.toList();
          });
        }
        // print("out of $doctorEmails");
      }

      var myurl = "http://$ipconfig/apisocial/chatList.php";
      var myresponse = await http.post(Uri.parse(myurl), body: {
        'doctoremail': email,
        'email': json.encode(processedEmails.toList()),
      });

      if (myresponse.statusCode == 200) {
        var theResponse = json.decode(myresponse.body);
        Map<String, String> lastUserProfilePics = {};
        Map<String, String> lastUserName = {};
        Map<String, dynamic> lastMessagesId = {};

        // print("all of $theResponse");

        // Prepare futures for fetching profile pictures and usernames concurrently
      List<Future<void>> fetchUserDataFutures = [];

        for (var message in theResponse) {
          String messageEmail = message['email'] == email
              ? message['doctoremail']
              : message['email'];
          var picUrl = "http://$ipconfig/apisocial/store_data.php";

           // Add the future to the list
        fetchUserDataFutures.add(
          http.post(Uri.parse(picUrl), body: {
            'email': messageEmail,
          }).then((picResponse) {
            if (picResponse.statusCode == 200) {
              var outResponse = json.decode(picResponse.body);
              List<dynamic> dataList = outResponse['data'];

              for (var data in dataList) {
                lastUserProfilePics[messageEmail] = data['image_01'] ?? 'text';
                lastUserName[messageEmail] = data['username'];
              }
            }
          })
        );
      }

      // Wait for all user data fetch operations to complete
      await Future.wait(fetchUserDataFutures);

        List<dynamic> lastMessagesList = lastMessages.values.toList();
        lastMessagesList
            .sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

        setState(() {
          outputMessage = lastMessagesList.map((message) {
            String messageEmail = message['email'] == email
                ? message['doctoremail']
                : message['email'];
            message['profilepic'] = lastUserProfilePics[messageEmail];
            message['username'] = lastUserName[messageEmail];
            lastMessagesId[messageEmail] = message['id'];
            // print("Assigned profile pic: ${message['profilepic']} for email: $messageEmail"); // Debug print
            return message;
          }).toList();
        });

        List<dynamic> lastMessagesIdList = lastMessagesId.values.toList();
        setState(() {
          messagesId = lastMessagesIdList;
        });

        print('"Assigned ids: $messagesId');

        print('setting out $outputMessage');
      }
    }
    setState(() {
      isLoading = false;
    });
    print("out of $doctorEmails");
    await _noUnread(doctorEmails);

  }

 void initSocket() {
  // Replace with your server's IP and port
  socket = IO.io('http://$ipconfig:3000', IO.OptionBuilder()
      .setTransports(['websocket']) // for Flutter or Dart VM
      .disableAutoConnect() // disable auto-connection
      .build());

  socket.connect();

  socket.onConnect((_) {
    print('Connected to Socket.io server');
    // Register the patient's email
    socket.emit('register', email); // Emit the patient's email for identification
    socket.emit('reload_register', email);
  });

  socket.on('reload message', (data) {
      
      // setState(() {
      //   outputMessage.add(json.decode(data));
      // });
      var decodedMessage = json.decode(data);
   print (' decodedReload $decodedMessage');
    _noUnread(doctorEmails);
    });

    

  socket.on('chat message', (data) {
   var decodedMessage = json.decode(data);
   print (' decodedMessage $decodedMessage');
   // Extract details from the message
  //  String senderEmail = decodedMessage['email'];
  //  String receiverEmail = decodedMessage['doctoremail'];
  //  String messageText = decodedMessage['mymessage'];

setState(() {
          Map<String, dynamic> lastMessages = {
            for (var msg in outputMessage) _generateEmailPairKey(msg['doctoremail'], msg['email']): msg
          };

          // Update the message
          String emailPairKey = _generateEmailPairKey(decodedMessage['doctoremail'], decodedMessage['email']);

          if (lastMessages.containsKey(emailPairKey)) {
            var existingMessage = lastMessages[emailPairKey];
            decodedMessage['profilepic'] = existingMessage['profilepic'];
            decodedMessage['username'] = existingMessage['username'];

            // print("The name through WebSocket: ${existingMessage}");
          }

          // Insert or update the message at the top of the list
          lastMessages[emailPairKey] = decodedMessage;
          outputMessage = [decodedMessage, ...lastMessages.values.where((msg) => msg != decodedMessage).toList()];
        });
//         // print("The output message through WebSocket: $outputMessage");
        _noUnread(doctorEmails);
//       },
  
});

  socket.onDisconnect((_) {
    print('Disconnected from Socket.io server');
  });
}
  Future<void> _processUnreadMessage(dynamic decodedMessage) async {
    setState(() {
      outputMessage = outputMessage.map((message) {
        print('email eamil through ${message['doctoremail']}');
        print('email eamil through ${decodedMessage['Email']}');
        if (message['doctoremail'] == decodedMessage['Email']) {
          _noUnread(doctorEmails);
        }
        return message;
      }).toList();
    });
    print("unread unread through back WebSocket: $outputMessage");
  }

  String _generateEmailPairKey(String email1, String email2) {
    List<String> emailPair = [email1, email2];
    emailPair.sort(); // Sort to ensure the key is the same regardless of order
    return emailPair.join("_");
  }

  @override
  void initState() {
    super.initState();
    _userMessages();
    _tabController = TabController(length: 3, vsync: this);
    
  }

  @override
  void dispose() {
    socket.dispose();
    // channel.sink.close();
    // reloadChatListchannel.sink.close();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        backgroundColor: Colors.white,
      ),
        backgroundColor: Colors.white,
         body: 
         isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF010043)),
              ),
            )
          :
           outputMessage.isEmpty ?

         Padding(
  padding: const EdgeInsets.only(left: 20, right: 20),
  child: Center(
    child: Container(
      decoration: BoxDecoration(
        // color: customColor, 
        borderRadius: BorderRadius.circular(12),  
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: 60,
              color: Colors.blue.shade900,  
            ),
            SizedBox(height: 12),
            Text(
              'No Messages Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF5F5F5),  
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Start a conversation to see messages here. Reach out to someone to begin chatting!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFB0BEC5),  
              ),
            ),
          ],
        ),
      ),
    ),
  ),
)

    : 
    ListView.builder(
          itemCount: outputMessage.length,
          itemBuilder: (context, index) {
            // final chatService = Provider.of<ChatService>(context);
            //            var pmessage = chatService.getMessages()[index];
            //            print('provider $pmessage');
            var message = outputMessage[index];

            // Identify the DoctorEmail for this message
            String messageEmail = message['email'] == email
                ? message['doctoremail']
                : message['email'];

            // Retrieve the unread count for this message email
            int unreadCount = unreadCounts[messageEmail] ?? 0;
            print(" for message email $message");
            print(
                "Unread count for message email ($messageEmail): $unreadCount"); // Debugging print

            return GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   PageTransition(
                //     type: PageTransitionType.bottomToTop,
                //     child: NewChatScreen(dataUrl: messageEmail),
                //   ),
                // );

                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.bottomToTop,
                    child: ChatApp(dataUrl: messageEmail),
                  ),
                );
              },
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.11,
                      width: MediaQuery.of(context).size.width * 0.9,
                      color: Colors.white,
                      child: Row(
                        children: [
                          message['profilepic'] == null
                              ? const Icon(
                                  Icons.person,
                                  size: 20,
                                )
                              : SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.network(
                                      "https://healthtok.onrender.com/profile_img/${message['profilepic']}",
                                      fit: BoxFit.cover,
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        return const Icon(
                                          Icons.account_circle,
                                          size: 40.0,
                                          color: Color(0xFF010043),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                          const SizedBox(width: 10),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.09,
                            width: MediaQuery.of(context).size.width * 0.6,
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Text(
                                  message['username'] ?? 'text',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  message['mymessage'] ?? 'text',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.09,
                            width: MediaQuery.of(context).size.width * 0.12,
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Container(
                                  height: 16,
                                  width: 16,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF010043),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (unreadCount > 0)
                                        Text(
                                          unreadCount.toString(),
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white),
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
                  ],
                ),
              ),
            );
          },
        ));
  }
}
