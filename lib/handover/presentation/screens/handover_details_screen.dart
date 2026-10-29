import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proof_pack/handover/presentation/bloc/handover_bloc.dart';
import 'package:proof_pack/handover/presentation/bloc/handover_event.dart';

import '../../domain/entity/handover_entity.dart';
import '../../domain/entity/handover_photo_entity.dart';
import '../bloc/handover_state.dart';
import 'create_handover_screen.dart';

class HandoverDetailsScreen extends StatefulWidget {
  final HandoverEntity handover;

  const HandoverDetailsScreen(this.handover, {super.key});

  @override
  State<HandoverDetailsScreen> createState() => _HandoverDetailsScreenState();
}

class _HandoverDetailsScreenState extends State<HandoverDetailsScreen> {
  late HandoverEntity _handover;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _handover = widget.handover;
    Future.delayed(Duration.zero, () {
      context.read<HandoverBloc>().add(GetHandoverPhotosEvent(_handover.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HandoverBloc, HandoverState>(
      listener: (context, state) {
        if (state.status == HandOverDataStatus.success) {
          switch (state.action) {
            case HandOverAction.deleted:
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Record deleted Successfully")),
              );

            case HandOverAction.postDeleted:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Post deleted Successfully")),
              );

            case HandOverAction.photosLoaded:
              break;
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
          appBar: AppBar(title: Text("${_handover.title} Details")),
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          color: Colors.grey[100],
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_handover.title),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_handover.createdAt.toIso8601String()),
                                    SizedBox(width: 10),
                                    Text(_handover.syncStatus.name),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(_handover.notes),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 120,
                          child: state.photosList.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  // Enables horizontal scrolling
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Image.file(
                                      File(state.photosList[index].localPath),
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey[200],
                                              alignment: Alignment.center,
                                              child: const Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.broken_image,
                                                    color: Colors.grey,
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    'File missing',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                  itemCount: state.photosList.length,
                                )
                              : Text(
                                  "No Photos Attached!",
                                  style: TextStyle(color: Colors.grey),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _updateHandover(state.photosList),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text("Update"),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _deleteHandoverRecord(state.photosList),
                    child: Text("Delete"),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Future<void> _updateHandover(List<HandoverPhotoEntity> photos) async {
    final result = await Navigator.of(context).push<HandoverEntity>(
      MaterialPageRoute(
        builder: (context) => CreateHandoverScreen(_handover, photos),
      ),
    );
    if (result != null) {
      if (mounted) {
        setState(() {
          _handover = result;
          context.read<HandoverBloc>().add(
            GetHandoverPhotosEvent(_handover.id),
          );
        });
      }
    }
  }

  void _deleteHandoverRecord(List<HandoverPhotoEntity> photosList) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Handover?"),
          content: Text("This action cannot be undone."),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (photosList.isNotEmpty) {
                  for (final photo in photosList) {
                    //Delete all related photos as well when we delete the handover
                    context.read<HandoverBloc>().add(
                      DeleteHandoverPhotoEvent(photo.id),
                    );
                  }
                }

                context.read<HandoverBloc>().add(
                  DeleteHandoverEvent(_handover.id),
                );
              },
              child: Text("Yes"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
