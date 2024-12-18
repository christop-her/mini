import 'package:flutter/material.dart';

class responsiveRegisterStore extends StatelessWidget {
   final Widget mobileRegisterStore;
   final Widget desktopRegisterStore;

  const responsiveRegisterStore({super.key, required this.mobileRegisterStore, required this.desktopRegisterStore});
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints){
      if(constraints.maxWidth < 700){
             return mobileRegisterStore;
      }else{
               return desktopRegisterStore;
      }
    });
  }
}