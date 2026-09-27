enum HandoverPhotoSyncStatus {pending, synced, failed}


class HandoverPhotoEntity {
  final String id;
  final String handoverId;
  final String localPath;
  String? remotePath;
  final HandoverPhotoSyncStatus syncStatus;

  HandoverPhotoEntity({
    required this.id,
    required this.handoverId,
    required this.localPath,
    this.remotePath,
    required this.syncStatus,
  });
}
