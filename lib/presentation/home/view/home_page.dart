import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_adoption_app/core/config/app_colors.dart';
import 'package:pet_adoption_app/core/di/injection.dart';
import 'package:pet_adoption_app/presentation/home/bloc/home_bloc.dart';
import 'package:pet_adoption_app/presentation/home/view/widgets/pet_card.dart';
import 'package:pet_adoption_app/presentation/home/view/widgets/search_bar.dart';
import 'package:pet_adoption_app/presentation/home/view/widgets/shimmer_loading.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _homeBloc = getIt<HomeBloc>()..add(const FetchPets());

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _homeBloc.close();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _homeBloc.add(const FetchPets());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;

    return BlocProvider.value(
      value: _homeBloc,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: RefreshIndicator(
                onRefresh: () async {
                  // Use the stored bloc reference
                  _homeBloc.add(const FetchPets(isRefresh: true));

                  // Wait for the bloc to complete the refresh
                  await _homeBloc.stream.firstWhere(
                    (state) => state is! HomeLoading,
                    orElse: () => HomeInitial(),
                  );
                },
                color: Theme.of(context).primaryColor,
                backgroundColor: Colors.white,
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 190.0,
                      floating: true,
                      pinned: false,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.primaryGradient.colors.first
                                    .withOpacity(0.1),
                                AppColors.secondaryGradient.colors.first
                                    .withOpacity(0.05),
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 20, 24, 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Find Your',
                                  style:
                                      theme.textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.w300,
                                    color: theme.colorScheme.onBackground
                                        .withOpacity(0.8),
                                    fontSize: 26,
                                  ),
                                ),
                                Text(
                                  'Perfect Companion',
                                  style:
                                      theme.textTheme.headlineLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 30,
                                    height: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const HomeSearchBar(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                    BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) {
                        if (state is HomeLoading && state.props.isEmpty) {
                          return SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            sliver: SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: 0.75,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  return const ShimmerPetCard();
                                },
                                childCount: 8, // Show 8 shimmer cards
                              ),
                            ),
                          );
                        }
                        if (state is HomeLoaded) {
                          if (state.filteredPets.isEmpty) {
                            return SliverFillRemaining(
                              child: Container(
                                padding: const EdgeInsets.all(32),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.pets,
                                      size: 80,
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.3),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No pets found',
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                        color: theme.colorScheme.onSurface,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Try adjusting your search criteria',
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onSurface
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            sliver: SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: 0.75,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  if (index >= state.filteredPets.length) {
                                    return const SizedBox.shrink();
                                  }
                                  final pet = state.filteredPets[index];
                                  // Use optimized animation delays to prevent long loading times
                                  final optimizedIndex =
                                      index % 6; // Cycle every 6 items
                                  return AnimatedPetCard(
                                      pet: pet, index: optimizedIndex);
                                },
                                childCount: state.filteredPets.length,
                              ),
                            ),
                          );
                        }
                        if (state is HomeError) {
                          return SliverFillRemaining(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 80,
                                    color: theme.colorScheme.error,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Oops! Something went wrong',
                                    style:
                                        theme.textTheme.headlineSmall?.copyWith(
                                      color: theme.colorScheme.error,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SelectableText(
                                    state.message,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.7),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () {
                                      _homeBloc.add(const FetchPets());
                                    },
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return const SliverToBoxAdapter(
                            child: SizedBox.shrink());
                      },
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 40)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
