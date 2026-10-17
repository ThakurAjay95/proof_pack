import 'package:equatable/equatable.dart';

import '../../domain/entity/handover_entity.dart';
import '../../domain/entity/handover_photo_entity.dart';

enum HandOverDataStatus { initial, loading, success, failed }
enum HandOverAction { none, created, updated, deleted, photosLoaded, fetchAll,  postDeleted}

class HandoverState extends Equatable {
  final HandOverDataStatus status;
  final HandOverAction action;
  final List<HandoverEntity> handoverList;
  final List<HandoverPhotoEntity> photosList;
  final String? errorMessage;

  const HandoverState(
    this.status,
    this.action,
    this.handoverList,
    this.photosList,
    this.errorMessage,
  );

  HandoverState copyWith({
    HandOverDataStatus? status,
    HandOverAction? action,
    List<HandoverEntity>? handoverList,
    String? errorMessage,
    List<HandoverPhotoEntity>? photos,
  }) {
    return HandoverState(
      status ?? this.status,
      action ?? this.action,
      handoverList ?? this.handoverList,
      photos ?? photosList,
      errorMessage ?? this.errorMessage,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    status,
    action,
    handoverList,
    photosList,
    errorMessage,
  ];
}
