import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:gym_management_app/core/theming/app_color_manager.dart';

/// A reusable animated mascot widget that slides in from the side and waves hello.
/// Supports Lottie animations for realistic character animations.
class WavingMascot extends StatefulWidget {
  /// The welcome message to display
  final String message;

  /// Duration for the slide-in animation
  final Duration animationDuration;

  /// How long to show the mascot before auto-hiding (null = don't auto-hide)
  final Duration? autoHideDuration;

  /// Callback when mascot is tapped
  final VoidCallback? onTap;

  /// Callback when mascot is dismissed
  final VoidCallback? onDismiss;

  /// Custom background color for the message bubble
  final Color? bubbleColor;

  /// Custom text style for the message
  final TextStyle? messageStyle;

  /// Show a close button
  final bool showDismissButton;

  /// Position from top (as a fraction of screen height, 0.0 - 1.0)
  final double topPosition;

  /// Which side to appear from
  final MascotPosition position;

  /// Lottie animation asset path (e.g., 'assets/animations/waving.json')
  /// If null, uses built-in animated character
  final String? lottieAsset;

  /// Network URL for Lottie animation
  final String? lottieUrl;

  /// Width of the mascot/animation
  final double mascotWidth;

  /// Height of the mascot/animation
  final double mascotHeight;

  const WavingMascot({
    super.key,
    this.message = 'مرحباً! 👋',
    this.animationDuration = const Duration(milliseconds: 800),
    this.autoHideDuration = const Duration(seconds: 5),
    this.onTap,
    this.onDismiss,
    this.bubbleColor,
    this.messageStyle,
    this.showDismissButton = true,
    this.topPosition = 0.15,
    this.position = MascotPosition.right,
    this.lottieAsset,
    this.lottieUrl,
    this.mascotWidth = 120,
    this.mascotHeight = 150,
  });

  @override
  State<WavingMascot> createState() => _WavingMascotState();
}

class _WavingMascotState extends State<WavingMascot>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();

    if (widget.autoHideDuration != null) {
      Future.delayed(widget.autoHideDuration!, _hideMascot);
    }
  }

  void _initAnimations() {
    _slideController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    final slideDirection = widget.position == MascotPosition.right ? 1.0 : -1.0;

    _slideAnimation =
        Tween<Offset>(
          begin: Offset(slideDirection * 1.5, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
        );
  }

  void _startAnimations() {
    _slideController.forward();
  }

  void _hideMascot() {
    if (!_isVisible) return;
    _slideController.reverse().then((_) {
      if (mounted) {
        setState(() => _isVisible = false);
        widget.onDismiss?.call();
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();

    final isRight = widget.position == MascotPosition.right;

    return Positioned(
      top: MediaQuery.of(context).size.height * widget.topPosition,
      right: isRight ? 0 : null,
      left: isRight ? null : 0,
      child: SlideTransition(
        position: _slideAnimation,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Message bubble
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                margin: EdgeInsets.only(
                  right: isRight ? 0 : 8,
                  left: isRight ? 8 : 0,
                ),
                decoration: BoxDecoration(
                  // color: widget.bubbleColor ?? Theme.of(context).primaryColor,
                  gradient: AppColorManager.primaryLinearGradient,

                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: Radius.circular(isRight ? 20 : 4),
                    bottomRight: Radius.circular(isRight ? 4 : 20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        widget.message,
                        style:
                            widget.messageStyle ??
                            const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                    if (widget.showDismissButton) ...[
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _hideMascot,
                        child: const Icon(
                          Icons.close,
                          color: Colors.white70,
                          size: 18,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Mascot - Lottie or Built-in
              _buildMascot(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMascot() {
    // If Lottie asset or URL is provided, use it
    if (widget.lottieAsset != null) {
      return SizedBox(
        width: widget.mascotWidth,
        height: widget.mascotHeight,
        child: Lottie.asset(widget.lottieAsset!, fit: BoxFit.contain),
      );
    }

    if (widget.lottieUrl != null) {
      return SizedBox(
        width: widget.mascotWidth,
        height: widget.mascotHeight,
        child: Lottie.network(widget.lottieUrl!, fit: BoxFit.contain),
      );
    }

    // Otherwise, use built-in animated character
    return _buildBuiltInMascot();
  }

  Widget _buildBuiltInMascot() {
    return SizedBox(
      width: widget.mascotWidth,
      height: widget.mascotHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Character body
          Positioned(
            bottom: 0,
            left: 10,
            child: _BuiltInCharacter(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Built-in animated character for when no Lottie is provided
class _BuiltInCharacter extends StatefulWidget {
  final Color color;

  const _BuiltInCharacter({required this.color});

  @override
  State<_BuiltInCharacter> createState() => _BuiltInCharacterState();
}

class _BuiltInCharacterState extends State<_BuiltInCharacter>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _waveAnimation = Tween<double>(begin: -0.4, end: 0.4).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 140,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Body (torso)
          Positioned(
            bottom: 0,
            left: 20,
            child: Container(
              width: 60,
              height: 70,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                  bottom: Radius.circular(15),
                ),
              ),
            ),
          ),

          // Head
          Positioned(
            top: 0,
            left: 15,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFFFFDBAC), // Skin color
                shape: BoxShape.circle,
                border: Border.all(color: widget.color, width: 3),
              ),
              child: Stack(
                children: [
                  // Hair
                  Positioned(
                    top: -5,
                    left: 5,
                    right: 5,
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A3728),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(35),
                        ),
                      ),
                    ),
                  ),

                  // Eyes
                  Positioned(
                    top: 28,
                    left: 18,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xFF333333),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 28,
                    right: 18,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xFF333333),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  // Smile
                  Positioned(
                    bottom: 15,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 25,
                        height: 12,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: const Color(0xFFE57373),
                              width: 3,
                            ),
                          ),
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Waving arm
          Positioned(
            top: 50,
            right: -15,
            child: AnimatedBuilder(
              animation: _waveAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _waveAnimation.value,
                  alignment: Alignment.bottomLeft,
                  child: child,
                );
              },
              child: Column(
                children: [
                  // Hand waving
                  Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDBAC),
                      shape: BoxShape.circle,
                      border: Border.all(color: widget.color, width: 2),
                    ),
                    child: const Center(
                      child: Text('✋', style: TextStyle(fontSize: 14)),
                    ),
                  ),
                  // Arm
                  Container(
                    width: 12,
                    height: 35,
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Position enum for the mascot
enum MascotPosition { left, right }

/// A wrapper widget to easily add the mascot to any screen
class WavingMascotOverlay extends StatelessWidget {
  final Widget child;
  final String message;
  final bool showMascot;
  final VoidCallback? onMascotTap;
  final VoidCallback? onMascotDismiss;
  final Duration? autoHideDuration;
  final MascotPosition position;
  final String? lottieAsset;
  final String? lottieUrl;

  const WavingMascotOverlay({
    super.key,
    required this.child,
    this.message = 'مرحباً! 👋',
    this.showMascot = true,
    this.onMascotTap,
    this.onMascotDismiss,
    this.autoHideDuration = const Duration(seconds: 5),
    this.position = MascotPosition.right,
    this.lottieAsset,
    this.lottieUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (showMascot)
          WavingMascot(
            message: message,
            onTap: onMascotTap,
            onDismiss: onMascotDismiss,
            autoHideDuration: autoHideDuration,
            position: position,
            lottieAsset: lottieAsset,
            lottieUrl: lottieUrl,
          ),
      ],
    );
  }
}
