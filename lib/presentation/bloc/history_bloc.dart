import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_adoption_history_usecase.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetAdoptionHistoryUseCase getAdoptionHistoryUseCase;

  HistoryBloc({required this.getAdoptionHistoryUseCase})
    : super(HistoryInitial()) {
    on<LoadHistory>(_onLoadHistory);
    on<RefreshHistory>(_onRefreshHistory);
  }

  void _onLoadHistory(LoadHistory event, Emitter<HistoryState> emit) async {
    try {
      if (state is HistoryInitial) {
        emit(HistoryLoading());
      }

      final history = await getAdoptionHistoryUseCase();
      emit(HistoryLoaded(history));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  void _onRefreshHistory(
    RefreshHistory event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      emit(HistoryLoading());
      final history = await getAdoptionHistoryUseCase();
      emit(HistoryLoaded(history));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }
}
