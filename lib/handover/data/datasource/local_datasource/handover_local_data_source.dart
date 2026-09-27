import 'package:hive/hive.dart';
import 'package:proof_pack/handover/data/model/handover_model.dart';

class HandoverLocalDataSource {
  final Box<HandoverModel> box;

  HandoverLocalDataSource(this.box);

  Future<void> save(HandoverModel handover) async {
    await box.put(handover.id, handover);
  }

  Future<HandoverModel?> getById(String id) async {
    return box.get(id);
  }

  Future<List<HandoverModel>> getAll() async {
    return box.values.toList();
  }

  Future<void> delete(String id) async {
    await box.delete(id);
  }
}
