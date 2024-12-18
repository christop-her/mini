import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini/responsivity/selectStore.dart';
// import 'package:mini/responsivity/locationchecker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mini/responsivity/mobileUpdate.dart';
import 'package:mini/responsivity/desktopRegisterStore.dart';
import 'package:mini/responsivity/mobileRegisterStore.dart';
import 'package:mini/responsivity/mobileUserUpdate.dart';
import 'package:mini/responsivity/responsiveRegisterStore.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:mini/ipconfig.dart';

class mobileUserStore extends StatefulWidget {
  final String dataStoreName;
  final int dataId;
  const mobileUserStore({super.key, required this.dataStoreName, required this.dataId});

  @override
  State<mobileUserStore> createState() => _mobileUserStoreState();
}

class _mobileUserStoreState extends State<mobileUserStore> {
 
  TextEditingController price = TextEditingController();
  TextEditingController name = TextEditingController();

  List<dynamic> userUploads = [];
  var userData;
  List<dynamic> likeOutput = [];
  List<dynamic> followOutput = [];
  int noLike = 0;
  int noFollow = 0;
  String followingEmail = '';
  String userEmail = '';
  String email = '';
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
  bool isLoading = true;

  // LocationProximityChecker proximityChecker = LocationProximityChecker();


     Future<void> userDetails() async{

 print('jsonResponse:');

  // proximityChecker.startListening();
   SharedPreferences preferences = await SharedPreferences.getInstance();
  setState(() {
    email = preferences.getString('email') ?? '';
  });


// channel = IOWebSocketChannel.connect('ws://$ipconfig:8080');
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
//       print("like via WebSocket: $followOutput");
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

  fetchState();
  getNoLike();
  
     var url = "http://$ipconfig/apisocial/store_dataSelect.php";
      // var myUrl = "http://192.168.50.26/apisocial/output_user_service.php";
    var response = await http.post(Uri.parse(url),
    body: {
        'id': widget.dataId.toString()
    },
    );
    
   if(response.statusCode == 200){

     setState(() {
      isLoading = false;
    });
    
    var jsonResponse = json.decode(response.body);
    
    if(jsonResponse['message'] == 'login successful'){
   print('jsonResponse: ${jsonResponse['data'][0]}');
    setState(() {
      userData = jsonResponse['data'][0];
      storeName = userData['storeName'];
      address = userData['address'];
      storeType = userData['storeType'];
      mainImage = userData['image_01'];
      followingEmail = userData['email'];
    }); 

    

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


  Future<void> postService() async {
  if (_image == null) {
    // Handle the case where _image is null
    return;
  }

  final uri = Uri.parse("http://$ipconfig/apisocial/upload_service.php");
  var request = http.MultipartRequest('POST', uri);
  request.fields['price'] = price.text;
  request.fields['name'] = name.text;
  request.fields['email'] = email;


  var pic = await http.MultipartFile.fromPath("image_01", _image!.path); // Use ! to assert that _image is not null
  request.files.add(pic);
  var response = await request.send();

  if (response.statusCode == 200) {
    print('image uploaded');
    userDetails();
    successPopup(context);

     setState(() {
      price.clear();
      name.clear();
    });

    // Clear image
    setState(() {
      _image = null;
    });

  } else {
    showPopup(context);
    // print('image not uploaded');
  }
}

void getNoLike() async {
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

}



int calculateCrossAxisCount(BuildContext context) {
    // Calculate the appropriate cross axis count based on screen width
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = (screenWidth / 120).round(); // Adjust 150 as per your item size
    return crossAxisCount;
  }


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
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
              height: 80,
              child: Column(
                
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 28),
                    child: Text('Photo added successfully', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),),
                  )
                ],
              ),
            ),
        );
      },
    );
  }

  void showPopup(BuildContext context) {
    
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
                    child: Text('Photo Not Added, Try Again ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),),
                  )
                ],
              ),
            ),
        );
      },
    );
  }


  bool isClosed = false;

void closed() async{
  var url = "http://$ipconfig/apisocial/closed.php";
  var response = await http.post(Uri.parse(url),
  body: {
    'email': email,
  }, 
  );
  var jsonResponse = json.decode(response.body);
  if(jsonResponse['success'] == 'closed successfully'){
setState(() {
  isClosed = true;
});
  }

}

void open() async{
var url = "http://$ipconfig/apisocial/open.php";
var response = await http.post(Uri.parse(url),
body: {
  'email': email
}
);
var jsonResponse = json.decode(response.body);
if(jsonResponse['success'] == 'open successfully'){
setState(() {
  isClosed = false;
});
}
}

void fetchState() async {
  var url = "http://$ipconfig/apisocial/fetch_state.php";
  var response = await http.post(Uri.parse(url),
  body: {
    'email': email
  }
  );
  var jsonResponse = json.decode(response.body);
  if(jsonResponse['success'] == 'successful'){
    setState(() {
      isClosed = true;
    });
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
      appBar: AppBar(title: Text('Your store', style: TextStyle(fontWeight: FontWeight.w500),)),
       body:isLoading
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
      
      
      
        :   Center(
        child: Container(
          padding: EdgeInsets.only(top: 10),
          color: Colors.white,
          width: 1000,
          child: SingleChildScrollView(
            
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                
                padding: EdgeInsets.only(left: 10,right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(onPressed: (){isClosed ? open() : closed();},  child: isClosed ? Text('Closed') : Text('Open')),
                
                    Column(
                      children: [
                        Icon(Icons.store, color: Colors.green,),
                        Text(storeType, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                      ],
                    )
                  ],
                ),
              ),
          
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
                                                                        width: 5
                                                                       ),
                                                                       borderRadius: BorderRadius.circular(100)
                                                                    ),
                                                         child: Icon(Icons.person_add_alt_rounded, size: 80, color: Colors.white,),
                                                                  ),
                                        ),
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
                  ),

                  SizedBox(width: 20,),
                   Column(
                    children: [
                      Text(noLike.toString(),style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),),
                      Text('comments',style: TextStyle(fontWeight: FontWeight.w600),),
                    ],
                  )
                
                 ],) ,
                         
SizedBox(height: 20,),
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            children: [
                              Icon(Icons.location_city, color: Colors.orange,),
                              SizedBox(width: 5,),
                              Text(storeName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
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
                        
                                                
                        SizedBox(width: 20,),
                                                
                         Padding(
                           padding: const EdgeInsets.all(10.0),
                           child: Column(
                           
                            
                             children: [
                           
                              Row(
                                children: [

                                  GestureDetector(
                                          onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => mobileRegisterStore()));
                            },
                                          child: Container(
                                            // margin: const EdgeInsets.all(8),
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.blueAccent,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Another Store',
                                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                       SizedBox(width: 2,),
                                       
                                  GestureDetector(
                                          // onTap: (){
                                          //   Navigator.push(context, MaterialPageRoute(builder: (context) => navigation));
                                          // },
                                          child: Container(
                                            // margin: const EdgeInsets.all(8),
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.blueAccent,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Go Premium',
                                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                           SizedBox(height: 10,),
                              Row(
                                children: [
                                  GestureDetector(
                                    // onTap: (){
                                    //   Navigator.push(context, MaterialPageRoute(builder: (context) => navigation));
                                    // },
                                    child: Container(
                                      // margin: const EdgeInsets.all(8),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Icon(Icons.build_circle_sharp), 
                                            SizedBox(width: 2,),
                                            Text(
                                              'Need workers?',
                                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              
                                  SizedBox(width: 2,),
                              
                                  GestureDetector(
                                    // onTap: (){
                                    //   Navigator.push(context, MaterialPageRoute(builder: (context) => navigation));
                                    // },
                                    child: Container(
                                      // margin: const EdgeInsets.all(8),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Icon(Icons.build_circle_sharp), 
                                            SizedBox(width: 2,),
                                            Text(
                                              'Advertise',
                                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              
                              
                                  
                                ],
                              ),
                              SizedBox(height: 10,),
                               Row(
                                 children: [
                                   Container(
                                     child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileUpdate()));
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
                                                                   
                                                                   child: Icon(Icons.person, color: Colors.white,)),
                                                               
                                                                   SizedBox(width: 5,),
                                                                 Text('Edit Store', style: TextStyle(color: Colors.white),),
                                                               ],
                                               ),
                                                 ),
                                               ),
                                   ),
                                   SizedBox(width: 2,),
                               
                                     Container(
                                
                                 child: GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserUpdate()));
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
                                                               
                                                               child: Icon(Icons.person, color: Colors.white,)),
                                                           
                                                               SizedBox(width: 5,),
                                                             Text('Edit User', style: TextStyle(color: Colors.white),),
                                                           ],
                                           ),
                                             ),
                                           ),
                               ) ,
                                 ],
                               ),
                             ],
                           ),
                         ) ,
               ],
             ),

          SizedBox(height: 10,),

                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Text('Description of your store thats appealing for users to read and also patronize you, thats appealing for users to read and also patronize you,thats appealing for users to read and also patronize you', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),)),


                 SizedBox(height: 20,),

                 Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                   child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
                        decoration: BoxDecoration(color: Color(0xFFC9C9C9),
                         borderRadius: BorderRadius.circular(10)),
                        
                        child: Icon(Icons.thumb_up_off_alt_sharp,)),
                   SizedBox(width: 20,),
                   
                                  GestureDetector(
                                    onTap: (){
                                      // Navigator.push(context, MaterialPageRoute(builder: (context) =>Comment()));
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
                                    // onTap: (){
                                    //   Navigator.push(context, MaterialPageRoute(builder: (context) => RecievedMessages()));
                                    // },
                   child: Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
                    decoration: BoxDecoration(
                      color:  Color(0xFF248560),
                      borderRadius: BorderRadius.circular(10)
                    ),
                     child: Row(
                      children: [
                        Icon(Icons.messenger_rounded, color: Colors.white,),
                        SizedBox(width: 8,),
                        Text('Messages', style: TextStyle(color: Colors.white),),
                      ],
                                     ),
                   ),
                                  ),
                   
                   
                    ],
                   ),
                 )  ,
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
                      Text('Upload Your service', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15,),),
                    ],
                  ),
                 ),
                 
                 SizedBox(height: 10,),
        
         Container(
          // padding: EdgeInsets.only(top: 10),
          color: Colors.grey[200],
           child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               _image != null
                              ? Container(
                                
                                width: 100,
                               height: 100,
                                decoration: BoxDecoration(
                                ),
                                child: Image.file(
                                    _image!,
                                    fit: BoxFit.cover,
                                    
                                  ),
                              )
                              :Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: Container(
                                  
                                  width: MediaQuery.of(context).size.width,
                                 height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                     color: Colors.grey[300],
                                  ),
                                                   child: Icon(Icons.car_rental, size: 100,),
                                ),
                              ),
            SizedBox(height: 10,),
            Container(
             padding: EdgeInsets.only(left: 10, right: 10),
              child: ElevatedButton(
                  onPressed: _getImageFromGallery,
                  child: Text('Select Image'),
                ),
            ),
                
           
            SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: TextFormField(
                            controller: price,
                            //  onChanged: (val) => _checkFormValid(),
                            validator: (val) => val!.isEmpty ? "Name cannot be blank" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Icon(Icons.email, color: Color(0xFF010043)),
                              ),
                              labelText: 'Amount',
                              labelStyle: TextStyle(color: Colors.grey[700]),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                                            ),
                      ),
                               SizedBox(height: 10,),
                           
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.black, width: 1),
                                                        borderRadius: BorderRadius.circular(50),
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(right: 10.0),
                                                        child: TextFormField(
                                                          controller: name,
                                                          //  onChanged: (val) => _checkFormValid(),
                                                          validator: (val) => val!.isEmpty ? "Name cannot be blank" : null,
                                                          decoration: InputDecoration(
                                                            prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Icon(Icons.email, color: Color(0xFF010043)),
                                                            ),
                                                            labelText: 'Name of service/product',
                                                            labelStyle: TextStyle(color: Colors.grey[700]),
                                                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                                                            border: InputBorder.none,
                                                            contentPadding: const EdgeInsets.symmetric(vertical: 16),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                              ),
           SizedBox(height: 10,),
                               
           Container(
             padding: EdgeInsets.only(left: 10, right: 10),
             child: GestureDetector(
              onTap: (){postService();},
              child: Container(
                padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
               
                decoration: BoxDecoration(
                  color: Color(0xFF248560),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Text('Upload', style: TextStyle(color: Colors.white),),
              ),
             ),
           )
                              
           
             ],
           ),
         ),

           

 SizedBox(height: 25,),

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
            Text('You have not uploaded any product photos yet'),
          
           
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
                      Icon(Icons.vertical_shades_closed, color: Colors.red,),
                      SizedBox(width: 10,),
                      Text('Uploaded Service', style: TextStyle(fontWeight: FontWeight.w700),),
                    ],
                  ),
                 ),
                 
                 SizedBox(height: 20,),

 Container(
          child:GridView.builder(
            shrinkWrap: true,
           physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: calculateCrossAxisCount(context), 
          mainAxisSpacing: 1.0, 
        ),
        itemCount: userUploads.length,
        itemBuilder: (context, index) {
          var uploads = userUploads[index];
          return Card(
            
            elevation: 0.5,
            shape: RoundedRectangleBorder(
             
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Container(
                  width: 200,
                  height: 120,
                   child: Image.network(
                              "http://$ipconfig/practice/uploaded_img/${uploads['image_01']}",
                              fit: BoxFit.cover, // Ensure the image covers the entire space
                            ),
                 ),
                SizedBox(height: 3.0),
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
      )
      
      
    );

  
  }
}