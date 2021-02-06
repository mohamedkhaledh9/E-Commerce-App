import 'package:chatapp/constans.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViewOrderLocation extends StatefulWidget {
  static String id = "ViewOrderLocation";

  @override
  _ViewOrderLocationState createState() => _ViewOrderLocationState();
}

class _ViewOrderLocationState extends State<ViewOrderLocation> {
  GoogleMapController googleMapController;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Position userCurrentPosition;
  Geolocator geolocator = Geolocator();
  List<Marker> _markes = [];
  List<Polyline> _polyLines = [];

  getCurrentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      userCurrentPosition = position;
    });
    LatLng latLngCurrentPosition =
        LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngCurrentPosition, zoom: 15);
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var address =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = address.first;
    print("The address is : " +
        "${first.addressLine.replaceAll("Unnamed Road,", "")}");
  }

  getOrderLocation(GeoPoint oredrlocation) async {}

  @override
  Widget build(BuildContext context) {
    GeoPoint orderLocation = ModalRoute.of(context).settings.arguments;
    print(orderLocation.latitude);
    print(orderLocation.longitude);
    setState(() {
      _markes = [];
      _markes.add(
        Marker(
          position: LatLng(orderLocation.latitude, orderLocation.longitude),
          markerId: MarkerId(
            orderLocation.toString(),
          ),
        ),
      );
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Location"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .8,
              child: GoogleMap(
                polylines: Set.from(_polyLines),
                zoomGesturesEnabled: true,
                zoomControlsEnabled: true,
                markers: Set.from(_markes),
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                  target:
                      LatLng(orderLocation.latitude, orderLocation.longitude),
                  zoom: 10,
                ),
                onMapCreated: (GoogleMapController controller) {
                  googleMapController = controller;
                  getCurrentLocation();
                },
              ),
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  height: MediaQuery.of(context).size.height * .1,
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        _polyLines.add(
                          Polyline(
                            geodesic: true,
                            startCap: Cap.roundCap,
                            endCap: Cap.buttCap,
                            width: 3,
                            color: Colors.red,
                            polylineId: PolylineId('road'),
                            points: [
                              LatLng(userCurrentPosition.latitude,
                                  userCurrentPosition.longitude),
                              LatLng(orderLocation.latitude,
                                  orderLocation.longitude)
                            ],
                          ),
                        );
                      });
                    },
                    child: Text(
                      "View Order Road",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
