import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proof_pack/handover/domain/entity/handover_photo_entity.dart';
import 'package:proof_pack/handover/domain/usecase/create_handover.dart';
import 'package:proof_pack/handover/presentation/bloc/handover_event.dart';

import '../../domain/entity/handover_entity.dart';
import '../../domain/usecase/delete_handover.dart';
import '../../domain/usecase/delete_handover_photos.dart';
import '../../domain/usecase/get_all_handovers.dart';
import '../../domain/usecase/get_all_handovers_photos.dart';
import '../../domain/usecase/save_handover_photo.dart';
import '../../domain/usecase/update_handover.dart';
import 'handover_state.dart';

class HandoverBloc extends Bloc<HandoverEvent, HandoverState> {
  final CreateHandover createHandoverUseCase;
  final GetAllHandovers getAllHandoversUseCase;
  final DeleteHandover deleteHandoverUseCase;
  final UpdateHandover updateHandoverUseCase;

  final SaveHandoverPhoto saveHandoverPhotoUseCase;
  final DeleteHandoverPhotos deleteHandoverPhotosUseCase;
  final GetAllHandoversPhotos getAllHandoversPhotosUseCase;

  HandoverBloc({
    required this.createHandoverUseCase,
    required this.getAllHandoversUseCase,
    required this.deleteHandoverUseCase,
    required this.updateHandoverUseCase,
    required this.saveHandoverPhotoUseCase,
    required this.deleteHandoverPhotosUseCase,
    required this.getAllHandoversPhotosUseCase,
  }) : super(
         HandoverState(
           HandOverDataStatus.initial,
           HandOverAction.none,
           [],
           [],
           '',
         ),
       ) {
    on<CreateHandoverEvent>(createHandOver);

    on<GetAllHandoverEvent>(getAllHandovers);

    on<DeleteHandoverEvent>(deleteHandover);

    on<UpdateHandoverEvent>(updateHandover);

    on<SaveHandoverPhotoEvent>(savePhotoHandover);

    on<GetHandoverPhotosEvent>(getPhotosByHandoverId);

    on<DeleteHandoverPhotoEvent>(deletePhotosById);
  }

  Future<void> createHandOver(
    CreateHandoverEvent event,
    Emitter<HandoverState> emit,
  ) async {
    try {
      emit(
        state.copyWith(status: HandOverDataStatus.loading, errorMessage: ''),
      );

      await createHandoverUseCase(event.handoverEntity);
      List<HandoverEntity> handoversList = await getAllHandoversUseCase();

      emit(
        state.copyWith(
          status: HandOverDataStatus.success,
          action: HandOverAction.created,
          errorMessage: '',
          handoverList: handoversList,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HandOverDataStatus.failed,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> getAllHandovers(
    GetAllHandoverEvent event,
    Emitter<HandoverState> emit,
  ) async {
    try {
      emit(
        state.copyWith(status: HandOverDataStatus.loading, errorMessage: ''),
      );

      List<HandoverEntity> handoversList = await getAllHandoversUseCase();

      emit(
        state.copyWith(
          status: HandOverDataStatus.success,
          action: HandOverAction.fetchAll,
          handoverList: handoversList,
          errorMessage: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HandOverDataStatus.failed,
          handoverList: [],
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> deleteHandover(
    DeleteHandoverEvent event,
    Emitter<HandoverState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: HandOverDataStatus.loading,
          action: HandOverAction.deleted,
          errorMessage: '',
        ),
      );

      await deleteHandoverUseCase(event.id);
      final handoversList = await getAllHandoversUseCase();

      emit(
        state.copyWith(
          status: HandOverDataStatus.success,
          action: HandOverAction.deleted,
          errorMessage: '',
          handoverList: handoversList,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HandOverDataStatus.failed,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> updateHandover(
    UpdateHandoverEvent event,
    Emitter<HandoverState> emit,
  ) async {
    try {
      emit(
        state.copyWith(status: HandOverDataStatus.loading, errorMessage: ''),
      );

      await updateHandoverUseCase(event.handoverEntity);

      final handoversList = await getAllHandoversUseCase();

      emit(
        state.copyWith(
          status: HandOverDataStatus.success,
          action: HandOverAction.updated,
          errorMessage: '',
          handoverList: handoversList,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HandOverDataStatus.failed,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> savePhotoHandover(
    SaveHandoverPhotoEvent event,
    Emitter<HandoverState> emit,
  ) async {
    try {
      emit(
        state.copyWith(status: HandOverDataStatus.loading, errorMessage: ''),
      );

      await saveHandoverPhotoUseCase(event.photo);
      List<HandoverPhotoEntity> photosList = await getAllHandoversPhotosUseCase(
        event.photo.id,
      );

      emit(
        state.copyWith(
          status: HandOverDataStatus.success,
          errorMessage: '',
          photos: photosList,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HandOverDataStatus.failed,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> getPhotosByHandoverId(
    GetHandoverPhotosEvent event,
    Emitter<HandoverState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: HandOverDataStatus.loading,
          errorMessage: '',
          handoverList: state.handoverList,
        ),
      );

      List<HandoverPhotoEntity> photosList = await getAllHandoversPhotosUseCase(
        event.handoverId,
      );

      emit(
        state.copyWith(
          status: HandOverDataStatus.success,
          action: HandOverAction.photosLoaded,
          photos: photosList,
          handoverList: state.handoverList,
          errorMessage: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HandOverDataStatus.failed,
          handoverList: state.handoverList,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> deletePhotosById(
      DeleteHandoverPhotoEvent event,
      Emitter<HandoverState> emit,
      ) async {
    try {
      emit(
        state.copyWith(
          status: HandOverDataStatus.loading,
          action: HandOverAction.postDeleted,
          errorMessage: '',
        ),
      );

      await deleteHandoverPhotosUseCase(event.photoId);
      final handoversList = await getAllHandoversUseCase();

      emit(
        state.copyWith(
          status: HandOverDataStatus.success,
          action: HandOverAction.postDeleted,
          errorMessage: '',
          handoverList: handoversList,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HandOverDataStatus.failed,
          errorMessage: e.toString(),
        ),
      );
    }
  }

}
