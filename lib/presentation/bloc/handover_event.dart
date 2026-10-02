import '../../handover/domain/entity/handover_entity.dart';

class HandoverEvent {}

class CreateHandoverEvent extends HandoverEvent {
  final HandoverEntity handoverEntity;

  CreateHandoverEvent(this.handoverEntity);
}

class GetAllHandoverEvent extends HandoverEvent {}

class GetHandoverByIdEvent extends HandoverEvent {
  final String id;

  GetHandoverByIdEvent(this.id);
}

class DeleteHandoverEvent extends HandoverEvent {
  final String id;

  DeleteHandoverEvent(this.id);
}

class UpdateHandoverEvent extends HandoverEvent {
  final HandoverEntity handoverEntity;

  UpdateHandoverEvent(this.handoverEntity);
}
