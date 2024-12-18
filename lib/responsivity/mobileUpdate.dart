import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini/responsivity/selectStore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mini/responsivity/mobileUpdateSPic.dart';
import 'package:mini/responsivity/mobileUserStore.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:mini/ipconfig.dart';

class ProfileUpdate extends StatefulWidget {
  const ProfileUpdate({super.key});

  @override
  State<ProfileUpdate> createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {

  TextEditingController BusinessName = TextEditingController();
  TextEditingController BusinessAddress = TextEditingController();
  TextEditingController BusinessType = TextEditingController();
  TextEditingController BusinessDescription = TextEditingController();
  TextEditingController BusinessContact = TextEditingController();
  TextEditingController user_name = TextEditingController();
  TextEditingController user_address = TextEditingController();
  TextEditingController user_email = TextEditingController();
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
  String storeName = '';
  String address = '';
  String storeType = '';
  String caption = '';
  String contact = '';
  String description = '';
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
        description = userData['description'];
        contact = userData['contact'];

        BusinessName.text = storeName;
        BusinessAddress.text = address;
        BusinessType.text = storeType;
        BusinessDescription.text = description;
        BusinessContact.text = contact;
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


   Future <void> update() async{
    var url = "http://$ipconfig/apisocial/updateProfile.php";
    var response = await http.post(Uri.parse(url),
    body: {
        'email': email,
        'storeName': BusinessName.text,
        'storeType' : BusinessType.text,
        'description': BusinessDescription.text,
        'address': BusinessAddress.text,
        'contact': BusinessContact.text,

    },
    );
   
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success'] == 'update successful'){

     successPopup(context);  
     
    }else{
     Popup(context);
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
      appBar: AppBar(title: Text('Edit Store Profile', style: TextStyle(fontWeight: FontWeight.w500),)),
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
                              "http://$ipconfig/apisocial/registered_img/${mainImage}",
                              fit: BoxFit.cover, // Ensure the image covers the entire space
                            ),
                                       ),
                         
                                      
                         
                                        Positioned(
                                          left: 140,
                                          top: 140,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateSpic()));
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
                      Text('EDIT STORE', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15,),),
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
                        child: Text('StoreName'),
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
                          controller: BusinessName,
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
                        child: Text('StoreAddress'),
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
                          controller: BusinessAddress,
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
                        child: Text('StoreType'),
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
                          controller: BusinessType,
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
                        child: Text('StoreDescription'),
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
                          controller: BusinessDescription,
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
                        child: Text('StoreContact'),
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
                          controller: BusinessContact,
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
            update();
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

       
//  Container(
//   // width: MediaQuery.of(context).size.width,
//   // height: 500,
//           child:GridView.builder(
//             shrinkWrap: true,
//            physics: NeverScrollableScrollPhysics(),
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: calculateCrossAxisCount(context), 
//           mainAxisSpacing: 1, 
//           childAspectRatio: 2.5 / 3,
//         ),
//         itemCount: userUploads.length,
//         itemBuilder: (context, index) {
//           var uploads = userUploads[index];
//           return Card(
//             elevation: 0.5,
//             shape: RoundedRectangleBorder(
//              borderRadius: BorderRadius.circular(10)
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                  Container(
//                   width: 200,
//                   height: 90,
                 
//                    child: ClipRRect(
//                     borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
//                      child: Image.network(
//                                 "http://$ipconfig/practice/uploaded_img/${uploads['image_01']}",
//                                 fit: BoxFit.cover, // Ensure the image covers the entire space
//                               ),
//                    ),
//                  ),
//                 SizedBox(height: 1.0),
//                 Container(
//                   padding: EdgeInsets.only(left: 10, right: 10,),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                    Text(uploads['name']),
//                 //  SizedBox(height: 2.0),
//                    Text(uploads['price'].toString()),
//                     ],
//                   ),
//                 )
               
//                 // Add more details if needed
//               ],
//             ),
//           );
//         },
//       ),
//         ),
 
            ],

            
            
          ),
              ),
        ),
      ),
    );

  
  }
}