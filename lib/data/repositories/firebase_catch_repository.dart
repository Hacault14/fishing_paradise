import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/catch.dart';
import '../../domain/repositories/catch_repository.dart';
import '../models/catch_model.dart';

class FirebaseCatchRepository implements CatchRepository {
  final FirebaseFirestore _firestore;
  final String _collection = 'catches';

  FirebaseCatchRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<Catch>> getCatches() async {
    final snapshot = await _firestore.collection(_collection).get();
    return snapshot.docs
        .map((doc) => CatchModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  @override
  Future<Catch> getCatchById(String id) async {
    final doc = await _firestore.collection(_collection).doc(id).get();
    if (!doc.exists) {
      throw Exception('Catch not found');
    }
    return CatchModel.fromJson({...doc.data()!, 'id': doc.id});
  }

  @override
  Future<void> addCatch(Catch fishCatch) async {
    final catchModel = fishCatch as CatchModel;
    await _firestore.collection(_collection).add(catchModel.toJson());
  }

  @override
  Future<void> updateCatch(Catch fishCatch) async {
    final catchModel = fishCatch as CatchModel;
    await _firestore
        .collection(_collection)
        .doc(catchModel.id)
        .update(catchModel.toJson());
  }

  @override
  Future<void> deleteCatch(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
}
