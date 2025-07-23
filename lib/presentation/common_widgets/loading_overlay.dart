import 'package:flutter/material.dart';
import 'package:pet_adoption_app/core/config/app_colors.dart';

class AppLoadingOverlay extends StatefulWidget {
  final bool isVisible;
  final String message;

  const AppLoadingOverlay({
    super.key,
    required this.isVisible,
    this.message = 'Loading pets...',
  });

  @override
  State<AppLoadingOverlay> createState() => _AppLoadingOverlayState();
}

class _AppLoadingOverlayState extends State<AppLoadingOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    if (widget.isVisible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AppLoadingOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return const SizedBox();

    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            color: theme.colorScheme.surface.withOpacity(0.95),
            child: Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: const EdgeInsets.all(32),
                  margin: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.shadow.withOpacity(0.2),
                        blurRadius: 24,
                        spreadRadius: 0,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Animated paw icons
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: Stack(
                          children: [
                            _buildAnimatedPaw(
                              delay: 0,
                              offset: const Offset(10, 5),
                              color: AppColors.primary,
                            ),
                            _buildAnimatedPaw(
                              delay: 200,
                              offset: const Offset(30, 15),
                              color: AppColors.secondary,
                            ),
                            _buildAnimatedPaw(
                              delay: 400,
                              offset: const Offset(15, 35),
                              color: AppColors.accent,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Loading text
                      Text(
                        widget.message,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),

                      Text(
                        'Finding the perfect pets for you...',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      // Progress indicator
                      SizedBox(
                        width: 100,
                        child: LinearProgressIndicator(
                          backgroundColor: theme.colorScheme.surfaceVariant,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedPaw({
    required int delay,
    required Offset offset,
    required Color color,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final delayedAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Interval(
            delay / 1000.0,
            (delay + 500) / 1000.0,
            curve: Curves.elasticOut,
          ),
        ));

        return Positioned(
          left: offset.dx,
          top: offset.dy,
          child: Transform.scale(
            scale: delayedAnimation.value,
            child: Icon(
              Icons.pets,
              size: 16,
              color: color.withOpacity(0.8),
            ),
          ),
        );
      },
    );
  }
}

// Loading overlay for initial app loading
class InitialLoadingScreen extends StatefulWidget {
  const InitialLoadingScreen({super.key});

  @override
  State<InitialLoadingScreen> createState() => _InitialLoadingScreenState();
}

class _InitialLoadingScreenState extends State<InitialLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App logo with animation
                ScaleTransition(
                  scale: _logoAnimation,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 24,
                          spreadRadius: 0,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.pets,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // App title
                FadeTransition(
                  opacity: _textAnimation,
                  child: Text(
                    'Pet Adoption',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                FadeTransition(
                  opacity: _textAnimation,
                  child: Text(
                    'Find your perfect companion',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // Loading indicator
                FadeTransition(
                  opacity: _textAnimation,
                  child: SizedBox(
                    width: 120,
                    child: LinearProgressIndicator(
                      backgroundColor: theme.colorScheme.surfaceVariant,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
