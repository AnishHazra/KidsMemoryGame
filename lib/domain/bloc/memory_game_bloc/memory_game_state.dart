import 'package:equatable/equatable.dart';
import 'package:kinds_memory_game/data/models/memory_card_model.dart';

abstract class MemoryGameState extends Equatable {
  const MemoryGameState();

  @override
  List<Object?> get props => [];
}

class MemoryGameInitial extends MemoryGameState {}

class MemoryGameLoaded extends MemoryGameState {
  final List<MemoryCardModel> cards;
  final List<int> flippedIndexes;
  final int matches;
  final bool isChecking;
  final bool isGameCompleted;

  const MemoryGameLoaded({
    required this.cards,
    required this.flippedIndexes,
    required this.matches,
    required this.isChecking,
    required this.isGameCompleted,
  });

  MemoryGameLoaded copyWith({
    List<MemoryCardModel>? cards,
    List<int>? flippedIndexes,
    int? matches,
    bool? isChecking,
    bool? isGameCompleted,
  }) {
    return MemoryGameLoaded(
      cards: cards ?? this.cards,
      flippedIndexes: flippedIndexes ?? this.flippedIndexes,
      matches: matches ?? this.matches,
      isChecking: isChecking ?? this.isChecking,
      isGameCompleted: isGameCompleted ?? this.isGameCompleted,
    );
  }

  int get totalPairs => cards.length ~/ 2;

  @override
  List<Object?> get props => [
        cards,
        flippedIndexes,
        matches,
        isChecking,
        isGameCompleted,
      ];
}
