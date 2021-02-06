import 'package:cloud_firestore/cloud_firestore.dart';

class Orders {
  String docId;
  int totalPrice;
  String adress;
  GeoPoint orderLocationPoint;
  Orders({this.totalPrice, this.adress, this.docId,this.orderLocationPoint});
}
