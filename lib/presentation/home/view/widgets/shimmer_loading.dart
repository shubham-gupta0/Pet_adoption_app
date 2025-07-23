import 'package:flutter/material.dart';

class ShimmerPetCard extends StatefulWidget {
  const ShimmerPetCard({super.key});

  @override
  State<ShimmerPetCard> createState() => _ShimmerPetCardState();
}

class _ShimmerPetCardState extends State<ShimmerPetCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
      ),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            margin: const EdgeInsets.only(bottom: 4), // Match PetCard margin
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image placeholder with shimmer
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceVariant
                                  .withOpacity(0.6),
                            ),
                          ),
                          // Beautiful shimmer effect - now properly clipped
                          Positioned(
                            top: 0,
                            bottom: 0,
                            left: _shimmerAnimation.value * 200 - 100,
                            child: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.transparent,
                                    theme.colorScheme.surface.withOpacity(0.8),
                                    theme.colorScheme.surface.withOpacity(0.4),
                                    Colors.transparent,
                                  ],
                                  stops: const [0.0, 0.3, 0.7, 1.0],
                                ),
                              ),
                            ),
                          ),
                          // Favorite button placeholder
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color:
                                    theme.colorScheme.surface.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(17),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Content placeholder
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name placeholder
                          Container(
                            width: 120,
                            height: 16,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceVariant
                                  .withOpacity(0.7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Breed placeholder
                          Container(
                            width: 90,
                            height: 12,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceVariant
                                  .withOpacity(0.5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Info chips placeholder
                          Flexible(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Container(
                                    width: 50,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surfaceVariant
                                          .withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Container(
                                    width: 35,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surfaceVariant
                                          .withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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

// Beautiful loading indicator for grid
class PetGridLoadingIndicator extends StatefulWidget {
  const PetGridLoadingIndicator({super.key});

  @override
  State<PetGridLoadingIndicator> createState() =>
      _PetGridLoadingIndicatorState();
}

class _PetGridLoadingIndicatorState extends State<PetGridLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                      blurRadius: 20 * _animation.value,
                      spreadRadius: 2 * _animation.value,
                    ),
                  ],
                ),
                child: Transform.scale(
                  scale: 0.8 + 0.2 * _animation.value,
                  child: Icon(
                    Icons.pets,
                    color: theme.colorScheme.onPrimary,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Finding adorable pets...',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
