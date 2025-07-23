import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_adoption_app/core/config/app_colors.dart';
import 'package:pet_adoption_app/core/di/injection.dart';
import 'package:pet_adoption_app/domain/entities/pet.dart';
import 'package:pet_adoption_app/presentation/common_widgets/platform_aware_image.dart';
import 'package:pet_adoption_app/presentation/favorites/bloc/favorites_bloc.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  const PetCard({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return AnimatedPetCard(pet: pet, index: 0);
  }
}

class AnimatedPetCard extends StatefulWidget {
  final Pet pet;
  final int index;

  const AnimatedPetCard({
    super.key,
    required this.pet,
    required this.index,
  });

  @override
  State<AnimatedPetCard> createState() => _AnimatedPetCardState();
}

class _AnimatedPetCardState extends State<AnimatedPetCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(
          milliseconds: 300 + (widget.index * 50)), // Much faster animations
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2), // Reduced slide distance
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.1, 1.0, curve: Curves.easeOut), // Faster curve
    ));

    // Start animation with much smaller delay
    Future.delayed(Duration(milliseconds: widget.index * 50), () {
      if (mounted) _controller.forward();
    });

    // Load favorite status
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final favoritesBloc = getIt<FavoritesBloc>();
    final isFavorite = await favoritesBloc.isFavorite(widget.pet.id);
    if (mounted) {
      setState(() {
        _isFavorite = isFavorite;
      });
    }
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
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: GestureDetector(
                onTap: () => context.push('/details', extra: widget.pet),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.shadow,
                        blurRadius: 12,
                        spreadRadius: 0,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Card(
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        // Main content
                        Opacity(
                          opacity: widget.pet.isAdopted ? 0.6 : 1.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Responsive image container
                              Expanded(
                                flex: 3,
                                child: Stack(
                                  children: [
                                    // Responsive image
                                    Hero(
                                      tag: 'pet_image_${widget.pet.id}',
                                      child: Container(
                                        width: double.infinity,
                                        child: PlatformAwareImage(
                                          imageUrl: widget.pet.images.isNotEmpty
                                              ? widget.pet.images.first
                                              : 'https://via.placeholder.com/400x300?text=No+Photo',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),

                                    // Favorite button
                                    Positioned(
                                      top: 12,
                                      right: 12,
                                      child: GestureDetector(
                                        onTap: () async {
                                          final favoritesBloc =
                                              getIt<FavoritesBloc>();
                                          favoritesBloc.add(
                                              ToggleFavorite(widget.pet.id));

                                          setState(() {
                                            _isFavorite = !_isFavorite;
                                          });

                                          // Show a simple snackbar
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                _isFavorite
                                                    ? '${widget.pet.name} added to favorites!'
                                                    : '${widget.pet.name} removed from favorites!',
                                              ),
                                              duration:
                                                  const Duration(seconds: 2),
                                              backgroundColor: _isFavorite
                                                  ? AppColors.success
                                                  : Colors.grey[600],
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.9),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: theme.colorScheme.shadow,
                                                blurRadius: 6,
                                                spreadRadius: 0,
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            _isFavorite
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: AppColors.love,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Pet information section
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Pet name
                                      Text(
                                        widget.pet.name,
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.onSurface,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),

                                      // Pet breed
                                      Text(
                                        widget.pet.breed,
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          color: theme
                                              .colorScheme.onSurfaceVariant,
                                          fontSize: 11,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),

                                      // Age and size info - Using Flexible Row
                                      Flexible(
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: _buildInfoChip(
                                                context,
                                                '${widget.pet.age}yr',
                                                Icons.cake_outlined,
                                                AppColors.accent,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Flexible(
                                              child: _buildInfoChip(
                                                context,
                                                widget.pet.size.substring(
                                                    0, 1), // Just first letter
                                                Icons.straighten,
                                                AppColors.secondary,
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

                        // Adopted badge overlay
                        if (widget.pet.isAdopted)
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.success.withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Text(
                                'Adopted',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoChip(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 10,
            color: color,
          ),
          const SizedBox(width: 2),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}
