import 'dart:convert';
import 'package:mini/ipconfig.dart';
import 'package:mini/responsivity/locationchecker.dart';
import 'package:mini/responsivity/nearby.dart';
import 'package:mini/responsivity/nearbyhome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mini/stores.dart';

class firstPage_2 extends StatefulWidget {
  const firstPage_2({super.key});

  @override
  State<firstPage_2> createState() => _firstPage_2State();
}

class _firstPage_2State extends State<firstPage_2> {

  List<dynamic> userLocations = [];
  var userData;
  String addressName = '';
  String addressid = '';
  String email = '';
  bool isLoading = true;
  
// LocationProximityChecker proximityChecker = LocationProximityChecker();

  Future<void> closeLocation() async {

    // proximityChecker.startListening();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString('email') ?? '';
    });
    setState(() {
      isLoading = true;
    });

    var url = "http://$ipconfig/apisocial/userData.php";
    var myUrl = "http://$ipconfig/apisocial/nearby.php";
    var response = await http.post(Uri.parse(url), body: {'email': email});

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['success'] == 'login successful') {
        setState(() {
          userData = jsonResponse['data'][0];
          addressName = userData['address_locality'];
          addressid = userData['id'].toString();
        });

        var output = await http.post(Uri.parse(myUrl), body: {
          'address': addressName,
          'addressid': addressid.toString(),
        });
        var jsonOutput = json.decode(output.body);
        setState(() {
          userLocations = jsonOutput;
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    closeLocation();
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
     body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF010043)),
              ),
            )
          :  SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 50),
          _buildTopIcons(),
          const SizedBox(height: 20),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _buildSlider(),
                ),
                Positioned(
                  top: 150, // Adjust this value to control overlap
                  left: 0,
                  right: 0,
                  child: _buildShopListings(),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildTopIcons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "RandomName",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF010043),
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.search, color: Color(0xFF010043)),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.notifications, color:  Color(0xFF010043)),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSlider() {
    return Container(
      height: 180,
      color: Colors.grey[300],
      child: PageView(
        children: [
          // Image.network(
          //   "http://$ipconfig/apisocial/registered_img/${userLocations[0]['image_01']}",
          //   fit: BoxFit.cover,
          // ),
          Image.network(
            "https://via.placeholder.com/800x400?text=Slide+1",
            fit: BoxFit.cover,
          ),
          Image.network(
            "https://via.placeholder.com/800x400?text=Slide+3",
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCategoryCard("Nearby", const Nearby()),
              _buildCategoryCard("Homeaddress", const NearbyHome()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, Widget navigation) {
    return Expanded(
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => navigation));
        },
        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Row(
              children: [
                Icon(Icons.build_circle_sharp), 
                SizedBox(width: 2,),
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
        _buildCategories(),
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
            child: userLocations.isEmpty ? Container() : GridView.builder(
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
