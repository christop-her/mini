import 'package:flutter/material.dart';

class responsiveUserStore extends StatelessWidget {
   final Widget mobileUserStore;
   final Widget desktopUserStore;

  const responsiveUserStore({super.key, required this.mobileUserStore, required this.desktopUserStore});
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints){
      if(constraints.maxWidth < 700){
             return mobileUserStore;
      }else{
               return desktopUserStore;
      }
    });
  }
}