import 'package:flutter/material.dart';
import 'package:mini/statesRow.dart';

class firstPage extends StatefulWidget {
  const firstPage({super.key});

  @override
  State<firstPage> createState() => _firstPageState();
}

class _firstPageState extends State<firstPage> {
  @override
  Widget build(BuildContext context) {

    final currentWidth = MediaQuery.of(context).size.width;

    return SafeArea(child: SingleChildScrollView(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: [
          Container(
          //  color: Color.fromARGB(255, 31, 30, 30),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: 
                  Container(
            
              //  color: Color(0x5F141414),

               child: Padding(
                 padding: currentWidth < 1200 ?  EdgeInsets.only(left: 0) : EdgeInsets.only(left: 50),
                 child: Column( 
                  children: [
                    GestureDetector(
                     onTap: (){},
                     child: Row(
                       children: [
                         Icon(Icons.business, color: Colors.black87,),
                         Text('Check favourite store', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),)
                       ],
                     ),
                   ),
                 SizedBox(height: 20,),
                    GestureDetector(
                     onTap: (){},
                     child: Row(
                       children: [
                         Icon(Icons.account_box, color: Colors.black87,),
                         Text('Check Account', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),)
                       ],
                     ),
                   ),
                         SizedBox(height: 20,),

                          GestureDetector(
                     onTap: (){},
                     child: Row(
                       children: [
                         Icon(Icons.book, color: Colors.black87,),
                         Text('Your saved item(s)', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),)
                       ],
                     ),
                   ),    
           
            SizedBox(height: 20,),

                    GestureDetector(
                     onTap: (){},
                     child: Row(
                       children: [
                         Icon(Icons.book, color: Colors.black87,),
                         Text('Your saved item(s)', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),)
                       ],
                     ),
                   ),    
 SizedBox(height: 20,),
                    GestureDetector(
                     onTap: (){},
                     child: Row(
                       children: [
                         Icon(Icons.book, color: Colors.black87,),
                         Text('Your saved item(s)', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),)
                       ],
                     ),
                   ),    
                   
                     ],
                 ),
               ),
                )),
                 SizedBox(width: 40,),
                Expanded(
                  flex: 5,
                  child: 
                  Container(
                    height: 250,
                    child: Image(image: AssetImage('images/sperf.JPG'),
                     fit: BoxFit.cover,),
              
               
                )),
       currentWidth < 1050 ?  SizedBox(
                  width: 10,) :
                 SizedBox(
                  width: 40,),
            currentWidth < 800 ? Container() :      
                Expanded(
                  flex: 2,
                  child: 
                  Container(
child: Column(
  children: [
     GestureDetector(
                    
                     onTap: (){},
                     child: Row(
                       children: [
                         Icon(Icons.house, color: Colors.black87,),
                         Text('register your store', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),)
                       ],
                     ),
                   ),    
 SizedBox(height: 20,),
                    GestureDetector(
                     onTap: (){},
                     child: Row(
                       children: [
                         Icon(Icons.business_center, color: Colors.black87,),
                         Text('update yor shop', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),)
                       ],
                     ),
                   ),    
                   
  ],
),
              
                )),
              ],
            ),
          ),
   SizedBox(height: 15,),
          stateRow(),
        ],
      ),
    ));
  }
}