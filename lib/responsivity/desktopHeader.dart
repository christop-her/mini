// import 'package:flutter/material.dart';
// import 'package:mini/responsivity/desktopUserStore.dart';
// import 'package:mini/responsivity/mobileUserStore.dart';
// import 'package:mini/responsivity/responsiveUserStore.dart';
// import 'package:mini/stores.dart';
// import 'package:mini/user_store.dart';

// class desktopHeader extends StatelessWidget {
//   const desktopHeader({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [

//   Container(
//     child: Row(
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

//    GestureDetector(
//     onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => mobileTheStore(dataUrl: 'prosper')));},
//     child: Column(
//       children: [
//         Icon(Icons.inbox),
//         Text('Inbox', style: TextStyle(fontWeight: FontWeight.w700),)
//       ],
//     ),
//   ),

//   SizedBox(width: 10,),


//    GestureDetector(
//     onTap: (){},
//     child:Column(
//       children: [
//         Icon(Icons.message),
//         Text('Messages', style: TextStyle(fontWeight: FontWeight.w700),)
//       ],
//     ),
//   ),
//       ],
//     ),
//   ),
// SizedBox(width: 20,),
//   Expanded(child: 
//    Container(
//     width: 20,
//     height: 40,
//                   decoration: BoxDecoration(
                  
//                    border: Border.all(
//                     color: Colors.black,
//                     width: 1
//                    ),
//                  borderRadius: BorderRadius.circular(50)
//                   ),
//                   child: TextField(
                    
//                     decoration: InputDecoration(
//                      suffixIcon: IconButton(onPressed: (){}, icon: Icon(Icons.search)),
//                     // hintText: 'search',
                    
//                       border: InputBorder.none
//                     ),
                    
//                   ),
//    )
//                 ),
        
//                 SizedBox(width: 20,),

//     Container(
//     child: Row(
//       children: [

//    GestureDetector(
//     onTap: (){},
//     child: Column(
//       children: [
//         Icon(Icons.shopping_cart),
//         Text('Cart', style: TextStyle(fontWeight: FontWeight.w700),)
//       ],
//     ),
//   ),

//   SizedBox(width: 10,),

//          GestureDetector(
//     onTap: (){},
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
//         Icon(Icons.account_box),
//         Text('Account', style: TextStyle(fontWeight: FontWeight.w700),)
//       ],
//     ),
//   ),

//   SizedBox(width: 10,),


//    GestureDetector(
//     onTap: (){},
//     child: Column(
//       children: [
//         Icon(Icons.contacts),
//         Text('contact', style: TextStyle(fontWeight: FontWeight.w700),)
//       ],
//     ),
//   ),
//       ],
//     ),
//   ),
      
  
// ],

//   );
//   }
// }