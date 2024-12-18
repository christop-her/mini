import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mini/ipconfig.dart';
import 'package:mini/responsivity/selectStore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mini/responsivity/mobileUserStore.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class UpdateUpic extends StatefulWidget {
  const UpdateUpic({super.key});

  @override
  State<UpdateUpic> createState() => _UpdateUpicState();
}

class _UpdateUpicState extends State<UpdateUpic> {

  var userData;

  String email = '';
  String storeName = '';
  String address = '';
  String storeType = '';
  String mainImage = '';
  File? _image;
  final picker = ImagePicker();
  late WebSocketChannel channel;

  void successPopup(BuildContext context) {
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });

        
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          insetPadding: EdgeInsets.only(bottom: 650),
            child: Container(
              // color:Color(0xFF248560),
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
              height: 80,
              child: Column(
                
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Text('updated successfully', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),),
                  )
                ],
              ),
            ),
        );
      },
    ).then((result) {
    if (result == true) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Selectstore()),
      );
    }
  });
}

  

void Popup(BuildContext context) {
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });

        
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          insetPadding: EdgeInsets.only(bottom: 650),
            child: Container(
              // color:Color(0xFF248560),
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
              height: 80,
              child: Column(
                
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Text('not successful', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),),
                  )
                ],
              ),
            ),
        );
      },
    );
  }



  Future<void> userDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString('email') ?? '';
      // this email is the user currently logged in
    });

    var url = "http://$ipconfig/apisocial/userdata.php";
    var response = await http.post(Uri.parse(url), body: {
      'email': email,
    });
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['success'] == 'login successful') {
        setState(() {
          userData = jsonResponse['data'][0];
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

  Future<void> updateStorePic() async {
    if (_image == null) {
      // Handle the case where _image is null
      return;
    }

    final uri = Uri.parse("http://$ipconfig/apisocial/updateUpic.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['email'] = email;

    var pic = await http.MultipartFile.fromPath("image_01", _image!.path); // Use ! to assert that _image is not null
    request.files.add(pic);
    var response = await request.send();

    if (response.statusCode == 200) {
     successPopup(context); 
    } else {
      Popup(context);
    }
  }

  int calculateCrossAxisCount(BuildContext context) {
    // Calculate the appropriate cross axis count based on screen width
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = (screenWidth / 120).round(); // Adjust 150 as per your item size
    return crossAxisCount;
  }

  @override
  void initState() {
    super.initState();
    userDetails();
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
        title: Text(
          'Chris Codecraft',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(top: 10),
          color: Colors.white,
          width: 1000,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      width: 500,
                      height: 200,
                      child: _image == null
                          ? Image.network(
                              "http://$ipconfig/apisocial/profile_img/$mainImage",
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            ),
                    ),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _getImageFromGallery();
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 15, right: 15, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                                color: Color(0xFFC9C9C9),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.comment,
                                  color: Colors.black,
                                ),
                                Text(
                                  'choose',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            updateStorePic();
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 15, right: 15, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                                color: Color(0xFFC9C9C9),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.comment,
                                  color: Colors.black,
                                ),
                                Text(
                                  'update',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
