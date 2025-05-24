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
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1F1C4D),
            Color(0xFF272454),
          ],
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
              shadows: [
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
          );
        },
      ),
    );
  }

  Color _getCardColor() {
    if (widget.card.isMatched) {
      return const Color(0xFF362D74);
    } else if (widget.card.isFlipped) {
      return const Color(0xFF2F257E);
    } else {
      return const Color(0xFF1E1B4B);
    }
  }

  Color _getBorderColor() {
    if (widget.card.isMatched) {
      return const Color(0xFF5858B2);
    } else if (widget.card.isFlipped) {
      return const Color(0xFF6366F1);
    } else {
      return const Color(0xFF1E3A8A);
    }
  }
}
