import 'package:flutter/material.dart';
import 'package:flutter_application_trek_e/app/service_locator/service_locator.dart';
import 'package:flutter_application_trek_e/features/home/presentation/view_model/home_event.dart';
import 'package:flutter_application_trek_e/features/home/presentation/view_model/home_state.dart';
import 'package:flutter_application_trek_e/features/home/presentation/view_model/home_view_model.dart';
import 'package:flutter_application_trek_e/features/home/domain/repository/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeViewModel(
        serviceLocator<IHomeRepository>(), // use interface
      )..add(LoadTreks()), // trigger load on start
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Treks'),
          centerTitle: true,
        ),
        body: BlocBuilder<HomeViewModel, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeLoaded) {
              return ListView.builder(
                itemCount: state.treks.length,
                itemBuilder: (context, index) {
                  final trek = state.treks[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(8),
                      leading: trek.imageUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                'http://localhost:5000${trek.imageUrl}',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.landscape, size: 40, color: Colors.grey),
                      title: Text(
                        trek.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        trek.location ?? 'Unknown location',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              );
            } else if (state is HomeError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else {
              return const Center(child: Text('Welcome to TrekEnhance'));
            }
          },
        ),
      ),
    );
  }
}
