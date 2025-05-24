import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinds_memory_game/data/models/memory_card_model.dart';
import 'package:kinds_memory_game/domain/bloc/memory_game_bloc/memory_game_event.dart';
import 'package:kinds_memory_game/domain/bloc/memory_game_bloc/memory_game_state.dart';

class MemoryGameBloc extends Bloc<MemoryGameEvent, MemoryGameState> {
  MemoryGameBloc() : super(MemoryGameInitial()) {
    on<InitializeGameEvent>(_onInitializeGame);
    on<CardTappedEvent>(_onCardTapped);
    on<CheckMatchEvent>(_onCheckMatch);
    on<FlipBackCardsEvent>(_onFlipBackCards);
    on<ResetGameEvent>(_onResetGame);
  }

  static const List<Map<String, dynamic>> _iconConfigs = [
    {'icon': Icons.favorite_border, 'color': Colors.red},
    {'icon': Icons.star_border, 'color': Colors.amber},
    {'icon': Icons.wb_sunny_outlined, 'color': Colors.yellow},
    {'icon': Icons.nightlight_outlined, 'color': Colors.purple},
    {'icon': Icons.cloud_outlined, 'color': Colors.blue},
    {'icon': Icons.local_florist_outlined, 'color': Colors.green},
  ];

  Future<void> _onInitializeGame(
    InitializeGameEvent event,
    Emitter<MemoryGameState> emit,
  ) async {
    final cards = <MemoryCardModel>[];

    for (int i = 0; i < _iconConfigs.length; i++) {
      final config = _iconConfigs[i];
      final color = (config['color'] as MaterialColor)[400]!;

      // Add two cards of each type
      cards.add(MemoryCardModel(
        id: i * 2,
        icon: config['icon'] as IconData,
        color: color,
      ));
      cards.add(MemoryCardModel(
        id: i * 2 + 1,
        icon: config['icon'] as IconData,
        color: color,
      ));
    }

    // Shuffle the cards
    cards.shuffle(Random());

    emit(MemoryGameLoaded(
      cards: cards,
      flippedIndexes: const [],
      matches: 0,
      isChecking: false,
      isGameCompleted: false,
    ));
  }

  Future<void> _onCardTapped(
    CardTappedEvent event,
    Emitter<MemoryGameState> emit,
  ) async {
    final currentState = state;
    if (currentState is! MemoryGameLoaded) return;

    final card = currentState.cards[event.cardIndex];

    // Prevent invalid moves
    if (currentState.isChecking ||
        card.isMatched ||
        currentState.flippedIndexes.contains(event.cardIndex) ||
        currentState.flippedIndexes.length >= 2) {
      return;
    }

    // Flip the card
    final updatedCards = List<MemoryCardModel>.from(currentState.cards);
    updatedCards[event.cardIndex] = card.copyWith(isFlipped: true);

    final newFlippedIndexes = List<int>.from(currentState.flippedIndexes)
      ..add(event.cardIndex);

    emit(currentState.copyWith(
      cards: updatedCards,
      flippedIndexes: newFlippedIndexes,
    ));

    // Check for match if two cards are flipped
    if (newFlippedIndexes.length == 2) {
      await Future.delayed(const Duration(milliseconds: 600));
      add(CheckMatchEvent(newFlippedIndexes));
    }
  }

  Future<void> _onCheckMatch(
    CheckMatchEvent event,
    Emitter<MemoryGameState> emit,
  ) async {
    final currentState = state;
    if (currentState is! MemoryGameLoaded) return;

    emit(currentState.copyWith(isChecking: true));

    final firstIndex = event.cardIndexes[0];
    final secondIndex = event.cardIndexes[1];
    final firstCard = currentState.cards[firstIndex];
    final secondCard = currentState.cards[secondIndex];

    final updatedCards = List<MemoryCardModel>.from(currentState.cards);

    if (firstCard.icon == secondCard.icon) {
      // Match found
      updatedCards[firstIndex] = firstCard.copyWith(isMatched: true);
      updatedCards[secondIndex] = secondCard.copyWith(isMatched: true);

      final newMatches = currentState.matches + 1;
      final isCompleted = newMatches == currentState.totalPairs;

      emit(currentState.copyWith(
        cards: updatedCards,
        flippedIndexes: const [],
        matches: newMatches,
        isChecking: false,
        isGameCompleted: isCompleted,
      ));
    } else {
      // No match - flip back after delay
      await Future.delayed(const Duration(milliseconds: 800));
      add(FlipBackCardsEvent(event.cardIndexes));
    }
  }

  Future<void> _onFlipBackCards(
    FlipBackCardsEvent event,
    Emitter<MemoryGameState> emit,
  ) async {
    final currentState = state;
    if (currentState is! MemoryGameLoaded) return;

    final updatedCards = List<MemoryCardModel>.from(currentState.cards);

    for (final index in event.cardIndexes) {
      updatedCards[index] = updatedCards[index].copyWith(isFlipped: false);
    }

    emit(currentState.copyWith(
      cards: updatedCards,
      flippedIndexes: const [],
      isChecking: false,
    ));
  }

  Future<void> _onResetGame(
    ResetGameEvent event,
    Emitter<MemoryGameState> emit,
  ) async {
    add(InitializeGameEvent());
  }
}
