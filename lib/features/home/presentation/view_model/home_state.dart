import 'package:flutter/material.dart';
import 'package:flutter_application_trek_e/features/home/presentation/view/bottom_view/dashboard_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class HomeState {
  final int selectedIndex;
  final List<Widget> views;

  const HomeState({required this.selectedIndex, required this.views});

  // Initial state
  static HomeState initial() {
    return HomeState(
      selectedIndex: 0,
      views: [
        Dashboard(),
       
      ],
    );
  }

  HomeState copyWith({int? selectedIndex, List<Widget>? views}) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      views: views ?? this.views,
    );
  }
}