import 'package:proof_pack/handover/domain/entity/handover_photo_entity.dart';

class HandoverPhotoModel extends HandoverPhotoEntity {
   HandoverPhotoModel({
    required super.id,
    required super.handoverId,
    required super.localPath,
    super.remotePath,
    required super.syncStatus,
  });

  factory HandoverPhotoModel.fromJson(Map<String, dynamic> json) {
    return HandoverPhotoModel(
      id: json['id'] as String,
      handoverId: json['handoverId'] as String,
      localPath: json['localPath'] as String,
      remotePath: json['remotePath'] as String,
      syncStatus: HandoverPhotoSyncStatus.values.byName(
        json['syncStatus'] as String,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'handoverId': handoverId,
      'localPath': localPath,
      'remotePath': remotePath,
      'syncStatus': syncStatus.name,
    };
  }
}
