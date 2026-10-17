import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:proof_pack/handover/domain/entity/handover_entity.dart';
import 'package:proof_pack/handover/domain/entity/handover_photo_entity.dart';
import 'package:proof_pack/handover/presentation/bloc/handover_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proof_pack/handover/presentation/bloc/handover_event.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

import '../bloc/handover_state.dart';

class CreateHandoverScreen extends StatefulWidget {
  final HandoverEntity? entity;
  final List<HandoverPhotoEntity?>? photos;

  const CreateHandoverScreen(this.entity, this.photos, {super.key});

  @override
  State<CreateHandoverScreen> createState() => _CreateHandoverScreenState();
}

class _CreateHandoverScreenState extends State<CreateHandoverScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _notesController;
  HandoverEntity? updatedHandover;
  late final String handoverId;
  List<Map<String, dynamic>> selectImagesPath = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    handoverId = widget.entity?.id ?? const Uuid().v4();
    _titleController = TextEditingController();
    _notesController = TextEditingController();

    if (widget.entity != null) {
      _titleController.text = widget.entity!.title;
      _notesController.text = widget.entity!.notes;
    }
    if (widget.photos != null && widget.photos!.isNotEmpty) {
      selectImagesPath = widget.photos!
          .map(
            (HandoverPhotoEntity? photos) => {
              "photo": photos!.localPath,
              "isAlreadyExists": true,
            },
          )
          .toList();
    }

    Future.delayed(Duration.zero, () {
      context.read<HandoverBloc>().add(GetHandoverPhotosEvent(handoverId));
    });
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
          ? UpdateHandoverEvent(updatedHandover!)
          : CreateHandoverEvent(
              HandoverEntity(
                id: handoverId,
                title: title,
                notes: notes,
                createdAt: DateTime.now(),
                syncStatus: HandoverSyncStatus.pending,
              ),
            ),
    );

    if (selectImagesPath.isNotEmpty) {
      for (int i = 0; i < selectImagesPath.length; i++) {
        bool exists = selectImagesPath[i]['isAlreadyExists'];
        if (exists == false) {
          final photoData = selectImagesPath[i]['photo'];
          final photo = HandoverPhotoEntity(
            id: Uuid().v4(),
            handoverId: handoverId,
            localPath: photoData is File ? photoData.path : photoData as String,
            syncStatus: HandoverPhotoSyncStatus.pending,
          );

          context.read<HandoverBloc>().add(SaveHandoverPhotoEvent(photo));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HandoverBloc, HandoverState>(
      listener: (context, state) {
        if (state.status == HandOverDataStatus.success) {
          switch (state.action) {
            case HandOverAction.created:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Handover created successfully!")),
              );
              Navigator.pop(context, "success");

            case HandOverAction.updated:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Handover updated successfully!")),
              );
              Navigator.pop(context, updatedHandover);
            default:
              break;
          }
        } else if (state.status == HandOverDataStatus.failed) {
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
          body: state.status == HandOverDataStatus.loading
              ? CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
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
                            if (widget.entity != null)
                              ElevatedButton(
                                onPressed: () => _addImageForHandoverRecord(),
                                child: Text("Add Image"),
                              ),
                            SizedBox(height: 5),
                            if (selectImagesPath.isNotEmpty)
                              SizedBox(
                                height: 120,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  // Enables horizontal scrolling
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Image.file(
                                      selectImagesPath[index]['photo'] is File
                                          ? selectImagesPath[index]['photo']
                                                as File
                                          : File(
                                              selectImagesPath[index]['photo']
                                                  as String,
                                            ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  itemCount: selectImagesPath.length,
                                ),
                              ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () => _submitHandoverRecord(),
                        child: Text("Submit"),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Future<void> _addImageForHandoverRecord() async {
    final picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }

    final directory = await getApplicationDocumentsDirectory();

    final photosDirectory = Directory(
      '${directory.path}/handovers/$handoverId/photos',
    );

    await photosDirectory.create(recursive: true);

    final fileName = path.basename(image.path);

    final savedFile = await File(image.path)
        .copy('${photosDirectory.path}/$fileName');

    selectImagesPath.add(<String, Object>{
      "photo": savedFile,
      "isAlreadyExists": false,
    });
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
