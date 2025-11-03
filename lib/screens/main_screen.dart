import 'package:flutter/material.dart';
import 'package:vivofit/components/bottom_nav_bar.dart';
import 'package:vivofit/screens/home/home_screen.dart';
import 'package:vivofit/screens/nutrition/nutrition_screen.dart';
import 'package:vivofit/screens/blog/blog_screen.dart';
import 'package:vivofit/screens/profile/profile_screen.dart';

/// Pantalla principal con Bottom Navigation Bar
/// Contiene las 4 pantallas principales: Home, Nutrición, Blog, Perfil
class MainScreen extends StatefulWidget {
  final int? initialTab;

  const MainScreen({super.key, this.initialTab});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;
  late final PageController _pageController;

  final List<Widget> _screens = const [
    HomeScreen(),
    NutritionScreen(),
    BlogScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab ?? 0;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
