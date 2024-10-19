import 'package:cinemana/core/presentation/extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavbar extends StatefulWidget {
  const ScaffoldWithNavbar({
    super.key,
    required this.child,
    required this.location,
  });

  final Widget child;
  final String location;

  @override
  State<ScaffoldWithNavbar> createState() => _ScaffoldWithNavbarState();
}

class _ScaffoldWithNavbarState extends State<ScaffoldWithNavbar> {
  int _currentIndex = 0;

  final destinations = [
    const CustomNavigationDestination(
      icon: Icon(Icons.home),
      selectedIcon: Icon(Icons.home_filled),
      label: 'HOME',
      initialLocation: '/',
    ),
    const CustomNavigationDestination(
      icon: Icon(Icons.search),
      selectedIcon: Icon(Icons.search),
      label: 'SEARCH',
      initialLocation: '/searchMedias',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          if (context.isDesktop || context.isTablet)
            SizedBox(
              width: 75,
              child: NavigationRail(
                selectedIndex: _currentIndex,
                labelType: NavigationRailLabelType.selected,
                selectedLabelTextStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
                onDestinationSelected: onDestinationSelected,
                destinations: destinations
                    .map((e) => e.getNavigationRailDestination())
                    .toList(),
              ),
            ),
          Expanded(child: SafeArea(child: widget.child)),
        ],
      ),
      bottomNavigationBar: !context.isPhone
          ? null
          : NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: onDestinationSelected,
              destinations: destinations
                  .map((e) => e.getNavigationDestination())
                  .toList(),
            ),
    );
  }

  void onDestinationSelected(int index) {
    GoRouter router = GoRouter.of(context);
    String location = destinations[index].initialLocation;

    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
    }
    router.go(location);
  }
}

// NavigationDestination
class CustomNavigationDestination {
  const CustomNavigationDestination({
    required this.initialLocation,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final String initialLocation;
  final String label;
  final Icon icon;
  final Icon selectedIcon;

  Widget getNavigationDestination() {
    return NavigationDestination(
      label: label,
      selectedIcon: selectedIcon,
      icon: icon,
    );
  }

  NavigationRailDestination getNavigationRailDestination() {
    return NavigationRailDestination(
      icon: icon,
      selectedIcon: selectedIcon,
      label: Text(label),
    );
  }
}
