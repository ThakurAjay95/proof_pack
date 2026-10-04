import 'package:flutter/material.dart';
import 'package:proof_pack/handover/domain/entity/handover_entity.dart';
import 'package:proof_pack/presentation/bloc/handover_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proof_pack/presentation/bloc/handover_event.dart';
import 'package:proof_pack/presentation/bloc/handover_state.dart';
import 'package:uuid/uuid.dart';

class CreateHandoverScreen extends StatefulWidget {
  final HandoverEntity? entity;

  const CreateHandoverScreen(this.entity, {super.key});

  @override
  State<CreateHandoverScreen> createState() => _CreateHandoverScreenState();
}

class _CreateHandoverScreenState extends State<CreateHandoverScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _notesController;
  HandoverEntity? updatedHandover;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController = TextEditingController();
    _notesController = TextEditingController();

    if (widget.entity != null) {
      _titleController.text = widget.entity!.title;
      _notesController.text = widget.entity!.notes;
    }
  }

  void _submitHandoverRecord() {
    final title = _titleController.text;
    final notes = _notesController.text;

    if (title.isEmpty) {
      return;
    }
    if (widget.entity != null) {
      updatedHandover = HandoverEntity(
        id: widget.entity!.id,
        title: _titleController.text,
        notes: _notesController.text,
        createdAt: widget.entity!.createdAt,
        syncStatus: HandoverSyncStatus.pending,
      );
    }

    context.read<HandoverBloc>().add(
      widget.entity != null
          ? CreateHandoverEvent(updatedHandover!)
          : CreateHandoverEvent(
              HandoverEntity(
                id: Uuid().v4(),
                title: title,
                notes: notes,
                createdAt: DateTime.now(),
                syncStatus: HandoverSyncStatus.pending,
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HandoverBloc, HandoverState>(
      listener: (context, state) {
        if (state.handOverDataStatus == HandOverDataStatus.success) {
          Navigator.pop(context, updatedHandover ?? "result");
        } else if (state.handOverDataStatus == HandOverDataStatus.failed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? "Something went wrong"),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.entity != null ? "Update Handover" : "Create Handover",
            ),
          ),
          body: Center(
            child: state.handOverDataStatus == HandOverDataStatus.loading
                ? CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(labelText: "Title"),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          minLines: 1,
                          maxLines: 3,
                          controller: _notesController,
                          decoration: InputDecoration(labelText: "Notes"),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => _submitHandoverRecord(),
                          child: Text("Submit"),
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
