import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini/ipconfig.dart';
import 'package:mini/userslidemessage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mini/comment.dart';
import 'package:mini/receiverMessage.dart';
import 'package:mini/responsivity/desktopRegisterStore.dart';
import 'package:mini/responsivity/mobileRegisterStore.dart';
import 'package:mini/responsivity/responsiveRegisterStore.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class mobileTheStore extends StatefulWidget {
  final String dataUrl;
  const mobileTheStore({super.key, required this.dataUrl});

  @override
  State<mobileTheStore> createState() => _mobileTheStoreState();
}

class _mobileTheStoreState extends State<mobileTheStore> {

  TextEditingController price = TextEditingController();
  TextEditingController name = TextEditingController();

  List<dynamic> userUploads = [];
  List<dynamic> likeOutput = [];
  List<dynamic> followOutput = [];
  var userData;
  var userFollower;
  var userlike;
  int noFollow = 0;
  int noLike = 0;
  String userEmail = '';
  String email = '';
  String loginEmail = '';
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
  bool isLoading = false;



     Future<void> userDetails() async{



      SharedPreferences preferences = await SharedPreferences.getInstance();
  setState(() {
    loginEmail = preferences.getString('email') ?? '';
    // this email is the user currently logged in
  });

  setState(() {
    email = widget.dataUrl;
  });

//   channel = IOWebSocketChannel.connect('ws://$ipconfig:8080');

// channel.sink.add(json.encode({
//   'recieverEmail': email
// }));
// channel.stream.listen(
//   (message) {
//     print("Message received via WebSocket: $message");  // Debug print
    
//     setState(() {
//       likeOutput.add(json.decode(message));
//       print("like via WebSocket: ${likeOutput}");
//       // Get the last element in the likeOutput list
//       noLike = likeOutput.last['noLike'];
//     });
//   },
//   onError: (error) {
//     print("WebSocket error: $error");
//   },
//   onDone: () {
//     print("WebSocket connection closed");
//   },
// );


// channel = IOWebSocketChannel.connect('ws://$ipconfig:8080');
// channel.sink.add(json.encode({
//   'recieverEmail': email
// }));
// channel.stream.listen(
//   (message) {
//     print("Message received via WebSocket: $message");  // Debug print
    
//     setState(() {
//       followOutput.add(json.decode(message));
//       print("like via WebSocket: ${followOutput}");
//       // Get the last element in the likeOutput list
//       noFollow = followOutput.last['noFollow'];
//     });
//   },
//   onError: (error) {
//     print("WebSocket error: $error");
//   },
//   onDone: () {
//     print("WebSocket connection closed");
//   },
// );


setState(() {
  isLoading = true;
});
  
  fetchFollower();
  fetchLiked();

  likeNumber();
  followNumber();   

      var url = "http://$ipconfig/apisocial/store_data.php";
      // var myUrl = "http://$ipconfig/practice/output_user_service.php";
     
     
    var response = await http.post(Uri.parse(url),
    body: {
        'email': email
    },
    );
    print('object $email');
   if(response.statusCode == 200){
    var jsonResponse = json.decode(response.body);
    if(jsonResponse['message'] == 'login successful'){
   
    setState(() {
      userData = jsonResponse['data'][0];
      storeName = userData['storeName'];
      address = userData['address'];
      storeType = userData['storeType'];
      mainImage = userData['image_01'];
    }); 

    // print('addressName: $Name');

  //  var output = await http.post(Uri.parse(myUrl),
  //   body: {
  //       'email': email
  //   }
  //   );

  //   var jsonOutput = json.decode(output.body);
  //   setState(() {
  //      userUploads = jsonOutput;
  //   });


  
    }
    }
    setState(() {
      isLoading = false;
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

   Future<void> followNumber() async {
   var followUrl = "http://$ipconfig/apisocial/following_number.php";
   var following = await http.post(Uri.parse(followUrl),
    body: {
        'email': email 
        // this email is the current loaded store 
    }
    );
  print(email);
    var jsonResult = json.decode(following.body);
    setState(() {
       noFollow = jsonResult.length;
    });

     channel.sink.add(json.encode({
      'loginEmail': loginEmail,
      'recipientEmail': email,
      'noFollow': noFollow
    }));
    print("Message sent via WebSocket");
   }

Future<void> likeNumber() async {
   var likeUrl = "http://$ipconfig/apisocial/like_number.php";
   var liked = await http.post(Uri.parse(likeUrl),
    body: {
        'email': email 
        // this email is the current loaded store 
    }
    );

    var jsonLikeOutput = json.decode(liked.body);
    setState(() {
       noLike = jsonLikeOutput.length;
       
    });
    print(noLike.toString());

      channel.sink.add(json.encode({
      'loginEmail': loginEmail,
      'recipientEmail': email,
      'noLike': noLike
    }));
    print("Message sent via WebSocket");
}

  Future<void> postService() async {
  if (_image == null) {
    // Handle the case where _image is null
    return;
  }

  final uri = Uri.parse("http://$ipconfig/practice/upload_service.php");
  var request = http.MultipartRequest('POST', uri);
  request.fields['price'] = price.text;
  request.fields['name'] = name.text;
  request.fields['email'] = email;


  var pic = await http.MultipartFile.fromPath("image_01", _image!.path); // Use ! to assert that _image is not null
  request.files.add(pic);
  var response = await request.send();

  if (response.statusCode == 200) {
    print('image uploaded');
    print(email);

    userDetails();

     setState(() {
      price.clear();
      name.clear();
    });

    // Clear image
    setState(() {
      _image = null;
    });

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


 bool isFollow = false;

  void follow() async{
 var url = "http://$ipconfig/apisocial/follow.php";



    var response = await http.post(Uri.parse(url),
    body: {
        'loginEmail': loginEmail,
        'followingEmail': email,
        'storeName' : storeName,
        'mainImage': mainImage,
    },
    );
   
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success'] == 'follow successful'){
setState(() {
  isFollow = true;
  channel = IOWebSocketChannel.connect('ws://$ipconfig:8080');
});
  // print('success'); 
   userDetails(); 
}
}


void unfollow() async{
 var url = "http://$ipconfig/apisocial/unfollow.php";

 
    var response = await http.post(Uri.parse(url),
    body: {
        'loginEmail': loginEmail,
        'followingEmail': email,
        'storeName' : storeName,
        'mainImage': mainImage,
    },
    );
   
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success'] == 'unfollow successful'){
setState(() {
  isFollow = false;
  channel = IOWebSocketChannel.connect('ws://$ipconfig:8080');
});
  print('success');
    
}
userDetails();
}

 void fetchFollower() async{
 var url = "http://$ipconfig/apisocial/fetch_follower.php";
    var response = await http.post(Uri.parse(url),
    body: {
        'loginEmail': loginEmail,
        'followingEmail': email,
    },
    );
   
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success'] == 'follow successful'){
setState(() {
  // userFollower = jsonResponse['data'][0];
  isFollow = true;
});
// print('complete : $userFollower');
}
}

bool isLiked = false;

  Future <void> like() async{
 var url = "http://$ipconfig/apisocial/like_box.php";

    

    var response = await http.post(Uri.parse(url),
    body: {
        'loginEmail': loginEmail,
        'likeEmail': email,
        'storeName' : storeName,
        'mainImage': mainImage,
    },
    );
   
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success'] == 'like successful'){

setState(() {
  isLiked = true;
// channel = IOWebSocketChannel.connect('ws://$ipconfig:8080');

});
 
}
 userDetails(); 
}

void unlike() async{
 var url = "http://$ipconfig/apisocial/unlike_box.php";

 userDetails();
    var response = await http.post(Uri.parse(url),
    body: {
        'loginEmail': loginEmail,
        'likeEmail': email,
        'storeName' : storeName,
        'mainImage': mainImage,
    },
    );
   
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success'] == 'unlike successful'){
setState(() {
  isLiked = false;
  channel = IOWebSocketChannel.connect('ws://$ipconfig:8080');
});
  print('success');
    
}
}

void fetchLiked() async{
 var url = "http://$ipconfig/apisocial/fetch_like.php";
    var response = await http.post(Uri.parse(url),
    body: {
        'loginEmail': loginEmail,
        'likeEmail': email,
    },
    );
   
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success'] == 'like successful'){
setState(() {
  // userlike = jsonResponse['data'][0];
  isLiked = true;
});
print('complete : $userlike');
}
}




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
      appBar: AppBar(title: Text('Chris Codecraft', style: TextStyle(fontWeight: FontWeight.w500),)),
      body: 
      isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF010043)),
              ),
            )
          : 
             userData == null || userData.isEmpty
      
      ? Container(
        child: Column(
          children: [
           
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(50)
              ),
              child: Icon(Icons.shopify_sharp, size: 60,)),
            SizedBox(height: 5,),
            Text('You have not registered your store yet'),
            SizedBox(height: 5,),
            Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                           child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => mobileRegisterStore()));
                            },
                                       child: Container(
                                        padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
                                        decoration: BoxDecoration(
                                                     color:  Color(0xFF248560),
                                                     
                                                     borderRadius: BorderRadius.circular(10)
                                        ),
                                         child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                                     children: [
                                                       Container(
                                                         width: 30,
                                                         height: 30,
                                                         decoration: BoxDecoration(color: const Color.fromARGB(83, 245, 245, 245),
                                                         borderRadius: BorderRadius.circular(50)
                                                         ),
                                                         
                                                         child: Icon(Icons.store_sharp, color: Colors.white,)),
                                                     
                                                         SizedBox(width: 5,),
                                                       Text('Register Store', style: TextStyle(color: Colors.white),),
                                                     ],
                                     ),
                                       ),
                                     ),
                         ) ,
          ],
        ),
      )
      
      
      
        : Center(
        child: Container(
          padding: EdgeInsets.only(top: 10),
          color: Colors.white,
          width: 1000,
          child: SingleChildScrollView(
            
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [


            //    Text(loginEmail),
            // Text(email),
              // Container(
              //   color: Colors.white,
              //   // padding: EdgeInsets.only(left: 10,right: 10),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     children: [
              //       ElevatedButton(onPressed: (){}, child: Text('Closed')),
                
              //       Column(
              //         children: [
              //           Icon(Icons.store, color: Colors.green,),
              //           Text(storeType, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
              //         ],
              //       )
              //     ],
              //   ),
              // ),
          
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
                                                         child: Icon(Icons.person_add_alt_rounded, size: 80, color: Colors.white,),
                                                                  ),
                                        ),
                           ],
                         
                         
                         ),
                       
                       ),

                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            children: [
                              Icon(Icons.location_city, color: Colors.orange,),
                              SizedBox(width: 5,),
                              Text('Chris Codecraft', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),),
                            ],
                          ),
                        ),
                        SizedBox(width: 20,),

                        
                        Container(padding: EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.red[400],),
                               SizedBox(width: 5,),
                          Text(address),
                            ],
                          ),
                        ),
    

    

                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Column(
                    children: [
                      Text(noFollow.toString(),style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),),
                      Text('Followers',style: TextStyle(fontWeight: FontWeight.w600),),
                    ],
                  ),
                  SizedBox(width: 20,),
                   Column(
                    children: [
                      Text(noLike.toString(),style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),),
                      Text('Liked',style: TextStyle(fontWeight: FontWeight.w600),),
                    ],
                  )
                
                 ],) 
                         
               ],
             ),

          SizedBox(height: 10,),

                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Text(userData['description']),),


SizedBox(height: 20,),


    Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Row(
       mainAxisAlignment: MainAxisAlignment.center,
        children: [
        
        GestureDetector(
          onTap: (){
             Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatAppslide(dataUrl: email),
                ),
              );
          },
                     child: Container(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
                      decoration: BoxDecoration(
                        color:  Color(0xFF248560),
                        borderRadius: BorderRadius.circular(10)
                      ),
                       child: Row(
                        children: [
                          Text('Message', style: TextStyle(color: Colors.white),),
                          SizedBox(width: 5,),
                          Icon(Icons.send_rounded, color: Colors.white,),
                          
                        ],
                                       ),
                     ),
                                    ),
      
      SizedBox(width: 20,),
                                      GestureDetector(
                                        onTap: (){
                                        isFollow ?  unfollow() : follow();},
                     child: Container(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
                      decoration: BoxDecoration(
                        color:  Colors.white,
                        border: Border.all(
                          width: 1, color: Colors.black
                        ),
                        borderRadius: BorderRadius.circular(10)
                      ),
                       child:  isFollow ? Row(
                        
                        children: [
                          
                          Icon(Icons.check, color: Colors.black,),
                          SizedBox(width: 5,),
                          Text( 'Following', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16),),
                        ],
                                       ) : Text( 'Follow', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16),),
                     ),
                                    ),
      ],),
    ),

                 SizedBox(height: 40,),

                 Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                   child: Row(
                    children: [
                      GestureDetector(
                        onTap: (){isLiked ?  unlike() : like();},
                        child: Container(
                          padding: EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
                          decoration: BoxDecoration(color: Color(0xFFC9C9C9),
                           borderRadius: BorderRadius.circular(10)),
                          
                          child: isLiked ? Icon(Icons.thumb_up_rounded, color: Color(0xFF248560),): Icon(Icons.thumb_up_alt, color: Colors.black,) ),
                      ),
                 
                 
                   SizedBox(width: 20,),
                   
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Comment(activeEmail: email)));
                                    },
                                   child: Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
                    decoration: BoxDecoration(
                      color:Color(0xFFC9C9C9),
                      borderRadius: BorderRadius.circular(10)
                    ),
                     child: Row(
                      children: [
                        Icon(Icons.comment, color: Colors.black,),
                        Text('comments', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),),
                      ],
                                     ),
                   ),
                                  ),
                   
                                  SizedBox(width: 20,),
                   
                                  GestureDetector(
                   child: Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
                    decoration: BoxDecoration(
                      color:  Color(0xFFC9C9C9),
                      borderRadius: BorderRadius.circular(10)
                    ),
                     child: Row(
                      children: [
                        Icon(Icons.share, color: Colors.black,),
                        Text('share', style: TextStyle(color: Colors.black),),
                      ],
                                     ),
                   ),
                                  ),
                   
                   
                    ],
                   ),
                 )  ,
                 
                 SizedBox(height: 10,),
    

    userUploads.isEmpty ?  

     Container(
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(50)
              ),
              child: Icon(Icons.shopify_sharp, size: 60, color: Color(0xFF248560),)),
            SizedBox(height: 3,),
            Text('No photos added yet'),
          
           
          ],
        ),
      )
      

                : Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    border: Border.symmetric(horizontal: BorderSide(width: 1, color: Colors.grey)),
                    color: Colors.white
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopify_sharp, color: Colors.red, size: 30,),
                      SizedBox(width: 10,),
                      Text('Uploaded Service', style: TextStyle(fontWeight: FontWeight.w700),),
                    ],
                  ),
                 ),
                 
                 SizedBox(height: 20,),

 Container(
  // width: MediaQuery.of(context).size.width,
  // height: 500,
          child:GridView.builder(
            shrinkWrap: true,
           physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: calculateCrossAxisCount(context), 
          mainAxisSpacing: 1, 
          childAspectRatio: 2.5 / 3,
        ),
        itemCount: userUploads.length,
        itemBuilder: (context, index) {
          var uploads = userUploads[index];
          return Card(
            elevation: 0.5,
            shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Container(
                  width: 200,
                  height: 90,
                 
                   child: ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                     child: Image.network(
                                "http://$ipconfig/practice/uploaded_img/${uploads['image_01']}",
                                fit: BoxFit.cover, // Ensure the image covers the entire space
                              ),
                   ),
                 ),
                SizedBox(height: 1.0),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10,),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                   Text(uploads['name']),
                //  SizedBox(height: 2.0),
                   Text(uploads['price'].toString()),
                    ],
                  ),
                )
               
                // Add more details if needed
              ],
            ),
          );
        },
      ),
        ),



// Container(
//    padding: EdgeInsets.only(top: 10, bottom: 10),
//           child:GridView.builder(
//             physics: NeverScrollableScrollPhysics(),
//             shrinkWrap: true,
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: calculateCrossAxisCount(context), 
//           crossAxisSpacing: 2,
//           mainAxisSpacing: 2, 
//         ),
//         itemCount: 10,
//         itemBuilder: (context, index) {
         
//           return Card(
//             color: Colors.red[50],
//             elevation: 3.0,
//             child: Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'infinix',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 4.0),
//                   Text('200000'),
//                   // Add more details if needed
//                 ],
//               ),
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