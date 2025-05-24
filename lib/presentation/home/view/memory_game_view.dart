import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kinds_memory_game/components/start_button.dart';
import 'package:kinds_memory_game/domain/bloc/memory_game_bloc/memory_game_bloc.dart';
import 'package:kinds_memory_game/domain/bloc/memory_game_bloc/memory_game_event.dart';
import 'package:kinds_memory_game/domain/bloc/memory_game_bloc/memory_game_state.dart';
import 'package:kinds_memory_game/presentation/home/view/game_grid_view.dart';
import 'package:kinds_memory_game/presentation/home/view/game_header_view.dart';

class MemoryGameView extends StatelessWidget {
  const MemoryGameView({super.key});

  void _showWinDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: const Color(0xFF581C87).withOpacity(0.9),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: const Color(0xFFA855F7),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFA855F7).withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🎉 Congratulations!',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFD8B4FE),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                'You found all the matches.',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFFC7D2FE),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<MemoryGameBloc>().add(ResetGameEvent());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF312E81),
                  foregroundColor: const Color(0xFFC7D2FE),
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  'Play Again',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E1B4B),
              Color(0xFF312E81),
              Color(0xFF0F172A),
            ],
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<MemoryGameBloc, MemoryGameState>(
            builder: (context, state) {
              if (state is MemoryGameLoaded) {
                if (state.isGameCompleted) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showWinDialog(context);
                  });
                }
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GameHeader(state: state),
                      SizedBox(height: 40.h),
                      GameGridView(state: state),
                      SizedBox(height: 40.h),
                      const StartButton(),
                    ],
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
