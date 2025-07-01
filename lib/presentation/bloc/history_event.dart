import 'package:equatable/equatable.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object> get props => [];
}

class LoadHistory extends HistoryEvent {
  const LoadHistory();
}

class RefreshHistory extends HistoryEvent {
  const RefreshHistory();
}
