import 'package:proof_pack/handover/domain/repository/handover_repository.dart';

import '../entity/handover_entity.dart';

class CreateHandover {
  final HandoverRepository _repository;

  CreateHandover(this._repository);

  Future<void> call(HandoverEntity handover) {
    return _repository.createHandover(handover);
  }
}
