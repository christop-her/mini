import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:mini/statesRow.dart';
import 'package:http/http.dart' as http;
import 'package:mini/stores.dart';
import 'package:mini/ipconfig.dart';

class mobilefirstPage extends StatefulWidget {
  const mobilefirstPage({super.key});

  @override
  State<mobilefirstPage> createState() => _mobilefirstPageState();
}

class _mobilefirstPageState extends State<mobilefirstPage> {
 List<dynamic> userLocations = [];
 var userData;
 String addressName = '';
 String addressid = '';
 String email = '';
 
// Future getEmail() async {
//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   setState(() {
//     email = preferences.getString('email') ?? '';
//   });

// }
// first we get session userEmail then send email to identify logged in user and get also their location then send that location to get list of users in same location 
Future<void> closeLocation() async{
   SharedPreferences preferences = await SharedPreferences.getInstance();
  setState(() {
    email = preferences.getString('email') ?? '';
  });
  
     var url = "http://$ipconfig/apisocial/userData.php";
     var myUrl = "http://$ipconfig/apisocial/nearby.php";
    var response = await http.post(Uri.parse(url),
    body: {
        'email': email
    },
    );
   if(response.statusCode == 200){
    var jsonResponse = json.decode(response.body);
    if(jsonResponse['success'] == 'login successful'){
    
    setState(() {
       userData = jsonResponse['data'][0];
      addressName = userData['address_locality'];
      addressid = userData['id'].toString();
       
    }); 
      
     
    var output = await http.post(Uri.parse(myUrl),
    body: {
        'address': addressName,
        'addressid': addressid.toString(),
    }
    );
    var jsonOutput = json.decode(output.body);
    setState(() {
       userLocations = jsonOutput;
    });
    print('same location: $userLocations');
    print('addressName: $addressName');
    }
    }
  }


// Future<void> closeLocation() async{
//      var myUrl = "http://192.168.104.26/practice/user_location.php";
//     var output = await http.post(Uri.parse(myUrl),
//     body: {
//         'address_locality': addressName
//     }
//     );
//    if(output.statusCode == 200){
//     var jsonOutput = json.decode(output.body);
//     if(jsonOutput['success'] == 'login successful'){
//     // String userName = jsonResponse['name'];
//     var userLocation = jsonOutput['data'][0];
//     // setState(() {
//     //   closeBy = userData['address_locality'];
//     // }); // Access the first element of the 'data' array
    
//     print('User name: $userLocation');
//     }else{
//     print('not successful');
//    }
//    }else{
//     print('request failed with status: ${output.statusCode}');
//    }
//   }

int calculateCrossAxisCount(BuildContext context) {
    // Calculate the appropriate cross axis count based on screen width
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = (screenWidth / 120).round(); // Adjust 150 as per your item size
    return crossAxisCount;
  }


  @override
  void initState(){
    super.initState();
    closeLocation();
    
  }
  Widget build(BuildContext context) {

    // final currentWidth = MediaQuery.of(context).size.width;

    return SafeArea(child: SingleChildScrollView(
    
      child: Column(
        children: [
          Container(
           width: 500,
            
                    height: 150,
                    child: Image(image: AssetImage('images/sperf.JPG'),
                     fit: BoxFit.cover,),
 
          ),

   SizedBox(height: 15,),

          stateRow(),

          SizedBox(height: 15,),

         Container(
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
                      Text('Stores Near Account address', style: TextStyle(fontWeight: FontWeight.w700),),
                    ],
                  ),
                 ),

        SizedBox(height: 10,),

  Container(
  padding: EdgeInsets.only(left: 10, right: 10),
  width: MediaQuery.of(context).size.width,
  height: 200, // Adjust the height as needed
  child: GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5, // Number of boxes in a row
        childAspectRatio: 1, // Adjust the aspect ratio as needed
        crossAxisSpacing: 1, // Space between boxes horizontally
        mainAxisSpacing: 1, // Space between boxes vertically
      ),
    physics: NeverScrollableScrollPhysics(),
    itemCount: userLocations.length,
    itemBuilder: (context, index) {
      var location = userLocations[index];
      return Container(
        width: 300, 
        child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => mobileTheStore(dataUrl: location['email']),
                ),
              );
            },
             child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Ensures full width
          children: [
            // Image at the top
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ), 
              child: Image.network(
                "http://$ipconfig/apisocial/registered_img/${location['image_01']}",
                height: 40, 
                fit: BoxFit.cover,
              ),
            ),
            
            // Title with green background below the image
            ClipRRect(
              borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
              ), //
              child: Container(
                
                color: Colors.green, 
                padding: EdgeInsets.all(4.0),
                child: Text(
                  location['storeName'], 
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8, 
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
            
          ),
        ),
      );
    },
  ),
),


 SizedBox(height: 15,),

         Container(
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
                      Text('Stores With Top Likes', style: TextStyle(fontWeight: FontWeight.w700),),
                    ],
                  ),
                 ),


 SizedBox(height: 10,),

  
  Container(
  padding: EdgeInsets.only(left: 10, right: 10),
  width: MediaQuery.of(context).size.width,
  height: 200, // Adjust the height as needed
  child: GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5, // Number of boxes in a row
        childAspectRatio: 1, // Adjust the aspect ratio as needed
        crossAxisSpacing: 1, // Space between boxes horizontally
        mainAxisSpacing: 1, // Space between boxes vertically
      ),
    physics: NeverScrollableScrollPhysics(),
    itemCount: userLocations.length,
    itemBuilder: (context, index) {
      var location = userLocations[index];
      return Container(
        width: 300, 
        child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => mobileTheStore(dataUrl: location['email']),
                ),
              );
            },
             child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Ensures full width
          children: [
            // Image at the top
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ), 
              child: Image.network(
                "http://$ipconfig/apisocial/registered_img/${location['image_01']}",
                height: 40, 
                fit: BoxFit.cover,
              ),
            ),
            
            // Title with green background below the image
            ClipRRect(
              borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
              ), //
              child: Container(
                
                color: Colors.green, 
                padding: EdgeInsets.all(4.0),
                child: Text(
                  location['storeName'], 
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8, 
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
            
          ),
        ),
      );
    },
  ),
),


        
        ],
      ),
    ));
  }
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
                    child: Text('Photo added successfully', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),),
                  )
                ],
              ),
            ),
        );
      },
    );
  }
