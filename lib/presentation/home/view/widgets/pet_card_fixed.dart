import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_adoption_app/core/config/app_colors.dart';
import 'package:pet_adoption_app/domain/entities/pet.dart';

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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 600 + (widget.index * 100)),
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
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
    ));

    // Start animation with delay based on index
    Future.delayed(Duration(milliseconds: widget.index * 150), () {
      if (mounted) _controller.forward();
    });
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
                                  child: CachedNetworkImage(
                                    imageUrl: widget.pet.images.isNotEmpty
                                        ? widget.pet.images.first
                                        : 'https://via.placeholder.com/400x300?text=No+Photo',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            theme.colorScheme.surfaceVariant,
                                            theme.colorScheme.surface,
                                          ],
                                        ),
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: theme.colorScheme.primary,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      color: theme.colorScheme.surfaceVariant,
                                      child: Icon(
                                        Icons.pets,
                                        size: 48,
                                        color:
                                            theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Adopted badge
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
                                          color: AppColors.success
                                              .withOpacity(0.3),
                                          blurRadius: 8,
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      'Adopted',
                                      style:
                                          theme.textTheme.labelSmall?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                              // Favorite button
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.colorScheme.shadow,
                                        blurRadius: 6,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.favorite_border,
                                    color: AppColors.love,
                                    size: 18,
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
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Pet name
                                Text(
                                  widget.pet.name,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),

                                // Pet breed
                                Text(
                                  widget.pet.breed,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),

                                // Age and size info
                                Row(
                                  children: [
                                    _buildInfoChip(
                                      context,
                                      '${widget.pet.age} ${widget.pet.age == 1 ? 'yr' : 'yrs'}',
                                      Icons.cake_outlined,
                                      AppColors.accent,
                                    ),
                                    const SizedBox(width: 8),
                                    _buildInfoChip(
                                      context,
                                      widget.pet.size,
                                      Icons.straighten,
                                      AppColors.secondary,
                                    ),
                                  ],
                                ),
                              ],
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
