import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../view_model/home_view_model.dart';
import '../view_model/home_event.dart';
import '../view_model/home_state.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeViewModel()..add(LoadHomeData()),
      child: Scaffold(
        appBar: AppBar(title: Text('TrekEnhance')),
        body: BlocBuilder<HomeViewModel, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is HomeLoaded) {
              return ListView.builder(
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return Card(
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      leading: Image.asset(item.imageUrl, width: 60, fit: BoxFit.cover),
                      title: Text(item.title),
                      subtitle: Text(item.description),
                    ),
                  );
                },
              );
            } else if (state is HomeError) {
              return Center(child: Text(state.message));
            } else {
              return Center(child: Text('Welcome to TrekEnhance'));
            }
          },
        ),
      ),
    );
  }
}
