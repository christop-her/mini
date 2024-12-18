import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mini/responsivity/mobileUpdate.dart';
import 'package:mini/responsivity/mobileUserStore.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:mini/ipconfig.dart';

class UpdateSpic extends StatefulWidget {
  const UpdateSpic({super.key});

  @override
  State<UpdateSpic> createState() => _UpdateSpicState();
}

class _UpdateSpicState extends State<UpdateSpic> {


  var userData;

  String email = '';
  String storeName = '';
  String address = '';
  String storeType = '';
  String mainImage = '';
  File? _image;
  final picker = ImagePicker();
  late WebSocketChannel channel;

  Future<void> userDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString('email') ?? '';
      // this email is the user currently logged in
    });

    var url = "http://$ipconfig/apisocial/store_data.php";
    var response = await http.post(Uri.parse(url), body: {
      'email': email,
    });
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['message'] == 'login successful') {
        setState(() {
          userData = jsonResponse['data'][0];
          storeName = userData['storeName'];
          address = userData['address'];
          storeType = userData['storeType'];
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

    final uri = Uri.parse("http://$ipconfig/apisocial/updateSpic.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['email'] = email;

    var pic = await http.MultipartFile.fromPath("image_01", _image!.path); // Use ! to assert that _image is not null
    request.files.add(pic);
    var response = await request.send();

    if (response.statusCode == 200) {
      print('image uploaded');

      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileUpdate()));
      // Clear image
      // setState(() {
      //   _image = null;
      // });
    } else {
      print('image not uploaded');
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
                              "http://$ipconfig/apisocial/registered_img/$mainImage",
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            ),
                    ),
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
