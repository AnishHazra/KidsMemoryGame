import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kinds_memory_game/components/start_button.dart';
import 'package:kinds_memory_game/domain/bloc/memory_game_bloc/memory_game_bloc.dart';
import 'package:kinds_memory_game/domain/bloc/memory_game_bloc/memory_game_state.dart';
import 'package:kinds_memory_game/presentation/home/view/game_grid_view.dart';
import 'package:kinds_memory_game/presentation/home/view/game_header_view.dart';
import 'package:kinds_memory_game/presentation/home/view/win_animation_view.dart';

class MemoryGameView extends StatelessWidget {
  const MemoryGameView({super.key});

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
                      if (state.isGameCompleted) const WinAnimationView(),
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
