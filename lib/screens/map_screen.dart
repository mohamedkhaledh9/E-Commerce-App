import 'dart:ui';

import 'package:chatapp/constans.dart';
import 'package:chatapp/models/product_data.dart';
import 'package:chatapp/services/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatefulWidget {
  static String id = "GoogleMapScreen";

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  List<Marker> _markers = [];
  double lat = 0.0;
  double long = 0.0;
  GoogleMapController googleMapController;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Position userCurrentPosition;
  Geolocator geolocator = Geolocator();
  TextEditingController _orderAddress = TextEditingController();

  getTotalPrice(List<Product> products) {
    var price = 0;
    for (var product in products) {
      price += int.parse(product.pPrice) * product.pQuantity;
    }
    return price;
  }

  void setMarkLocations(LatLng latLng) async {
    final coordinates = Coordinates(latLng.latitude, latLng.longitude);
    var address =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var addressLine = address.first;

    print(latLng.latitude);
    print(latLng.longitude);
    setState(() {
      _markers = [];
      _markers.add(
        Marker(
          markerId: MarkerId(
            latLng.toString(),
          ),
          position: latLng,
        ),
      );
      lat = latLng.latitude;
      long = latLng.longitude;
      _orderAddress.text = addressLine.addressLine.replaceAll("Unnamed Road,", "");
    });
  }

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
    setState(() {
      _orderAddress.text = first.addressLine.replaceAll("Unnamed Road,", "");
      lat=position.latitude;
      long=position.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Product> _products = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Order Location"),
      ),
      key: scaffoldKey,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        // child: Center(child: Text("hello from google map screen "),),
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .7,
              child: GoogleMap(
                onTap: setMarkLocations,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                initialCameraPosition:
                    CameraPosition(target: LatLng(30.033333, 31.233334)),
                onMapCreated: (GoogleMapController controller) {
                  googleMapController = controller;
                  getCurrentLocation();
                },
                markers: Set.from(_markers),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                  color: Colors.blue,
                ),
                height: MediaQuery.of(context).size.height * .2,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextField(
                                readOnly: true,
                                controller: _orderAddress,
                                decoration: InputDecoration(
                                  fillColor: Colors.white70,
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: "Total\:\n"),
                                TextSpan(
                                  text:
                                      "${"\t" + getTotalPrice(_products).toString() + "\$"}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 10, left: 10),
                              child: Builder(
                                builder: (context) => GestureDetector(
                                  onTap: () async{
                                    Store _store = Store();
                                    try {
                                      _store.orders({
                                        kTotalPrice: getTotalPrice(_products),
                                        kAddress: _orderAddress.text,
                                       kOrderLocationPoint:await GeoPoint(lat,long),
                                      }, _products);
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Order Confirmed"),
                                        ),
                                      );
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: kMainColor),
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        "Confirm Order",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
