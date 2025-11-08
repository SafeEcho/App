import 'package:flutter/material.dart';

/// Botón de acción grande y colorido
class ActionButton extends StatefulWidget {
  final String label;
  final String emoji;
  final Color color;
  final VoidCallback? onPressed;

  const ActionButton({
    super.key,
    required this.label,
    required this.emoji,
    required this.color,
    this.onPressed,
  });

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: isEnabled ? (_) => _scaleController.forward() : null,
        onTapUp: isEnabled ? (_) => _scaleController.reverse() : null,
        onTapCancel: isEnabled ? () => _scaleController.reverse() : null,
        onTap: widget.onPressed,
        child: Container(
          height: 75,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isEnabled
                  ? [
                      widget.color,
                      widget.color.withOpacity(0.8),
                    ]
                  : [
                      const Color(0xFFE0E0E0),
                      const Color(0xFFBDBDBD),
                    ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isEnabled
                  ? widget.color.withOpacity(0.3)
                  : const Color(0xFFBDBDBD),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: isEnabled
                    ? widget.color.withOpacity(0.3)
                    : const Color(0xFF9E9E9E).withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.emoji,
                style: TextStyle(
                  fontSize: 28,
                  color: isEnabled ? Colors.white : const Color(0xFF9E9E9E),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: isEnabled ? Colors.white : const Color(0xFF9E9E9E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
