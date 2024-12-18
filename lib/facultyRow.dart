import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mini/ImageComment.dart';
import 'package:mini/home.dart';
import 'package:mini/login.dart';
import 'package:mini/reusesableAppbar.dart';
import 'package:http/http.dart' as http;
import 'package:mini/ipconfig.dart';



class facultyCategory extends StatefulWidget {
  const facultyCategory({super.key});

  @override
  State<facultyCategory> createState() => _facultyCategoryState();
}

class _facultyCategoryState extends State<facultyCategory> {

 
 String userName = '';
 String email = '';
 
Future getEmail() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  setState(() {
    email = preferences.getString('email') ?? '';
  });

}

Future<void> userEmail() async{
     var url = "http://$ipconfig/practice/userData.php";
    var response = await http.post(Uri.parse(url),
    body: {
        'email': email
    }
    );
   if(response.statusCode == 200){
    var jsonResponse = json.decode(response.body);
    if(jsonResponse['success'] == 'login successful'){
    // String userName = jsonResponse['name'];
    var userData = jsonResponse['data'][0];
    setState(() {
       userName = userData['name'];
    }); // Access the first element of the 'data' array
    
    print('User name: $userName');
    }else{
    print('not successful');
   }
   }else{
    print('request failed with status: ${response.statusCode}');
   }
  }

  

  @override
  void initState(){
    super.initState();
    getEmail().then((_) => userEmail());
    
  }
  
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
         body:  Container(
 child: SingleChildScrollView(
  padding: EdgeInsets.all(10),
  scrollDirection: Axis.vertical,
  child: Column(
    children: [

      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
    
              children: [
      // Center(child: email == '' ? Text('') : Text(email),),
      // Text(userName),
      
   GestureDetector(
                  onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) =>login()));
          },
          
            child:  
   Container(
         
   width: 90,
   height: 110,
  child: FutureBuilder(
    future: AllPerson(),
    builder: (context, snapshot) {
      if (snapshot.hasError) print(snapshot.error);
      return snapshot.hasData
          ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
              itemCount: 1,
              itemBuilder: ((context, index) {
                List list = snapshot.data;
                return Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 90,
                          height: 90,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            // child: Image.network(
                            //   "http://192.168.132.26/practice/faculty_img/${list[index]['eng_image']}",
                            //   fit: BoxFit.cover, // Ensure the image covers the entire space
                            // ),
                             child: Image(image: AssetImage('images/sperf.JPG'),
                      fit: BoxFit.cover),
                          ),
                        ),
                      ],
                    ),
                    // 
                      Text(list[index]['eng'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, ),)
                  ],

                );
              }))
          : Center(child: CircularProgressIndicator());
    }),
),
          ),
            
                SizedBox(width: 12,),

                
        
        GestureDetector(
                  onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          
            child:  
   Container(
         
   width: 90,
   height: 110,
  child: FutureBuilder(
    future: AllPerson(),
    builder: (context, snapshot) {
      if (snapshot.hasError) print(snapshot.error);
      return snapshot.hasData
          ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
              itemCount: 1,
              itemBuilder: ((context, index) {
                List list = snapshot.data;
                return Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 90,
                          height: 90,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            // child: Image.network(
                            //   "http://192.168.132.26/practice/faculty_img/${list[index]['edu_image']}",
                            //   fit: BoxFit.cover, // Ensure the image covers the entire space
                            // ),
                            child: Image(image: AssetImage('images/sperf.JPG'),
                      fit: BoxFit.cover),
                          ),
                        ),
                      ],
                    ),
                    
                      Text(list[index]['edu'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, ),)
                  ],

                );
              }))
          : Center(child: CircularProgressIndicator());
    }),
),
          ),

           SizedBox(width: 12,),

          GestureDetector(
                  onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          
            child:  
   Container(
         
   width: 90,
   height: 110,
  child: FutureBuilder(
    future: AllPerson(),
    builder: (context, snapshot) {
      if (snapshot.hasError) print(snapshot.error);
      return snapshot.hasData
          ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
              itemCount: 1,
              itemBuilder: ((context, index) {
                List list = snapshot.data;
                return Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 90,
                          height: 90,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            // child: Image.network(
                            //   "http://192.168.132.26/practice/faculty_img/${list[index]['law_image']}",
                            //   fit: BoxFit.cover, // Ensure the image covers the entire space
                            // ),
                             child: Image(image: AssetImage('images/sperf.JPG'),
                      fit: BoxFit.cover),
                          ),
                        ),
                      ],
                    ),
                    // 
                      Text(list[index]['law'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, ),)
                  ],

                );
              }))
          : Center(child: CircularProgressIndicator());
    }),
),
          ),

 SizedBox(width: 12,),

          GestureDetector(
                  onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          
            child:  
   Container(
         
   width: 90,
   height: 110,
  child: FutureBuilder(
    future: AllPerson(),
    builder: (context, snapshot) {
      if (snapshot.hasError) print(snapshot.error);
      return snapshot.hasData
          ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
              itemCount: 1,
              itemBuilder: ((context, index) {
                List list = snapshot.data;
                return Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 90,
                          height: 90,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            // child: Image.network(
                            //   "http://192.168.132.26/practice/faculty_img/${list[index]['art_image']}",
                            //   fit: BoxFit.cover, // Ensure the image covers the entire space
                            // ),
                             child: Image(image: AssetImage('images/sperf.JPG'),
                      fit: BoxFit.cover),
                          ),
                        ),
                      ],
                    ),
                    // 
                      Text(list[index]['art'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, ),)
                  ],

                );
              }))
          : Center(child: CircularProgressIndicator());
    }),
),
          ),

           SizedBox(width: 12,),

          GestureDetector(
                  onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          
            child:  
   Container(
         
   width: 90,
   height: 110,
  child: FutureBuilder(
    future: AllPerson(),
    builder: (context, snapshot) {
      if (snapshot.hasError) print(snapshot.error);
      return snapshot.hasData
          ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
              itemCount: 1,
              itemBuilder: ((context, index) {
                List list = snapshot.data;
                return Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 90,
                          height: 90,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            // child: Image.network(
                            //   "http://192.168.132.26/practice/faculty_img/${list[index]['eng_image']}",
                            //   fit: BoxFit.cover, // Ensure the image covers the entire space
                            // ),
                           child: Image(image: AssetImage('images/sperf.JPG'),
                           fit: BoxFit.cover),
                          ),
                        ),
                      ],
                    ),
                    // 
                      Text(list[index]['eng'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, ),)
                  ],

                );
              }))
          : Center(child: CircularProgressIndicator());
    }),
),
          ),
          ]
        )
        ),


      SizedBox(
        height: 15,
      ),

            Container(
         
  width: MediaQuery.of(context).size.width,
   height: 1200,
  child: FutureBuilder(
    future: AllPerson(),
    builder: (context, snapshot) {
      if (snapshot.hasError) print(snapshot.error);
      return snapshot.hasData
          ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data.length,
              itemBuilder: ((context, index) {
                List list = snapshot.data;
                return Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                     
                    children: [

             
                         Row(
                      
                        children: [
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              // child: Image.network(
                              //   "http://192.168.132.26/practice/uploaded_img/${list[index]['postpic']}",
                              //   fit: BoxFit.cover, // Ensure the image covers the entire space
                              // ),
                               child: Image(image: AssetImage('images/sperf.JPG'),
                      fit: BoxFit.cover),
                            ),
                          ),
                          SizedBox(width: 10), // Adjust the spacing as needed
                          Text(list[index]['name'],style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),),
                        ],
                      ),
                  
                      
                      SizedBox(height: 10,),
                  
                      Container(
                       child:  Text(list[index]['caption'],style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.w400),),
                      ),
                  
                      SizedBox(height: 10,),
                  

                           GestureDetector(
                        onTap:() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ImageComment(imageUrl: "http://192.168.132.26/practice/uploaded_img/${list[index]['cap_image']}")),
    );
  },
              child: Container(
                      //  child: Image.network(
                      //           "http://192.168.132.26/practice/uploaded_img/${list[index]['cap_image']}",
                      //           fit: BoxFit.cover, // Ensure the image covers the entire space
                      //         ),
                      child: Image(image: AssetImage('images/sperf.JPG'),
                      fit: BoxFit.cover),
                      )
                           ),
                           
                           GestureDetector(
                            onTap: (){
                               Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImageComment(imageUrl: "http://192.168.132.26/practice/uploaded_img/${list[index]['cap_image']}")),
    );
                            },
                            child: Icon(Icons.comment, size: 30,),
                           )
                    ],
                  ),
                );
              }))
          : Center(child: CircularProgressIndicator());
    }),
),
            
           
    ],
  ),
 ),
  ),

         
      ),
    );
  }
}

