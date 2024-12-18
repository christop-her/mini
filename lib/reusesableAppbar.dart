// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:mini/home.dart';
import 'package:mini/ImageComment.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mini/login.dart';
import 'package:mini/ipconfig.dart';




Future AllPerson () async{
  var url = "http://$ipconfig/practice/alldata.php";
  var response = await http.get(Uri.parse(url));
  return json.decode(response.body);
} 


 FirstBar(context){
  return Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
   Container(
    decoration: BoxDecoration(  
    ),
    child: Text('SOCIAL',style: TextStyle(fontSize: 30,fontWeight: FontWeight.w700, color: Colors.lightGreen),)
    ),

 Container(
      
      child: Row(

      children: [

       Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.grey[300],
         borderRadius: BorderRadius.circular(10)
        ),
        child: IconButton(onPressed: (){
           Scaffold.of(context).openDrawer();
        }, icon: Icon(Icons.menu, size: 25,),
         color: Colors.black87,),
      ),
       Container(
        decoration: BoxDecoration(
         color: Colors.grey[300],
         borderRadius: BorderRadius.circular(10)
        ),
        child: IconButton(onPressed: (){}, icon: Icon(Icons.search, size: 25,),
         color: Colors.black87,),
      ),

      ],
    )
    ),  
],

  );
}

Container myBody (context){
  return Container(
 child: SingleChildScrollView(
  padding: EdgeInsets.all(10),
  scrollDirection: Axis.vertical,
  child: Column(
    children: [

      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
    
              children: [
  

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
                            child: Image.network(
                              "http://192.168.132.26/practice/faculty_img/${list[index]['eng_image']}",
                              fit: BoxFit.cover, // Ensure the image covers the entire space
                            ),
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
                            child: Image.network(
                              "http://192.168.132.26/practice/faculty_img/${list[index]['edu_image']}",
                              fit: BoxFit.cover, // Ensure the image covers the entire space
                            ),
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
                            child: Image.network(
                              "http://192.168.132.26/practice/faculty_img/${list[index]['law_image']}",
                              fit: BoxFit.cover, // Ensure the image covers the entire space
                            ),
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
                            child: Image.network(
                              "http://192.168.132.26/practice/faculty_img/${list[index]['art_image']}",
                              fit: BoxFit.cover, // Ensure the image covers the entire space
                            ),
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
                            child: Image.network(
                              "http://192.168.132.26/practice/faculty_img/${list[index]['eng_image']}",
                              fit: BoxFit.cover, // Ensure the image covers the entire space
                            ),
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
                              child: Image.network(
                                "http://192.168.132.26/practice/uploaded_img/${list[index]['postpic']}",
                                fit: BoxFit.cover, // Ensure the image covers the entire space
                              ),
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
                       child: Image.network(
                                "http://192.168.132.26/practice/uploaded_img/${list[index]['cap_image']}",
                                fit: BoxFit.cover, // Ensure the image covers the entire space
                              ),
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
  );
}






Row SecondAppBar(context){
  return Row(
    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [

  Container(
    child: Row(
      children: [
         GestureDetector(
    onTap: (){
       Navigator.push(context, MaterialPageRoute(builder: (context) =>login()));
    },
    child: Row(
      children: [
        Icon(Icons.home),
        Text('Home', style: TextStyle(fontWeight: FontWeight.w300),)
      ],
    ),
  ),
  SizedBox(width: 10,),

   GestureDetector(
    onTap: (){},
    child: Row(
      children: [
        Icon(Icons.inbox),
        Text('Inbox', style: TextStyle(fontWeight: FontWeight.w300),)
      ],
    ),
  ),

  SizedBox(width: 10,),


   GestureDetector(
    onTap: (){},
    child: Row(
      children: [
        Icon(Icons.message),
        Text('Messages', style: TextStyle(fontWeight: FontWeight.w300),)
      ],
    ),
  ),
      ],
    ),
  ),
Spacer(),
  Expanded(child: 
   Container(
    width: 20,
    height: 40,
                  decoration: BoxDecoration(
                  
                   border: Border.all(
                    color: Colors.black,
                    width: 1
                   ),
                 borderRadius: BorderRadius.circular(50)
                  ),
                  child: TextField(
                    
                    decoration: InputDecoration(
                     suffixIcon: IconButton(onPressed: (){}, icon: Icon(Icons.search)),
                    // hintText: 'search',
                    
                      border: InputBorder.none
                    ),
                    
                  ),
   )
                ),
        
                Spacer(),

    Container(
    child: Row(
      children: [

   GestureDetector(
    onTap: (){},
    child: Row(
      children: [
        Icon(Icons.shopping_cart),
        Text('Cart', style: TextStyle(fontWeight: FontWeight.w300),)
      ],
    ),
  ),

  SizedBox(width: 10,),

         GestureDetector(
    onTap: (){},
    child: Row(
      children: [
        Icon(Icons.store),
        Text('Your store', style: TextStyle(fontWeight: FontWeight.w300),)
      ],
    ),
  ),
  SizedBox(width: 10,),

   GestureDetector(
    onTap: (){},
    child: Row(
      children: [
        Icon(Icons.account_box),
        Text('Account', style: TextStyle(fontWeight: FontWeight.w300),)
      ],
    ),
  ),

  SizedBox(width: 10,),


   GestureDetector(
    onTap: (){},
    child: Row(
      children: [
        Icon(Icons.contacts),
        Text('contact', style: TextStyle(fontWeight: FontWeight.w300),)
      ],
    ),
  ),
      ],
    ),
  ),
      
  
],

  );
}

Container commentIcon(){
  return Container(
     child: IconButton(onPressed: (){}, 
     icon: Icon(Icons.comment),
     )
  );
}



