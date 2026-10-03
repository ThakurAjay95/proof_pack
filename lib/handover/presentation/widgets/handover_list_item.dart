import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proof_pack/handover/domain/entity/handover_entity.dart';

class HandoverListItem extends StatelessWidget {
  final HandoverEntity handoverEntity;

  const HandoverListItem(this.handoverEntity, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          title: Text(handoverEntity.title),
          subtitle: Text(handoverEntity.notes),
        ),
      ),
    );
  }
}
