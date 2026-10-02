import 'package:equatable/equatable.dart';

import '../../handover/domain/entity/handover_entity.dart';

enum HandOverDataStatus { initial, loading, success, failed }

class HandoverState extends Equatable {
  final HandOverDataStatus handOverDataStatus;
  final List<HandoverEntity> handoverList;
  final String? errorMessage;

  const HandoverState(
    this.handOverDataStatus,
    this.handoverList,
    this.errorMessage,
  );

  HandoverState copyWith({
    HandOverDataStatus? handOverDataStatus,
    List<HandoverEntity>? handoverList,
    String? errorMessage,
  }) {
    return HandoverState(
      handOverDataStatus ?? this.handOverDataStatus,
      handoverList ?? this.handoverList,
      errorMessage ?? this.errorMessage,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [handOverDataStatus, handoverList, errorMessage];
}
