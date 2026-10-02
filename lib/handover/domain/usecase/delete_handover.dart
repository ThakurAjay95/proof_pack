import '../repository/handover_repository.dart';

class DeleteHandover {
  final HandoverRepository _repository;

  DeleteHandover(this._repository);

  Future<void> call(String id) {
    return _repository.deleteHandover(id);
  }
}