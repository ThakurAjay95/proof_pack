import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proof_pack/handover/domain/entity/handover_entity.dart';
import 'package:proof_pack/handover/presentation/screens/handover_details_screen.dart';

class HandoverListItem extends StatelessWidget {
  final HandoverEntity handoverEntity;

  const HandoverListItem(this.handoverEntity, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Card(
        child: ListTile(
          onTap: () async {
            //Add events records
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HandoverDetailsScreen(handoverEntity),
              ),
            );
          },
          title: Text(
            handoverEntity.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            handoverEntity.notes,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
