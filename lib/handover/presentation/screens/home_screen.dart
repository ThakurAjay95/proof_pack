import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proof_pack/handover/presentation/screens/create_handover_screen.dart';
import 'package:proof_pack/handover/presentation/widgets/handover_list_item.dart';
import 'package:proof_pack/presentation/bloc/handover_bloc.dart';
import 'package:proof_pack/presentation/bloc/handover_state.dart';

import '../../../core/local/hive_service.dart';
import '../../data/datasource/local_datasource/handover_local_data_source.dart';
import '../../data/repository/handover_repository_impl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final handoverBox;
  late final repository;

  @override
  void initState() {
    super.initState();
    handoverBox = HiveService.handoverBox;
    repository = HandoverRepositoryImpl(HandoverLocalDataSource(handoverBox));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ProofPack")),
      body: BlocBuilder<HandoverBloc, HandoverState>(
        builder: (context, state) {
          if (state.handOverDataStatus == HandOverDataStatus.loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.handOverDataStatus == HandOverDataStatus.failed) {
            return Center(
              child: Text(state.errorMessage ?? 'Something went wrong'),
            );
          }
          if (state.handOverDataStatus == HandOverDataStatus.success) {
            return state.handoverList.isEmpty
                ? Center(child: Text("No handovers yet!"))
                : ListView.builder(
                    itemCount: state.handoverList.length,
                    itemBuilder: (context, index) {
                      return HandoverListItem(state.handoverList[index]);
                    },
                  );
          }
          return SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //Add events records
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateHandoverScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
