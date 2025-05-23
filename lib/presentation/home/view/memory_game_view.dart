import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kinds_memory_game/components/reset_button.dart';
import 'package:kinds_memory_game/domain/bloc/memory_game_bloc/memory_game_bloc.dart';
import 'package:kinds_memory_game/domain/bloc/memory_game_bloc/memory_game_event.dart';
import 'package:kinds_memory_game/domain/bloc/memory_game_bloc/memory_game_state.dart';
import 'package:kinds_memory_game/presentation/home/widgets/memory_card_widget.dart';

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
                      _GameHeader(state: state),
                      SizedBox(height: 40.h),
                      _GameGrid(state: state),
                      SizedBox(height: 40.h),
                      const ResetButton(),
                      if (state.isGameCompleted) const WinAnimation(),
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

class _GameHeader extends StatelessWidget {
  final MemoryGameLoaded state;

  const _GameHeader({required this.state});

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

class _GameGrid extends StatelessWidget {
  final MemoryGameLoaded state;

  const _GameGrid({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF312E81).withOpacity(0.3),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.indigo.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 1,
        ),
        itemCount: state.cards.length,
        itemBuilder: (context, index) {
          return MemoryCardWidget(
            card: state.cards[index],
            index: index,
            onTap: () =>
                context.read<MemoryGameBloc>().add(CardTappedEvent(index)),
          );
        },
      ),
    );
  }
}
