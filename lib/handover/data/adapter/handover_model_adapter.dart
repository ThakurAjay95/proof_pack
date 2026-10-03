import 'package:hive/hive.dart';
import 'package:proof_pack/handover/data/model/handover_model.dart';
import 'package:proof_pack/handover/domain/entity/handover_entity.dart';

class HandoverModelAdapter extends TypeAdapter<HandoverModel> {
  @override
  HandoverModel read(BinaryReader reader) {
    return HandoverModel(
      id: reader.readString(),
      title: reader.readString(),
      notes: reader.readString(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      syncStatus: HandoverSyncStatus.values[reader.readInt()],
    );
  }

  @override
  int get typeId => 0;

  @override
  void write(BinaryWriter writer, HandoverModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.notes);
    writer.writeInt(obj.createdAt.millisecondsSinceEpoch);
    writer.writeInt(obj.syncStatus.index);
  }
}
