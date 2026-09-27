enum HandoverSyncStatus {pending, syncing, synced, failed}
//pending → 0
// syncing → 1
// synced  → 2
// failed  → 3
class HandoverEntity {
  final String id;
  final String title;
  final String notes;
  final DateTime createdAt;
  final HandoverSyncStatus  syncStatus;

  HandoverEntity({
    required this.id,
    required this.title,
    required this.notes,
    required this.createdAt,
    required this.syncStatus,
  });


}


