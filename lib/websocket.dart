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
  List<dynamic> outputMessage = [];
  String person = 'user';
  String userName = '';
  String email = '';
  String activeEmail = '';
  var userData;
  String storeName = '';
  var mainImage;
  File? _image;
  final picker = ImagePicker();
  late WebSocketChannel channel;

  TextEditingController messageController = TextEditingController();

  Future<void> userDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString('email') ?? '';
    });

    setState(() {
      activeEmail = widget.dataUrl;
      allMessage();
      userProfile();
    });

    var url = "http://$ipconfig/apisocial/store_data.php";

    var response = await http.post(Uri.parse(url), body: {
      'email': activeEmail
    });

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['success'] == 'login successful') {
        setState(() {
          userData = jsonResponse['data'][0];
          storeName = userData['storeName'];
          mainImage = userData['image_01'];
        });
      }
    }
  }

  Future<void> _getImageFromGallery() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> messageMe() async {
    final uri = Uri.parse("http://$ipconfig/apisocial/message.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['myMessage'] = messageController.text;
    request.fields['activeEmail'] = activeEmail;
    request.fields['email'] = email;
    request.fields['name'] = userName;
    request.fields['person'] = person;

    if (_image != null) {
      var pic = await http.MultipartFile.fromPath("image_01", _image!.path);
      request.files.add(pic);
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      userDetails();
      allMessage();

      setState(() {
        messageController.clear();
      });

      // Clear image
      setState(() {
        _image = null;
      });

      // Send the message via WebSocket
      channel.sink.add(json.encode({
        'myMessage': messageController.text,
        'activeEmail': activeEmail,
        'email': email,
        'name': userName,
        'person': person,
        'image_01': _image != null ? _image!.path.split('/').last : ''
      }));
    }
  }

  void allMessage() async {
    var myurl = "http://$ipconfig/apisocial/allMessage.php";
    var res = await http.post(Uri.parse(myurl), body: {
      'email': email,
      'activeEmail': activeEmail
    });
    var jsonRes = json.decode(res.body);
    if (res.statusCode == 200) {
      setState(() {
        outputMessage = jsonRes;
      });
      print(jsonRes);
      print(outputMessage);
    }
  }

  Future<void> userProfile() async {
    var url = "http://$ipconfig/apisocial/userData.php";
    var response = await http.post(Uri.parse(url), body: {
      'email': email
    });
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['success'] == 'login successful') {
        setState(() {
          userData = jsonResponse['data'][0];
          userName = userData['name'];
        });
      }
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
    userDetails();
    channel = IOWebSocketChannel.connect('ws://192.168.187.26:8080/chat');
    channel.stream.listen((message) {
      setState(() {
        outputMessage.add(json.decode(message));
      });
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('AMAKA'),
            SizedBox(width: 10),
            Container(
              width: 50,
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  "http://$ipconfig/apisocial/registered_img/$mainImage",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("http://$ipconfig/apisocial/registered_img/$mainImage"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: outputMessage.length,
                itemBuilder: (context, index) {
                  var message = outputMessage[index];
                  return Container(
                    padding: EdgeInsets.all(10),
                    child: message['person'] == 'user'
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.green[200],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message['myMessage'],
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(message['email']),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              message['image_01'].isEmpty
                                  ? Container()
                                  : Container(
                                      color: Colors.black45,
                                      width: 100,
                                      child: Image.network(
                                        "http://$ipconfig/practice/uploaded_img/${message['image_01']}",
                                      ),
                                    ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message['myMessage'],
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(message['email']),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              message['image_01'].isEmpty
                                  ? Container()
                                  : Container(
                                      color: Colors.black45,
                                      width: 100,
                                      child: Image.network(
                                        "http://$ipconfig/practice/uploaded_img/${message['image_01']}",
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
                  _image != null
                      ? Row(
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
                            IconButton(
                              onPressed: () {
                                cancelImage();
                              },
                              icon: Icon(Icons.cancel_outlined),
                            ),
                          ],
                        )
                      : Container(),
                  BottomAppBar(
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            _getImageFromGallery();
                          },
                          icon: Icon(Icons.photo_library_rounded),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                controller: messageController,
                                decoration: InputDecoration(
                                  hintText: 'Type your message...',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            messageMe();
                          },
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
