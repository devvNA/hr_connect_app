import 'package:flutter/material.dart';

class SkeletonShimmer extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
  });

  @override
  State<SkeletonShimmer> createState() => _SkeletonShimmerState();
}

class _SkeletonShimmerState extends State<SkeletonShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // 1. Setup Controller: Durasi menentukan seberapa cepat kilauan bergerak
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(); // .repeat() membuat animasi looping terus menerus

    // 2. Setup Animasi: Nilai bergerak dari -2 (kiri jauh) ke 2 (kanan jauh)
    // Rentang ini memastikan gradien lewat sepenuhnya dari layar
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 3. Warna Skeleton (bisa disesuaikan dengan tema)
    final baseColor = Colors.grey[300]!;
    final highlightColor = Colors.grey[100]!;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            // 4. Inti dari Shimmer: LinearGradient yang bergerak
            gradient: LinearGradient(
              begin: Alignment(_animation.value, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: [baseColor, highlightColor, baseColor],
              // Stops mengatur seberapa lebar 'kilauan' putih di tengah
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}
