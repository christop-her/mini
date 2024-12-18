import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini/responsivity/mobileUserStore.dart';
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

class Selectstore extends StatefulWidget {
  const Selectstore({super.key});

  @override
  State<Selectstore> createState() => _SelectstoreState();
}

class _SelectstoreState extends State<Selectstore> {
 
  TextEditingController price = TextEditingController();
  TextEditingController name = TextEditingController();

  List<dynamic> userUploads = [];
  List<dynamic> userData = [];
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

 

  // proximityChecker.startListening();
   SharedPreferences preferences = await SharedPreferences.getInstance();
  setState(() {
    email = preferences.getString('email') ?? '';
  });


setState(() {
  isLoading = true;
});
  
    var url = "http://$ipconfig/apisocial/selectstore.php";
    var response = await http.post(Uri.parse(url),
    body: {
        'email': email
    },
    );
    
   if(response.statusCode == 200){

     setState(() {
      isLoading = false;
    });
    
    var jsonResponse = json.decode(response.body);
    
    if(jsonResponse['message'] == 'login successful'){
    print('jsonResponse: ${jsonResponse['data']}');
    setState(() {
      userData = jsonResponse['data'];
    //   storeName = userData['storeName'];
    //   address = userData['address'];
    //   storeType = userData['storeType'];
    //   mainImage = userData['image_01'];
    //   followingEmail = userData['email'];
    }); 

    print('jsonResponse: ${userData}');

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



  @override
   void initState(){
    super.initState();
    userDetails();
    
  }

  
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(title: Text('Select store', style: TextStyle(fontWeight: FontWeight.w500),)),
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
      
        :  
        ListView.builder(
          itemCount: userData.length,
          itemBuilder: (context, index){
            var data = userData[index];
       return Padding(
         padding: const EdgeInsets.all(8.0),
         child: GestureDetector(
         onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => mobileUserStore(dataStoreName: data['storeName'], dataId: data['id'])));
         },
            child: Container(
                                          
             padding:  EdgeInsets.all(10),
              decoration: BoxDecoration(
               color: Colors.blueAccent,
                 borderRadius: BorderRadius.circular(10),
         ),
            child: Center(
            child: Text(
              data['storeName'],
             style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
           ),
          ),
          ),
       );
          }
        
        
        )     
      
    );

  
  }
}