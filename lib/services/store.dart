import 'package:chatapp/constans.dart';
import 'package:chatapp/models/product_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Store {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  addProduct(Product product) {
    _fireStore.collection(kProductCollection).add({
      kProductName: product.pName,
      kProductPrice: product.pPrice,
      kProductDescription: product.pDescription,
      kProductCategory: product.pCategory,
      kProductLocation: product.pLocation,
      kIsFavorite: product.isFavorite,
    });
  }

  Stream<QuerySnapshot> loadProduct() {
    return _fireStore.collection(kProductCollection).snapshots();
  }

  Stream<QuerySnapshot> loadOrders() {
    return _fireStore.collection(kOrders).snapshots();
  }

  Stream<QuerySnapshot> loadDetails(docId) {
    return _fireStore
        .collection(kOrders)
        .doc(docId)
        .collection(kOrderDetails)
        .snapshots();
  }

  deleteProduct(productId) {
    _fireStore.collection(kProductCollection).doc(productId).delete();
  }

  deletOrder(orderId) {
    _fireStore
        .collection("orders")
        .doc(orderId)
        .collection("orderDetails")
        .get()
        .then((value) {
      for (QueryDocumentSnapshot snapshot in value.docs) {
        snapshot.reference.delete();
      }
    });
    var orderDetails = _fireStore.collection("orders").doc(orderId);
    var removeDetails = orderDetails.update({
      "UserAdress": FieldValue.delete(),
      "totalPrice": FieldValue.delete(),
    });
  }

  editProduct(data, productId) {
    _fireStore.collection(kProductCollection).doc(productId).update(data);
  }

  orders(data, List<Product> products) {
    var dataReference = _fireStore.collection(kOrders).doc();
    dataReference.set(data);
    for (var product in products) {
      dataReference.collection(kOrderDetails).doc().set({
        kProductName: product.pName,
        kProductPrice: product.pPrice,
        kProductLocation: product.pLocation,
        kProductQuantity: product.pQuantity,
      });
    }
  }

  updateFavoriteState(String productID, isFavoriteValue) {
    _fireStore
        .collection(kProductCollection)
        .doc(productID)
        .update(isFavoriteValue);
  }




}
