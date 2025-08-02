import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
import 'package:flutter_application_trek_e/features/home/presentation/view/home_view.dart';
import 'package:flutter_application_trek_e/features/journal/presentation/view/journal_view.dart';
import 'package:flutter_application_trek_e/features/profile/presentation/view/user_profile_view.dart';
import 'package:flutter_application_trek_e/app/service_locator/service_locator.dart';
import 'package:flutter_application_trek_e/features/auth/domain/use_case/user_get_current_usecase.dart';
import 'package:flutter_application_trek_e/features/auth/domain/use_case/user_logout_usecase.dart';
import 'package:flutter_application_trek_e/features/trek/presentation/view/review_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;
  String? _userId;
  bool _isLoading = true;
  late List<Widget> _pages;
  late ShakeDetector _shakeDetector;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeView(),
      const JournalView(),
      const ReviewView(),
      const SizedBox(), // placeholder for UserProfileView
    ];
    _fetchCurrentUserId();
    
    // Initialize shake detector with synchronous callback
    _shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: _handleShakeLogout,
    );
  }

  @override
  void dispose() {
    _shakeDetector.stopListening();
    super.dispose();
  }

  Future<void> _fetchCurrentUserId() async {
    final userGetCurrentUsecase = serviceLocator<UserGetCurrentUsecase>();
    final result = await userGetCurrentUsecase();
    result.fold(
      (failure) {
        setState(() {
          _userId = null;
          _isLoading = false;
        });
      },
      (userEntity) {
        setState(() {
          _userId = userEntity.userId;
          _isLoading = false;
          _pages[_pages.length - 1] = UserProfileView(userId: _userId!);
        });
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Synchronous shake handler that accepts ShakeEvent parameter
  void _handleShakeLogout(ShakeEvent event) {
    _performLogout(); // Fire-and-forget async call
  }

  Future<void> _performLogout() async {
    final logoutUsecase = serviceLocator<UserLogoutUsecase>();
    try {
      await logoutUsecase();
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login', // Adjust the route name to your login screen
          (route) => false,
        );
      }
    } catch (e) {
      print('Logout failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logout failed, try again')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_userId == null) {
      return const Scaffold(body: Center(child: Text('Failed to load user')));
    }

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Add this to show all 4 tabs
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color.fromARGB(255, 16, 10, 141),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Journals'),
          BottomNavigationBarItem(icon: Icon(Icons.reviews), label: 'Reviews'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}