import 'package:hive/hive.dart';
import 'package:proof_pack/handover/data/model/handover_photo_model.dart';
import 'package:proof_pack/handover/domain/entity/handover_photo_entity.dart';

class HandoverPhotoModelAdapter extends TypeAdapter<HandoverPhotoModel> {
  @override
  HandoverPhotoModel read(BinaryReader reader) {
    final id = reader.readString();
    final handoverId = reader.readString();
    final localPath = reader.readString();
    
    final hasRemotePath = reader.readBool();
    String? remotePath;
    if (hasRemotePath) {
      remotePath = reader.readString();
    }
    
    final syncStatus = HandoverPhotoSyncStatus.values[reader.readInt()];

    return HandoverPhotoModel(
      id: id,
      handoverId: handoverId,
      localPath: localPath,
      remotePath: remotePath,
      syncStatus: syncStatus,
    );
  }

  @override
  int get typeId => 1;

  @override
  void write(BinaryWriter writer, HandoverPhotoModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.handoverId);
    writer.writeString(obj.localPath);
    
    final hasRemotePath = obj.remotePath != null;
    writer.writeBool(hasRemotePath);
    if (hasRemotePath) {
      writer.writeString(obj.remotePath!);
    }
    
    writer.writeInt(obj.syncStatus.index);
  }
}
