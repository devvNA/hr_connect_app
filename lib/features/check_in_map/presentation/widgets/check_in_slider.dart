import 'package:flutter/material.dart';
import 'package:hr_connect/core/theme/app_color.dart';
import 'package:hr_connect/core/theme/app_theme.dart';

class CheckInSlider extends StatefulWidget {
  final VoidCallback onConfirm;
  final bool enabled;
  final bool isLoading;

  const CheckInSlider({
    super.key,
    required this.onConfirm,
    this.enabled = true,
    this.isLoading = false,
  });

  @override
  State<CheckInSlider> createState() => _CheckInSliderState();
}

class _CheckInSliderState extends State<CheckInSlider> {
  double _dragPosition = 0;
  bool _confirmed = false;
  static const double _thumbSize = 56;

  static const double _padding = 4;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.enabled && !widget.isLoading && !_confirmed;
    final bgColor = isActive
        ? AppColors.primary
        : AppColors.textSecondary.withValues(alpha: 0.3);

    return Container(
      height: _thumbSize + (_padding * 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.fullRadius,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxDrag = constraints.maxWidth - _thumbSize - (_padding * 2);

          return Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Label
              Center(
                child: widget.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        _confirmed ? 'Confirmed!' : 'Slide to Check In',
                        style: AppTypography.button.copyWith(
                          color: Colors.white.withValues(
                            alpha: _confirmed ? 1.0 : 0.8,
                          ),
                          letterSpacing: 0.5,
                        ),
                      ),
              ),

              // Draggable thumb
              Positioned(
                left: _padding + _dragPosition,
                top: _padding,
                child: GestureDetector(
                  onHorizontalDragUpdate: isActive
                      ? (details) {
                          setState(() {
                            _dragPosition = (_dragPosition + details.delta.dx)
                                .clamp(0.0, maxDrag);
                          });
                        }
                      : null,
                  onHorizontalDragEnd: isActive
                      ? (details) {
                          if (_dragPosition >= maxDrag * 0.85) {
                            setState(() {
                              _dragPosition = maxDrag;
                              _confirmed = true;
                            });
                            widget.onConfirm();
                          } else {
                            setState(() => _dragPosition = 0);
                          }
                        }
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: _thumbSize,
                    height: _thumbSize,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      _confirmed ? Icons.check : Icons.fingerprint,
                      color: isActive
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
