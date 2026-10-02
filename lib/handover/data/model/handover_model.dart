import 'package:proof_pack/handover/domain/entity/handover_entity.dart';

class HandoverModel extends HandoverEntity {
  HandoverModel({
    required super.id,
    required super.title,
    required super.notes,
    required super.createdAt,
    required super.syncStatus,
  });

  factory HandoverModel.fromEntity(HandoverEntity entity) {
    return HandoverModel(
      id: entity.id,
      title: entity.title,
      notes: entity.notes,
      createdAt: entity.createdAt,
      syncStatus: entity.syncStatus,
    );
  }

  HandoverEntity toEntity() {
    return HandoverEntity(
      id: id,
      title: title,
      notes: notes,
      createdAt: createdAt,
      syncStatus: syncStatus,
    );
  }

  factory HandoverModel.fromJson(Map<String, dynamic> json) {
    return HandoverModel(
      id: json['id'] as String,
      title: json['title'] as String,
      notes: json['notes'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      syncStatus: HandoverSyncStatus.values.byName(
        json['syncStatus'] as String,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'syncStatus': syncStatus.name,
    };
  }
}
