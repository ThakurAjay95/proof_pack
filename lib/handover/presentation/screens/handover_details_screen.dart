import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proof_pack/presentation/bloc/handover_bloc.dart';
import 'package:proof_pack/presentation/bloc/handover_event.dart';
import 'package:proof_pack/presentation/bloc/handover_state.dart';

import '../../domain/entity/handover_entity.dart';
import 'create_handover_screen.dart';

class HandoverDetailsScreen extends StatefulWidget {
  final HandoverEntity handover;

  const HandoverDetailsScreen(this.handover, {super.key});

  @override
  State<HandoverDetailsScreen> createState() => _HandoverDetailsScreenState();
}

class _HandoverDetailsScreenState extends State<HandoverDetailsScreen> {
  @override
  late HandoverEntity _handover;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _handover = widget.handover;
  }

  Widget build(BuildContext context) {
    return BlocListener<HandoverBloc, HandoverState>(
      listener: (context, state) {
        if (state.handOverDataStatus == HandOverDataStatus.success) {
          Navigator.pop(context);
        } else if (state.handOverDataStatus == HandOverDataStatus.failed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? "Something went wrong"),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text("${_handover.title} Details")),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
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
                    ],
                  ),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _updateHandover,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text("Update"),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _deleteHandoverRecord(),
                  child: Text("Delete"),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> _updateHandover() async {
    final result = await Navigator.of(context).push<HandoverEntity>(
      MaterialPageRoute(builder: (context) => CreateHandoverScreen(_handover)),
    );
    if (result != null) {
      if (mounted) {
        setState(() {
          _handover = result;
        });
      }
    }
  }

  void _deleteHandoverRecord() async {
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
