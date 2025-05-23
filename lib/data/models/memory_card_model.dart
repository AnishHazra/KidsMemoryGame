import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class MemoryCardModel extends Equatable {
  final int id;
  final IconData icon;
  final Color color;
  final bool isMatched;
  final bool isFlipped;

  const MemoryCardModel({
    required this.id,
    required this.icon,
    required this.color,
    this.isMatched = false,
    this.isFlipped = false,
  });

  MemoryCardModel copyWith({
    int? id,
    IconData? icon,
    Color? color,
    bool? isMatched,
    bool? isFlipped,
  }) {
    return MemoryCardModel(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isMatched: isMatched ?? this.isMatched,
      isFlipped: isFlipped ?? this.isFlipped,
    );
  }

  @override
  List<Object?> get props => [id, icon, color, isMatched, isFlipped];
}
