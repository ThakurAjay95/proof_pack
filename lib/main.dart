import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proof_pack/handover/data/repository/handover_photo_repository_impl.dart';
import 'package:proof_pack/handover/domain/usecase/save_handover_photo.dart';
import 'package:proof_pack/handover/presentation/bloc/handover_bloc.dart';
import 'package:proof_pack/handover/presentation/bloc/handover_event.dart';

import 'core/local/hive_service.dart';
import 'handover/data/datasource/local_datasource/handover_local_data_source.dart';
import 'handover/data/datasource/local_datasource/handover_photos_local_data_source.dart';
import 'handover/data/repository/handover_repository_impl.dart';
import 'handover/domain/usecase/create_handover.dart';
import 'handover/domain/usecase/delete_handover.dart';
import 'handover/domain/usecase/delete_handover_photos.dart';
import 'handover/domain/usecase/get_all_handovers.dart';
import 'handover/domain/usecase/get_all_handovers_photos.dart';
import 'handover/domain/usecase/update_handover.dart';
import 'handover/presentation/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final handoverBox;
  late final handoverPhotoBox;
  late final repository;
  late final photosRepository;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    handoverBox = HiveService.handoverBox;
    handoverPhotoBox = HiveService.handoverPhotoBox;
    repository = HandoverRepositoryImpl(HandoverLocalDataSource(handoverBox));
    photosRepository = HandoverPhotoRepositoryImpl(HandoverPhotosLocalDataSource(handoverPhotoBox));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HandoverBloc>(
      create: (context) => HandoverBloc(
        createHandoverUseCase: CreateHandover(repository),
        getAllHandoversUseCase: GetAllHandovers(repository),
        deleteHandoverUseCase: DeleteHandover(repository),
        updateHandoverUseCase: UpdateHandover(repository),
        saveHandoverPhotoUseCase: SaveHandoverPhoto(photosRepository),
        deleteHandoverPhotosUseCase: DeleteHandoverPhotos(photosRepository),
        getAllHandoversPhotosUseCase: GetAllHandoversPhotos(photosRepository),
      )..add(GetAllHandoverEvent()),
      child: MaterialApp(
        title: 'Proof Pack',
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
        home: const HomeScreen(),
      ),
    );
  }
}
