import 'package:equatable/equatable.dart';

enum CreateStatus { initial, loading, success, failure }

class CreateState extends Equatable {
  final CreateStatus status;
  final String? errorMessage;

  const CreateState({
    this.status = CreateStatus.initial,
    this.errorMessage,
  });

  CreateState copyWith({
    CreateStatus? status,
    String? errorMessage,
  }) {
    return CreateState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
