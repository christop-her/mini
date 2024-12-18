import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter/material.dart';
import 'package:mini/firstPage.dart';
import 'package:mini/ipconfig.dart';
import 'package:mini/responsivity/mobileFirstPage.dart';
import 'package:mini/responsivity/navbar.dart';
import 'package:mini/stores.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NearbyHome extends StatefulWidget {
  const NearbyHome({super.key});

  @override
  State<NearbyHome> createState() => _NearbyHomeState();
}

class _NearbyHomeState extends State<NearbyHome> {
  List<dynamic> userLocations = [];
  var userData;
  String addressName = '';
  String addressid = '';
  String email = '';
  bool isLoading = true;

  String address = 'Not available';
  double latitude = 0.0;
  double longitude = 0.0;



Future<void> _getAddress() async {
    // Request location permission
    var permissionStatus = await Permission.location.request();
    if (permissionStatus.isGranted) {
      try {
        loc.LocationData locationData = await loc.Location.instance.getLocation();
        List<Placemark> placemarks = await placemarkFromCoordinates(
          locationData.latitude!,
          locationData.longitude!,
        );
        Placemark placemark = placemarks.first;
        String formattedAddress = '${placemark.locality}';
        
        setState(() {
          address = formattedAddress;
          latitude = locationData.latitude!;
          longitude = locationData.longitude!;
          
        });
      } catch (e) {
        print('Error getting location: $e');
      }
    } else {
      print('Location permission not granted');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NavBar()));
    }
  }
  
  Future<void> closeLocation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString('email') ?? '';
    });

    await _getAddress();

    setState(() {
      isLoading = true;
    });

    var myUrl = "http://$ipconfig/apisocial/nearbyhome.php";
  
        var output = await http.post(Uri.parse(myUrl), body: {
          'address': address,
          'lattitude': latitude.toString(),
          'longitude': longitude.toString(),

        });
        print(latitude.toString());
         print(longitude.toString());
        var jsonOutput = json.decode(output.body);
        print(jsonOutput);
        setState(() {
          userLocations = jsonOutput;
        });
    setState(() {
      isLoading = false;
    });
    print(userLocations);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF010043)),
              ),
            )
          :userLocations.isEmpty
                ? 
                Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
  child: Center(
    child: Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 60,
              color: Colors.blue.shade900, 
            ),
            SizedBox(height: 12),
            Text(
              'No business here yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF5F5F5),  // Light text color for contrast
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We are currently working on that. Please check back later!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFB0BEC5),  // Muted text color to complement the background
              ),
            ),
          ],
        ),
      ),
    ),
  ),
)
:SingleChildScrollView(
        child: Column(
children: [
  _buildShopListings()
],
        ),
      ),
    );
  }

@override
void initState() {
    super.initState();
    closeLocation();
  }

  Widget _buildShopListings() {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Add categories at the top of the shop list section
        // _buildCategories(),
        const SizedBox(height: 10), 
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Icon(Icons.business_center),
              SizedBox(width: 10,),
              Text('Nearby Business'),
            ],
          ),
        ),
         Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Divider(),
          
        ),

        // Shop listings as a GridView
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height, // Set an appropriate height for the GridView
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 4 items per row
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                childAspectRatio: 3 / 4, // Adjust the height-to-width ratio
              ),
              physics: NeverScrollableScrollPhysics(),
              itemCount: userLocations.length,
              itemBuilder: (context, index) {
                var store = userLocations[index];
                return GestureDetector(
                  onTap: (){
                    Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => mobileTheStore(dataUrl: store['email']),
                ),
              );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        // Display the image without padding
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                          child: Image.network(
                            'http://$ipconfig/apisocial/registered_img/${store['image_01']}',
                            height: 68,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${store['storeName']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 8,
                                ),
                              ),
                              Text(
                                '${store['address']}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    ),
  );
}

}