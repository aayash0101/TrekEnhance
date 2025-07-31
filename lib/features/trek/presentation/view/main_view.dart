import 'package:flutter/material.dart';
import 'package:flutter_application_trek_e/features/home/presentation/view/home_view.dart';
import 'package:flutter_application_trek_e/features/journal/presentation/view/journal_view.dart';
import 'package:flutter_application_trek_e/features/profile/presentation/view/user_profile_view.dart';
import 'package:flutter_application_trek_e/app/service_locator/service_locator.dart';
import 'package:flutter_application_trek_e/features/auth/domain/use_case/user_get_current_usecase.dart';
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

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeView(),
      const JournalView(),
      const ReviewView(), // use default constructor, BlocProvider handles usecase inside
      const SizedBox(), // placeholder, will replace with UserProfileView when userId loads
    ];
    _fetchCurrentUserId();
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

          // Now this works because _pages is mutable
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_userId == null) {
      return const Scaffold(
        body: Center(child: Text('Failed to load user')),
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Journals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.reviews),
            label: 'Reviews',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
