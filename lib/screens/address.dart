import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:share_plus/share_plus.dart';
class Google_map extends StatefulWidget {
  @override
  State<Google_map> createState() => _Google_mapState();
}

class _Google_mapState extends State<Google_map> {
  @override
  Set<Marker> mylist = {};

  var n1=TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share(" share my location ");
              String x=n1.text.toString();
              Share.share(x);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 600,
            child: GoogleMap(
              onMapCreated: (controller) {},
              initialCameraPosition: CameraPosition(
                  target: LatLng(30.1, 30.2),
                  zoom: 10.0
              ),
              markers: mylist,
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.blueGrey,
            child: MaterialButton(onPressed: () async {
              Location myloc = new Location();
              LocationData x = await myloc.getLocation();
              dynamic a = x.latitude;
              dynamic b = x.longitude;
              setState(() {
                mylist.add(
                    Marker(
                      markerId: MarkerId("Graduation Team"),
                      position: LatLng(a, b),
                      infoWindow: InfoWindow(snippet: "Shop Ecommerce", title: "Graduation Team"),
                    )
                );
              });
            },child: Text('find my location',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),),),
          ),
        ],
      ),
    );
  }
}