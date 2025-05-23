import 'package:equatable/equatable.dart';

abstract class MemoryGameEvent extends Equatable {
  const MemoryGameEvent();

  @override
  List<Object?> get props => [];
}

class InitializeGameEvent extends MemoryGameEvent {}

class CardTappedEvent extends MemoryGameEvent {
  final int cardIndex;

  const CardTappedEvent(this.cardIndex);

  @override
  List<Object?> get props => [cardIndex];
}

class CheckMatchEvent extends MemoryGameEvent {
  final List<int> cardIndexes;

  const CheckMatchEvent(this.cardIndexes);

  @override
  List<Object?> get props => [cardIndexes];
}

class ResetGameEvent extends MemoryGameEvent {}

class FlipBackCardsEvent extends MemoryGameEvent {
  final List<int> cardIndexes;

  const FlipBackCardsEvent(this.cardIndexes);

  @override
  List<Object?> get props => [cardIndexes];
}
