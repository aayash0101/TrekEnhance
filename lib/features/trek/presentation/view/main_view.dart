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

class _MainViewState extends State<MainView> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  String? _userId;
  bool _isLoading = true;
  late List<Widget> _pages;
  late ShakeDetector _shakeDetector;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;
  bool _isShakeTooltipVisible = false;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeView(),
      const JournalView(),
      const ReviewView(),
      const SizedBox(), // placeholder for UserProfileView
    ];
    _fetchuserId();
    
    // Initialize FAB animation controller
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );
    
    // Initialize shake detector with synchronous callback
    _shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: _handleShakeLogout,
    );

    // Show shake tooltip after a delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _showShakeTooltip();
      }
    });
  }

  @override
  void dispose() {
    _shakeDetector.stopListening();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _showShakeTooltip() {
    if (!_isShakeTooltipVisible) {
      setState(() {
        _isShakeTooltipVisible = true;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.vibration,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Shake your device to logout quickly!',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.teal[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
        ),
      );
      
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isShakeTooltipVisible = false;
          });
        }
      });
    }
  }

  Future<void> _fetchuserId() async {
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
        _fabAnimationController.forward();
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
    _showLogoutConfirmation();
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.vibration,
                color: Colors.teal[600],
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text(
                'Shake Detected!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'Do you want to logout from your account?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performLogout() async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal[600]!),
              ),
              const SizedBox(height: 16),
              const Text(
                'Logging out...',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      },
    );

    final logoutUsecase = serviceLocator<UserLogoutUsecase>();
    try {
      await logoutUsecase();
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login', // Adjust the route name to your login screen
          (route) => false,
        );
      }
    } catch (e) {
      print('Logout failed: $e');
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Text('Logout failed, please try again'),
              ],
            ),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.teal[600]!),
                      strokeWidth: 3,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Loading TrekEnhance...',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Preparing your adventure',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_userId == null) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 20),
                Text(
                  'Failed to Load User',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Unable to authenticate your account',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login',
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.login),
                  label: const Text('Go to Login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: Colors.teal[600],
              unselectedItemColor: Colors.grey[400],
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              items: [
                BottomNavigationBarItem(
                  icon: _buildNavIcon(Icons.home_outlined, Icons.home, 0),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavIcon(Icons.book_outlined, Icons.book, 1),
                  label: 'Journals',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavIcon(Icons.rate_review_outlined, Icons.rate_review, 2),
                  label: 'Reviews',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavIcon(Icons.person_outline, Icons.person, 3),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton(
          onPressed: _showShakeTooltip,
          backgroundColor: Colors.teal[600],
          foregroundColor: Colors.white,
          elevation: 8,
          child: const Icon(
            Icons.vibration,
            size: 24,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildNavIcon(IconData outlinedIcon, IconData filledIcon, int index) {
    final isSelected = _selectedIndex == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.teal[50] : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        isSelected ? filledIcon : outlinedIcon,
        size: 24,
      ),
    );
  }
}