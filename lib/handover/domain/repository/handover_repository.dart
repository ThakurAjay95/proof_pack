

import 'package:proof_pack/handover/domain/entity/handover_entity.dart';

abstract class HandoverRepository {

  Future<void> createHandover(HandoverEntity handover);

  Future<HandoverEntity?> getHandoverById(String id);

  Future<List<HandoverEntity>> getAllHandovers();

  Future<void> updateHandover(HandoverEntity handover);

  Future<void> deleteHandover(String id);
}