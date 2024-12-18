// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:location/location.dart' as loc;
// import 'package:permission_handler/permission_handler.dart';

// class Check extends StatefulWidget {
//   const Check({super.key});

//   @override
//   State<Check> createState() => _CheckState();
// }




// class _CheckState extends State<Check> {
//   bool isloading = false;
//   loc.LocationData? locationData;
//   List<Placemark>? placemark;

// void getPermission () async {
//   if(await Permission.location.isGranted){

// getLocation();
//   }else{
//     Permission.location.request();
//   }
// }

//   void getLocation() async{
//     setState(() {
//       isloading = true;
//     });
// locationData = await loc.Location.instance.getLocation();
// setState(() {
//   isloading= false;
// });
// }

// void getAddress()async {
//   if(locationData != null){
//     setState(() {
//       isloading = true;
//     });
// placemark = await placemarkFromCoordinates(locationData!.latitude!, locationData!.longitude!);
// setState(() {
//   isloading = false;
// });
//   }
// }
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(child: SingleChildScrollView(
//       child: Column(
//         children: [
//        isloading? Center(child: CircularProgressIndicator(),):
//       Text(locationData != null ? "lattitude : ${locationData!.latitude}" : "lattitude : not available"),

//       isloading? Center(child: CircularProgressIndicator(),):
//       Text(locationData != null ? "longitude : ${locationData!.longitude}" : "longitude : not available"),

//       ElevatedButton(onPressed: (){getPermission();}, child: Text('get location')),
//       SizedBox(height: 80,),
//       Text(placemark != null ? "address : ${placemark![0].street} ${placemark![0].locality} ${placemark![0].subLocality} ${placemark![0].country}": "address : not available" ),

//     ElevatedButton(onPressed: (){getAddress();}, child: Text('get address'))
       
       
//         ],
//       ),
//     ));
//   }
// }



import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

class Check extends StatefulWidget {
  const Check({Key? key}) : super(key: key);

  @override
  State<Check> createState() => _CheckState();
}

class _CheckState extends State<Check> {
  bool isLoading = false;
  String address = 'Address: Not available';

  Future<void> getAddress() async {
    setState(() {
      isLoading = true;
    });
    try {
      loc.LocationData locationData = await loc.Location.instance.getLocation();
      List<Placemark> placemarks = await placemarkFromCoordinates(
          locationData.latitude!, locationData.longitude!);
      Placemark placemark = placemarks.first;
      String formattedAddress = '${placemark.subLocality}';
      setState(() {
        address = 'Address: $formattedAddress';
      });
    } catch (e) {
      print('Error getting address: $e');
      setState(() {
        address = 'Address: Not available';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getPermission() async {
    var permissionStatus = await Permission.location.request();
    if (permissionStatus.isGranted) {
      getAddress();
    } else {
      print('Location permission not granted');
      // Handle case where permission is not granted
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLoading ? CircularProgressIndicator() : Text(address),
              ElevatedButton(
                onPressed: () {
                  getPermission();
                },
                child: Text('Get Address'),
              ),
            ],
          ),
        ),
    );
  }
}
