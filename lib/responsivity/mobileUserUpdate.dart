import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini/responsivity/selectStore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mini/responsivity/mobileUpdateUpic.dart';
import 'package:mini/responsivity/mobileUserStore.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:mini/ipconfig.dart';

class UserUpdate extends StatefulWidget {
  const UserUpdate({super.key});

  @override
  State<UserUpdate> createState() => _UserUpdateState();
}

class _UserUpdateState extends State<UserUpdate> {
 
  TextEditingController user_name = TextEditingController();
  TextEditingController user_address = TextEditingController();
  TextEditingController user_password = TextEditingController();

  List<dynamic> userUploads = [];
  List<dynamic> likeOutput = [];
  List<dynamic> followOutput = [];
  var userData;
  var userInfo;
  var userFollower;
  var userlike;
  int noFollow = 0;
  int noLike = 0;
  String userEmail = '';
  String email = '';
  String userAddress = '';
  String userName = '';
  String userPassword = '';
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

  var myurl = "http://$ipconfig/apisocial/userData.php";
  var response = await http.post(Uri.parse(myurl), body: {
    'email': email,
  });

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success'] == 'login successful') {
      setState(() {
        userInfo = jsonResponse['data'][0];
        userName = userInfo['name'];
        userAddress = userInfo['address_locality'];
        mainImage = userInfo['image_01'];
        userPassword = userInfo['password'];
      });
    }
  }
  setState(() {
    user_name.text = userName;
    user_address.text = userAddress;
    user_password.text = userPassword;
  });
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


   Future <void> update() async{
    var url = "http://$ipconfig/apisocial/updateUserProfile.php";
    var response = await http.post(Uri.parse(url),
    body: {
        'email': email,
        'name': user_name.text,
        'address_locality' : user_address.text,
        'password': user_password.text,
    },
    );
   
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success'] == 'update successful'){
      Navigator.push(context, MaterialPageRoute(builder: (context) => Selectstore()));
     print('updated');  
}
}


   
//   Future<void> updateProfile() async {
//   if (_image == null) {
//     // Handle the case where _image is null
//     return;
//   }

//   final uri = Uri.parse("http://$ipconfig/practice/upload_service.php");
//   var request = http.MultipartRequest('POST', uri);
//   request.fields['email'] = email;
//   request.fields['BusinessName'] = BusinessName.text;
//   request.fields['BusinessType'] = BusinessType.text;
//   request.fields['BusinessAddress'] = BusinessAddress.text;
//   request.fields['BusinessDescription'] = BusinessDescription.text;


//   var pic = await http.MultipartFile.fromPath("image_01", _image!.path); // Use ! to assert that _image is not null
//   request.files.add(pic);
//   var response = await request.send();

//   if (response.statusCode == 200) {
//     print('image uploaded');
//     print(email);

//     userDetails();
//     // Clear image
//     setState(() {
//       _image = null;
//     });

//   } else {
//     print('image not uploaded');
//   }
// }




int calculateCrossAxisCount(BuildContext context) {
    // Calculate the appropriate cross axis count based on screen width
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = (screenWidth / 120).round(); // Adjust 150 as per your item size
    return crossAxisCount;
  }







//  @override
//    void initState(){
//     super.initState();
//     BusinessName.text;
//   }


  @override
   void initState(){
    super.initState();
    userDetails();
  }

   @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: Text('Edit User Profile', style: TextStyle(fontWeight: FontWeight.w500),)),
      body:  Center(
        child: Container(
          padding: EdgeInsets.only(top: 10),
          color: Colors.white,
          width: 1000,
          child: SingleChildScrollView(
            
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(height: 10,),
             Column(
               children: [
                 Container(
                        height: 250,
                         child: Stack(
                           children: [
                             Container(
                             decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                             ),
                             width: 500,
                             height: 200,
                             child: Image.network(
                              "http://$ipconfig/apisocial/profile_img/${mainImage}",
                              fit: BoxFit.cover, // Ensure the image covers the entire space
                            ),
                                       ),
                         
                                      
                         
                                        Positioned(
                                          left: 140,
                                          top: 140,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateUpic()));
                                            },
                                            child: Container(
                                                                      width: 100,
                                                                     height: 100,
                                                                      decoration: BoxDecoration(
                                                                         color: Colors.black12,
                                                                         border: Border.all(
                                                                          color: Colors.white,
                                                                          width: 2
                                                                         ),
                                                                         borderRadius: BorderRadius.circular(100)
                                                                      ),
                                                           child: Icon(Icons.camera_alt, size: 80, color: Colors.white,),
                                                                    ),
                                          ),
                                        ),
                           ],
                         
                         
                         ),
                       
                       ),


                     
                   SizedBox(height: 25,),

                 Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only( top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    // color: Colors.grey
                    border: Border.symmetric(horizontal: BorderSide(width: 1, color: Colors.grey))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.work, color: Colors.red,),
                      SizedBox(width: 10,),
                      Text('EDIT USER ', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15,),),
                    ],
                  ),
                 ),
                 SizedBox(height: 25,),

                 Padding(padding: EdgeInsets.only(left: 10, right: 10),
                 
                 child: Column(
                  children: [

                    Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text('user Name'),
                      ),
                      Container(
                      decoration: BoxDecoration(
                       border: Border.all(
                        color: Colors.black,
                        width: 1
                       ),
                      //  borderRadius: BorderRadius.circular(50) 
                      ),
                      child: Padding(
                        
                        padding: EdgeInsets.only(left: 10),
                        child: TextField(
                          controller: user_name,
                          decoration: InputDecoration(
                            border: InputBorder.none
                          ),  
                        ),
                      ),
                    ),
                    ],
                  ),

                    SizedBox(height: 15,),

                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text('user address'),
                      ),
                      Container(
                      decoration: BoxDecoration(
                       border: Border.all(
                        color: Colors.black,
                        width: 1
                       ),
                      //  borderRadius: BorderRadius.circular(50) 
                      ),
                      child: Padding(
                        
                        padding: EdgeInsets.only(left: 10),
                        child: TextField(
                          controller: user_address,
                          decoration: InputDecoration(
                            border: InputBorder.none
                          ),  
                        ),
                      ),
                    ),
                    ],
                  ),


  SizedBox(height: 15,),

                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text('user password'),
                      ),
                      Container(
                      decoration: BoxDecoration(
                       border: Border.all(
                        color: Colors.black,
                        width: 1
                       ),
                      //  borderRadius: BorderRadius.circular(50) 
                      ),
                      child: Padding(
                        
                        padding: EdgeInsets.only(left: 10),
                        child: TextField(
                          controller: user_password,
                          decoration: InputDecoration(
                            border: InputBorder.none
                          ),  
                        ),
                      ),
                    ),
                    ],
                  ),



                  ],
                 ),),

                   



                         
               ],
             ),
SizedBox(height: 15,),

              GestureDetector(
          onTap: (){
            // update();
          },
                     child: Container(
                      width: 200,
                      padding: EdgeInsets.only( top: 15, bottom: 15),
                      decoration: BoxDecoration(
                        color:  Color(0xFF248560),
                        borderRadius: BorderRadius.circular(10)
                      ),
                       child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('update profile', style: TextStyle(color: Colors.white),),
                          SizedBox(width: 5,),
                          Icon(Icons.send_rounded, color: Colors.white,),
                          
                        ],
                                       ),
                     ),
                                    ),
      SizedBox(height: 10,),

            ],

            
            
          ),
              ),
        ),
      ),
    );

  
  }
}