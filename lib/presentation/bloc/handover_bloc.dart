import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proof_pack/handover/domain/usecase/create_handover.dart';
import 'package:proof_pack/presentation/bloc/handover_event.dart';
import 'package:proof_pack/presentation/bloc/handover_state.dart';

import '../../handover/domain/entity/handover_entity.dart';
import '../../handover/domain/usecase/delete_handover.dart';
import '../../handover/domain/usecase/get_all_handovers.dart';
import '../../handover/domain/usecase/update_handover.dart';

class HandoverBloc extends Bloc<HandoverEvent, HandoverState> {
  final CreateHandover createHandoverUseCase;
  final GetAllHandovers getAllHandoversUseCase;
  final DeleteHandover deleteHandoverUseCase;
  final UpdateHandover updateHandoverUseCase;

  HandoverBloc({
    required this.createHandoverUseCase,
    required this.getAllHandoversUseCase,
    required this.deleteHandoverUseCase,
    required this.updateHandoverUseCase,
  }) : super(HandoverState(HandOverDataStatus.initial, [], '')) {
    on<CreateHandoverEvent>(createHandOver);

    on<GetAllHandoverEvent>(getAllHandovers);

    on<DeleteHandoverEvent>(deleteHandover);

    on<UpdateHandoverEvent>(updateHandover);
  }

  Future<void> createHandOver(
    CreateHandoverEvent event,
    Emitter<HandoverState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          handOverDataStatus: HandOverDataStatus.loading,
          errorMessage: '',
        ),
      );

      await createHandoverUseCase(event.handoverEntity);
      List<HandoverEntity> handoversList = await getAllHandoversUseCase();

      emit(
        state.copyWith(
          handOverDataStatus: HandOverDataStatus.success,
          errorMessage: '',
          handoverList: handoversList,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          handOverDataStatus: HandOverDataStatus.failed,
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
        state.copyWith(
          handOverDataStatus: HandOverDataStatus.loading,
          errorMessage: '',
        ),
      );

      List<HandoverEntity> handoversList = await getAllHandoversUseCase();

      emit(
        state.copyWith(
          handOverDataStatus: HandOverDataStatus.success,
          handoverList: handoversList,
          errorMessage: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          handOverDataStatus: HandOverDataStatus.failed,
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
          handOverDataStatus: HandOverDataStatus.loading,
          errorMessage: '',
        ),
      );

      await deleteHandoverUseCase(event.id);
      final handoversList = await getAllHandoversUseCase();

      emit(
        state.copyWith(
          handOverDataStatus: HandOverDataStatus.success,
          errorMessage: '',
          handoverList: handoversList,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          handOverDataStatus: HandOverDataStatus.failed,
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
        state.copyWith(
          handOverDataStatus: HandOverDataStatus.loading,
          errorMessage: '',
        ),
      );

      await updateHandoverUseCase(event.handoverEntity);

      final handoversList = await getAllHandoversUseCase();

      emit(
        state.copyWith(
          handOverDataStatus: HandOverDataStatus.success,
          errorMessage: '',
          handoverList: handoversList,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          handOverDataStatus: HandOverDataStatus.failed,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
