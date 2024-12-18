// import 'package:flutter/material.dart';
// import 'package:mini/chatlist.dart';
// import 'package:mini/responsivity/desktopUserStore.dart';
// import 'package:mini/responsivity/mobileUserStore.dart';
// import 'package:mini/responsivity/responsiveUserStore.dart';
// import 'package:mini/responsivity/status.dart';


// class mobileHeader extends StatelessWidget {
//   const mobileHeader({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//          GestureDetector(
//     onTap: (){
//        Navigator.push(context, MaterialPageRoute(builder: (context) =>responsiveUserStore(mobileUserStore: mobileUserStore(), desktopUserStore: desktopUserStore())));
//     },
//     child: Column(
//       children: [
//         Icon(Icons.home),
//         Text('Home', style: TextStyle(fontWeight: FontWeight.w700),)
//       ],
//     ),
//   ),

//   SizedBox(width: 10,),


//   GestureDetector(
//     onTap: (){
//       Navigator.push(context, MaterialPageRoute(builder: (context) => UploadImageDemo()));
//     },
//     child: Column(
//       children: [
//         Icon(Icons.party_mode),
//         Text('Status', style: TextStyle(fontWeight: FontWeight.w700),)
//       ],
//     ),
//   ),
// SizedBox(width: 20,),

//   GestureDetector(
//     // onTap: (){
//     //   Navigator.push(context, MaterialPageRoute(builder: (context) => RecievedMessages()));
//     // },
//     child: Column(
//       children: [
//         Icon(Icons.forward_to_inbox),
//         Text('inbox', style: TextStyle(fontWeight: FontWeight.w700),)
//       ],
//     ),
//   ),

//   SizedBox(width: 10,),

//          GestureDetector(
//     onTap: (){
//       Navigator.push(context, MaterialPageRoute(builder: (context) =>responsiveUserStore(mobileUserStore: mobileUserStore(), desktopUserStore: desktopUserStore())));
//     },
//     child: Column(
//       children: [
//         Icon(Icons.store),
//         Text('Your store', style: TextStyle(fontWeight: FontWeight.w700),)
//       ],
//     ),
//   ),
//   SizedBox(width: 10,),

//    GestureDetector(
//     onTap: (){},
//     child: Column(
//       children: [
//         Icon(Icons.notifications_none_sharp),
//         Text('Notification', style: TextStyle(fontWeight: FontWeight.w700),)
//       ],
//     ),
//   ),
//       ],
//     );
//   }
// }