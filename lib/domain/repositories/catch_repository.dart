import '../entities/catch.dart';

abstract class CatchRepository {
  Future<List<Catch>> getCatches();
  Future<Catch> getCatchById(String id);
  Future<void> addCatch(Catch fishCatch);
  Future<void> updateCatch(Catch fishCatch);
  Future<void> deleteCatch(String id);
}
