import '../entity/handover_entity.dart';
import '../repository/handover_repository.dart';

class GetAllHandovers {
  final HandoverRepository _repository;

  GetAllHandovers(this._repository);

  Future<List<HandoverEntity>> call() {
    return _repository.getAllHandovers();
  }
}