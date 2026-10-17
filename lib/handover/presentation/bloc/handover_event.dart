import '../../domain/entity/handover_entity.dart';
import '../../domain/entity/handover_photo_entity.dart';

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

class SaveHandoverPhotoEvent extends HandoverEvent {
  final HandoverPhotoEntity photo;

  SaveHandoverPhotoEvent(this.photo);
}

class GetHandoverPhotosEvent extends HandoverEvent {
  final String handoverId;

  GetHandoverPhotosEvent(this.handoverId);
}

class DeleteHandoverPhotoEvent extends HandoverEvent {
  final String photoId;

  DeleteHandoverPhotoEvent(this.photoId);
}