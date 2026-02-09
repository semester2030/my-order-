import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

class JobCountdownTimer extends StatefulWidget {
  final DateTime expiresAt;

  const JobCountdownTimer({
    super.key,
    required this.expiresAt,
  });

  @override
  State<JobCountdownTimer> createState() => _JobCountdownTimerState();
}

class _JobCountdownTimerState extends State<JobCountdownTimer> {
  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        _updateRemaining();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateRemaining() {
    final now = DateTime.now();
    if (widget.expiresAt.isAfter(now)) {
      setState(() {
        _remaining = widget.expiresAt.difference(now);
      });
    } else {
      setState(() {
        _remaining = Duration.zero;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_remaining.isNegative || _remaining == Duration.zero) {
      return const SizedBox.shrink();
    }

    final minutes = _remaining.inMinutes;
    final seconds = _remaining.inSeconds % 60;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Insets.sm,
        vertical: Insets.xs,
      ),
      decoration: BoxDecoration(
        color: SemanticColors.warningContainer,
        borderRadius: AppRadius.smAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer,
            size: IconSizes.sm,
            color: SemanticColors.warning,
          ),
          Gaps.xsH,
          Text(
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: TextStyles.labelMedium.copyWith(
              color: SemanticColors.warning,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
