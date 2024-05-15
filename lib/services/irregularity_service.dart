import 'package:city/model/irregularity.dart';
import 'package:city/services/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String IRREGULARITY_COLLECTION = "irregularity";

class IrregularityService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference<Irregularity> _irregularityRef;

  IrregularityService() {
    _irregularityRef = _firestore
        .collection(IRREGULARITY_COLLECTION)
        .withConverter<Irregularity>(
            fromFirestore: (snapshots, _) =>
                Irregularity.fromJson(snapshots.data()!),
            toFirestore: (Irregularity irregularity, options) =>
                irregularity.toJson());
  }

  Future<Irregularity?> getIrregularityById(String id) async {
    var querySnapshot = await _irregularityRef.where('id', isEqualTo: id).get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data();
    }

    return null;
  }

  Stream<QuerySnapshot<Irregularity>> getIrregularities({String? userId}) {
    if (userId != null) {
      return _irregularityRef.where('userId', isEqualTo: userId).snapshots();
    }

    return _irregularityRef.snapshots();
  }

  Future<void> saveIrregularity(Irregularity irregularity) async {
    await _irregularityRef.doc(irregularity.id).set(irregularity);
  }

  Future<void> deleteIrregularity(
      {required String userId, required String id}) async {
    await _irregularityRef.doc(id).delete();
    await StorageService.deleteIrregularityImages(
        userId: userId, irregularityId: id);
  }
}
