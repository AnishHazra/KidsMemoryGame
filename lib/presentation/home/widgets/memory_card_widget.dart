import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kinds_memory_game/data/models/memory_card_model.dart';

class MemoryCardWidget extends StatefulWidget {
  final MemoryCardModel card;
  final int index;
  final VoidCallback onTap;

  const MemoryCardWidget({
    super.key,
    required this.card,
    required this.index,
    required this.onTap,
  });

  @override
  State<MemoryCardWidget> createState() => _MemoryCardWidgetState();
}

class _MemoryCardWidgetState extends State<MemoryCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _flipAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutBack,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3, curve: Curves.elasticOut),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MemoryCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.card.isFlipped && !oldWidget.card.isFlipped) {
      _controller.forward();
    } else if (!widget.card.isFlipped && oldWidget.card.isFlipped) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final isShowingFront = _flipAnimation.value < 0.5;

          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(_flipAnimation.value * 3.14159),
              child: Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: _getCardColor(),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: _getBorderColor(),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                    if (widget.card.isMatched)
                      BoxShadow(
                        color: widget.card.color.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                  ],
                ),
                child: isShowingFront ? _buildCardBack() : _buildCardFront(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1E3A8A).withOpacity(0.8),
            const Color(0xFF581C87).withOpacity(0.6),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.psychology,
          size: 24.sp,
          color: Colors.white.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildCardFront() {
    return Center(
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 300),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Icon(
              widget.card.icon,
              size: 32.sp,
              color: widget.card.color,
              shadows: widget.card.isMatched
                  ? [
                      Shadow(
                        color: Colors.white.withOpacity(0.6),
                        blurRadius: 10,
                      ),
                    ]
                  : null,
            ),
          );
        },
      ),
    );
  }

  Color _getCardColor() {
    if (widget.card.isMatched) {
      return const Color(0xFF312E81).withOpacity(0.7);
    } else if (widget.card.isFlipped) {
      return const Color(0xFF3730A3).withOpacity(0.7);
    } else {
      return const Color(0xFF1E1B4B).withOpacity(0.8);
    }
  }

  Color _getBorderColor() {
    if (widget.card.isMatched) {
      return widget.card.color.withOpacity(0.8);
    } else if (widget.card.isFlipped) {
      return const Color(0xFF6366F1).withOpacity(0.8);
    } else {
      return const Color(0xFF1E3A8A).withOpacity(0.6);
    }
  }
}

class WinAnimation extends StatefulWidget {
  const WinAnimation({super.key});

  @override
  State<WinAnimation> createState() => _WinAnimationState();
}

class _WinAnimationState extends State<WinAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              margin: EdgeInsets.only(top: 20.h),
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
                    '🎉 Congratulations! 🎈',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFD8B4FE),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'You found all the matches!',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xFFC7D2FE),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
