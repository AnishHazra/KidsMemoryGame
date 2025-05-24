import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kinds_memory_game/domain/bloc/memory_game_bloc/memory_game_bloc.dart';
import 'package:kinds_memory_game/domain/bloc/memory_game_bloc/memory_game_event.dart';

class StartButton extends StatelessWidget {
  const StartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFD8B4FE),
              Colors.pink,
              Color(0xFFA5B4FC),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: const EdgeInsets.all(2),
        child: ElevatedButton(
          onPressed: () => context.read<MemoryGameBloc>().add(ResetGameEvent()),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF312E81),
            foregroundColor: const Color(0xFFC7D2FE),
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            elevation: 8,
            shadowColor: Colors.black.withOpacity(0.3),
          ),
          child: Text(
            'Start New Game',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
