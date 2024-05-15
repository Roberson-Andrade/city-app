import 'dart:collection';

import 'package:city/model/irregularity.dart';
import 'package:city/services/irregularity_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class IrregularityRepository extends ChangeNotifier {
  late IrregularityService _irregularityService;

  IrregularityRepository({required IrregularityService irregularityService}) {
    _irregularityService = irregularityService;
  }

  Stream<QuerySnapshot<Irregularity>> getIrregularities() {
    return _irregularityService.getIrregularities();
  }

  Future<void> saveIrregularity(Irregularity irregularity) async {
    await _irregularityService.saveIrregularity(irregularity);
  }

  Stream<QuerySnapshot<Irregularity>> getIrregularitiesByUserId(
      String? userId) {
    return _irregularityService.getIrregularities(userId: userId);
  }

  Future<void> deleteIrregularity(
      {required String userId, required String id}) async {
    await _irregularityService.deleteIrregularity(id: id, userId: userId);
  }
}
