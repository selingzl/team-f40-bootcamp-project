import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CoinProvider with ChangeNotifier {
  int coin = 0;
  //String? userId = FirebaseAuth.instance.currentUser?.uid;

  //To get the user's coin data from the db;
  Future<int> fetchCoinData(String userId) async {
    int coinOfUser = 0;
    try {
      CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
      QuerySnapshot querySnapshot =
      await usersCollection.where('userId', isEqualTo: userId).get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        coinOfUser = userData['currentPoint'];
      } else {
        print('No document found for the given userId.');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    return coinOfUser;
  }

  //In order to update related fiels under the users collection on Db;
  Future<void> updateUserCoin(int coin, String userId) async {
    try {
      CollectionReference userBooksCollection =
      FirebaseFirestore.instance.collection('users');
      QuerySnapshot querySnapshot =
      await userBooksCollection.where('userId', isEqualTo: userId).get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        // Update the related fields
        DocumentReference userBookDocRef = userDoc.reference;
        return userBookDocRef
            .update({
          'currentPoint': coin,
        })
            .then((value) => print('Coin data is updated successfully'))
            .catchError((error) => print('Failed to update the coin: $error'));
      } else {
        print('User record does not exist.');
      }
    } catch (e) {
      print('Error retrieving user data: $e');
    }
  }

  //To get the user's coin data from the db when the timer page is initialized(called in initState);
  void getUsersCoin(String userId) async {
    coin = await fetchCoinData(userId);
    notifyListeners();
  }

  void increaseCoin(int amount, String userId) {
    coin += amount;
    updateUserCoin(coin, userId);
    notifyListeners();
  }
}
