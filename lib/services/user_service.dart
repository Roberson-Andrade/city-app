import 'package:city/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String USER_COLLECTION = "user";

class UserService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference<User> _userRef;

  UserService() {
    _userRef = _firestore.collection(USER_COLLECTION).withConverter<User>(
        fromFirestore: (snapshots, _) => User.fromJson(snapshots.data()!),
        toFirestore: (User user, options) => user.toJson());
  }

  Future<User?> getUserById(String id) async {
    var querySnapshot = await _userRef.where('id', isEqualTo: id).get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data();
    }

    return null;
  }

  Future<void> saveUser(User user) async {
    await _userRef.add(user);
  }
}
