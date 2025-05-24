import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kinds_memory_game/domain/bloc/memory_game_bloc/memory_game_bloc.dart';
import 'package:kinds_memory_game/domain/bloc/memory_game_bloc/memory_game_event.dart';
import 'package:kinds_memory_game/domain/bloc/memory_game_bloc/memory_game_state.dart';
import 'package:kinds_memory_game/presentation/home/widgets/memory_card_widget.dart';

class GameGridView extends StatelessWidget {
  final MemoryGameLoaded state;

  const GameGridView({super.key, required this.state});

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
            onTap: () => context.read<MemoryGameBloc>().add(
                  CardTappedEvent(index),
                ),
          );
        },
      ),
    );
  }
}
