import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/enums/risk_category.dart';

class RiskIndicator extends StatefulWidget {
  final RiskCategory category;
  final double size;

  const RiskIndicator({
    super.key,
    required this.category,
    this.size = 12,
  });

  @override
  State<RiskIndicator> createState() => _RiskIndicatorState();
}

class _RiskIndicatorState extends State<RiskIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController? _pulseController;
  Animation<double>? _pulseAnim;

  @override
  void initState() {
    super.initState();
    _setupPulse();
  }

  void _setupPulse() {
    if (widget.category == RiskCategory.high) {
      _pulseController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1500),
      );
      _pulseAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _pulseController!, curve: Curves.easeOut),
      );
      _pulseController!.repeat();
    }
  }

  @override
  void didUpdateWidget(RiskIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.category != widget.category) {
      _pulseController?.dispose();
      _pulseController = null;
      _pulseAnim = null;
      _setupPulse();
    }
  }

  @override
  void dispose() {
    _pulseController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.category == RiskCategory.high
        ? AppColors.highRisk
        : AppColors.lowRisk;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: widget.size + 6,
          height: widget.size + 6,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (_pulseAnim != null)
                  AnimatedBuilder(
                    animation: _pulseAnim!,
                    builder: (context, _) => Container(
                      width: widget.size +
                          (6 * _pulseAnim!.value),
                      height: widget.size +
                          (6 * _pulseAnim!.value),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: color.withAlpha(
                              (150 * (1 - _pulseAnim!.value)).toInt()),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          widget.category.label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: widget.size + 2,
          ),
        ),
      ],
    );
  }
}
