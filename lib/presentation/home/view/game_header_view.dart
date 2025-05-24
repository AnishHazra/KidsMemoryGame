import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../domain/bloc/memory_game_bloc/memory_game_state.dart';

class GameHeader extends StatelessWidget {
  final MemoryGameLoaded state;

  const GameHeader({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              Color(0xFFD8B4FE),
              Colors.pink,
              Color(0xFFA5B4FC),
            ],
          ).createShader(bounds),
          child: Text(
            'Memory Match Game',
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 12.h),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            'Matches found: ${state.matches} of ${state.totalPairs}',
            key: ValueKey(state.matches),
            style: TextStyle(
              color: const Color(0xFFC7D2FE),
              fontSize: 16.sp,
            ),
          ),
        ),
      ],
    );
  }
}
