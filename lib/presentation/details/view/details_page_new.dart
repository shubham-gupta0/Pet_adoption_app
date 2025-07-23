import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_adoption_app/core/di/injection.dart';
import 'package:pet_adoption_app/domain/entities/pet.dart';
import 'package:pet_adoption_app/presentation/details/cubit/details_cubit.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class DetailsPage extends StatefulWidget {
  final Pet pet;
  const DetailsPage({super.key, required this.pet});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _buttonController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _buttonScaleAnimation;

  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.elasticOut));

    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _buttonController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _showZoomableImage(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return Scaffold(
            backgroundColor: Colors.black.withOpacity(0.9),
            body: Stack(
              children: [
                PhotoViewGallery.builder(
                  itemCount: widget.pet.images.length,
                  builder: (context, index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: CachedNetworkImageProvider(
                        widget.pet.images[index],
                      ),
                      heroAttributes: PhotoViewHeroAttributes(
                        tag: 'pet_image_${widget.pet.id}_$index',
                      ),
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 2,
                    );
                  },
                  scrollPhysics: const BouncingScrollPhysics(),
                  backgroundDecoration:
                      const BoxDecoration(color: Colors.transparent),
                  pageController:
                      PageController(initialPage: _currentImageIndex),
                ),
                Positioned(
                  top: 50,
                  right: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close,
                          color: Colors.white, size: 24),
                      onPressed: () => Navigator.of(context).pop(),
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DetailsCubit>()..loadPetStatus(widget.pet),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            _buildContent(context),
            _buildConfetti(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildImageSection(context),
        _buildDetailsSection(context),
      ],
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.5,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      actions: [
        BlocBuilder<DetailsCubit, DetailsState>(
          builder: (context, state) {
            return Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  state.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: state.isFavorite ? Colors.red : Colors.black87,
                ),
                onPressed: () {
                  context.read<DetailsCubit>().toggleFavorite(widget.pet);
                },
              ),
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // Image carousel
            if (widget.pet.images.isNotEmpty)
              PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentImageIndex = index;
                  });
                },
                itemCount: widget.pet.images.length,
                itemBuilder: (context, index) {
                  return Hero(
                    tag: 'pet_image_${widget.pet.id}_$index',
                    child: GestureDetector(
                      onTap: () => _showZoomableImage(context),
                      child: CachedNetworkImage(
                        imageUrl: widget.pet.images[index],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child:
                              const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.pets, size: 80),
                        ),
                      ),
                    ),
                  );
                },
              ),

            // Gradient overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.8),
                      Theme.of(context).scaffoldBackgroundColor,
                    ],
                  ),
                ),
              ),
            ),

            // Image indicators
            if (widget.pet.images.length > 1)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.pet.images.asMap().entries.map((entry) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentImageIndex == entry.key ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: _currentImageIndex == entry.key
                            ? Colors.white
                            : Colors.white.withOpacity(0.4),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 24),
                  _buildInfoCards(context),
                  const SizedBox(height: 24),
                  _buildDescription(context),
                  const SizedBox(height: 24),
                  _buildContactInfo(context),
                  const SizedBox(height: 32),
                  _buildAdoptButton(context),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.pet.name,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.pet.breed,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.color
                              ?.withOpacity(0.7),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
            if (widget.pet.isAdopted)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: const Text(
                  'Adopted',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(
              Icons.location_on,
              color: Theme.of(context).primaryColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              widget.pet.location,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.color
                        ?.withOpacity(0.6),
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCards(BuildContext context) {
    final cards = [
      _InfoCard(
        icon: Icons.cake,
        title: 'Age',
        value: '${widget.pet.age} ${widget.pet.age == 1 ? 'year' : 'years'}',
        color: Colors.orange,
      ),
      _InfoCard(
        icon: widget.pet.gender == 'Male' ? Icons.male : Icons.female,
        title: 'Gender',
        value: widget.pet.gender,
        color: widget.pet.gender == 'Male' ? Colors.blue : Colors.pink,
      ),
      _InfoCard(
        icon: Icons.straighten,
        title: 'Size',
        value: widget.pet.size,
        color: Colors.purple,
      ),
      _InfoCard(
        icon: Icons.palette,
        title: 'Color',
        value: widget.pet.color,
        color: Colors.teal,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 600 + (index * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cards[index].color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: cards[index].color.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      cards[index].icon,
                      color: cards[index].color,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cards[index].title,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.color
                                ?.withOpacity(0.6),
                            fontSize: 12,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cards[index].value,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: cards[index].color,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About ${widget.pet.name}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.pet.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.color
                      ?.withOpacity(0.8),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.email,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                widget.pet.contactEmail ?? 'No email provided',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.phone,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                widget.pet.contactPhone ?? 'No phone provided',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdoptButton(BuildContext context) {
    return BlocBuilder<DetailsCubit, DetailsState>(
      builder: (context, state) {
        return ScaleTransition(
          scale: _buttonScaleAnimation,
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: widget.pet.isAdopted
                    ? [Colors.grey, Colors.grey[600]!]
                    : [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.8)
                      ],
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.pet.isAdopted
                      ? Colors.grey.withOpacity(0.3)
                      : Theme.of(context).primaryColor.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: widget.pet.isAdopted
                  ? null
                  : () {
                      _buttonController.forward().then((_) {
                        _buttonController.reverse();
                      });
                      context.read<DetailsCubit>().adoptPet(widget.pet);
                      _confettiController.play();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                widget.pet.isAdopted
                    ? 'Already Adopted'
                    : 'Adopt ${widget.pet.name}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildConfetti() {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: _confettiController,
        blastDirection: pi / 2,
        maxBlastForce: 5,
        minBlastForce: 2,
        emissionFrequency: 0.05,
        numberOfParticles: 50,
        gravity: 0.1,
        shouldLoop: false,
        colors: const [
          Colors.green,
          Colors.blue,
          Colors.pink,
          Colors.orange,
          Colors.purple,
        ],
      ),
    );
  }
}

class _InfoCard {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });
}
