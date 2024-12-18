import 'package:flutter/material.dart';


GestureDetector StatesRow (Color color, String text, IconData icon, BuildContext context, Widget page){
  return GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => page));
            },
             child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                      color: color,
                     
                      borderRadius: BorderRadius.circular(5)
                    ),
               child: Row(
                 children: [
                   Container(
                   child: Text( text, style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500, fontSize: 15),)
                       ),
               
                    Icon(icon, color: Colors.white,)
                 ],
               ),
             ),
           );
}