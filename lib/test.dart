// import 'package:flutter/material.dart';
// import 'package:social/ImageComment.dart';
// import 'package:social/home.dart';
// import 'package:social/reusesableAppbar.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class test extends StatefulWidget {
//   const test({super.key});

//   @override
//   State<test> createState() => _testState();
// }

// class _testState extends State<test> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: 

//         Container(
         
//    width: 90,
//    height: 110,
//   child: FutureBuilder(
//     future: AllPerson(),
//     builder: (context, snapshot) {
//       if (snapshot.hasError) print(snapshot.error);
//       return snapshot.hasData
//           ? ListView.builder(
//             physics: NeverScrollableScrollPhysics(),
//               itemCount: 1,
//               itemBuilder: ((context, index) {
//                 List list = snapshot.data;
//                 return Column(
//                   children: [
//                     Row(
//                       children: [
//                         SizedBox(
//                           width: 10,
//                           height: 10,
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             // child: Image.network(
//                             //   "http://192.168.132.26/practice/faculty_img/${list[index]['eng_image']}",
//                             //   fit: BoxFit.cover, // Ensure the image covers the entire space
//                             // ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     // 
//                       Text(list[index]['faculty'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, ),)
                      
//                   ],

//                 );
//               }))
//           : Center(child: CircularProgressIndicator());
//     }),
// ),
//       ),
//     );
//   }
// }