import 'package:proof_pack/handover/data/datasource/local_datasource/handover_local_data_source.dart';
import 'package:proof_pack/handover/data/model/handover_model.dart';
import 'package:proof_pack/handover/domain/entity/handover_entity.dart';
import 'package:proof_pack/handover/domain/repository/handover_repository.dart';

class HandoverRepositoryImpl implements HandoverRepository {
  final HandoverLocalDataSource _handoverLocalDataSource;

  HandoverRepositoryImpl(this._handoverLocalDataSource);

  @override
  Future<void> createHandover(HandoverEntity handover) {
    final model = HandoverModel.fromEntity(handover);
    return _handoverLocalDataSource.save(model);
  }

  @override
  Future<void> deleteHandover(String id) {
    return _handoverLocalDataSource.delete(id);
  }

  @override
  Future<List<HandoverEntity>> getAllHandovers() async {
    final models = await _handoverLocalDataSource.getAll();

    return models.map((models) => models.toEntity()).toList();
  }

  @override
  Future<HandoverEntity?> getHandoverById(String id) async {
    final model = await _handoverLocalDataSource.getById(id);
    return model?.toEntity();
  }

  @override
  Future<void> updateHandover(HandoverEntity handover) {
    final model = HandoverModel.fromEntity(handover);
    return _handoverLocalDataSource.save(model);
  }
}
