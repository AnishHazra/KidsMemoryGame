import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kinds_memory_game/domain/bloc/memory_game_bloc/memory_game_bloc.dart';
import 'package:kinds_memory_game/domain/bloc/memory_game_bloc/memory_game_event.dart';

class ResetButton extends StatelessWidget {
  const ResetButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: ElevatedButton(
        onPressed: () => context.read<MemoryGameBloc>().add(ResetGameEvent()),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF312E81),
          foregroundColor: const Color(0xFFC7D2FE),
          side: const BorderSide(color: Color(0xFF3730A3)),
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
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
    );
  }
}
