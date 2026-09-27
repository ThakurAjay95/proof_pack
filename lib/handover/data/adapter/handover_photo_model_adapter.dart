import 'package:hive/hive.dart';
import 'package:proof_pack/handover/data/model/handover_photo_model.dart';
import 'package:proof_pack/handover/domain/entity/handover_photo_entity.dart';

class HandoverPhotoModelAdapter extends TypeAdapter<HandoverPhotoModel> {
  @override
  HandoverPhotoModel read(BinaryReader reader) {
    return HandoverPhotoModel(
      id: reader.readString(),
      handoverId: reader.readString(),
      localPath: reader.readString(),
      remotePath: reader.readString() as String?,
      syncStatus: HandoverPhotoSyncStatus.values[reader.readInt()],
    );
  }

  @override
  int get typeId => 1;

  @override
  void write(BinaryWriter writer, HandoverPhotoModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.handoverId);
    writer.writeString(obj.localPath);
    writer.write(obj.remotePath);
    writer.writeInt(obj.syncStatus.index);
  }
}
