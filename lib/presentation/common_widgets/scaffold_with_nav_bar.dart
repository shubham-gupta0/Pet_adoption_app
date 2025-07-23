import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 16,
              offset: const Offset(0, -2),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: HeroIcon(HeroIcons.home),
                activeIcon:
                    HeroIcon(HeroIcons.home, style: HeroIconStyle.solid),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: HeroIcon(HeroIcons.heart),
                activeIcon:
                    HeroIcon(HeroIcons.heart, style: HeroIconStyle.solid),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: HeroIcon(HeroIcons.clock),
                activeIcon:
                    HeroIcon(HeroIcons.clock, style: HeroIconStyle.solid),
                label: 'History',
              ),
            ],
            currentIndex: navigationShell.currentIndex,
            onTap: _onTap,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: theme.colorScheme.primary,
            unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.6),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            iconSize: 24,
          ),
        ),
      ),
    );
  }

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
