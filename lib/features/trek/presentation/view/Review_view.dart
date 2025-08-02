import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_trek_e/features/trek/presentation/view_model/review_view_model.dart';
import 'package:flutter_application_trek_e/features/trek/presentation/view_model/review_event.dart';
import 'package:flutter_application_trek_e/features/trek/presentation/view_model/review_state.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_trek_e/app/service_locator/service_locator.dart';
import 'package:flutter_application_trek_e/app/constant/api_endpoint.dart'; // ✅ import your endpoint

class ReviewView extends StatelessWidget {
  const ReviewView({super.key});

  /// Helper to ensure full image URL
  String _getFullImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return '';
    if (imageUrl.startsWith('http')) return imageUrl;
    return '${ApiEndpoints.serverAddress}$imageUrl';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<ReviewViewModel>()..add(LoadAllReviews()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('All Treks & Reviews'),
        ),
        body: BlocBuilder<ReviewViewModel, ReviewState>(
          builder: (context, state) {
            if (state is ReviewLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ReviewError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is ReviewLoaded) {
              final treks = state.treks;

              if (treks.isEmpty) {
                return const Center(child: Text('No treks found.'));
              }

              return ListView.builder(
                itemCount: treks.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final trek = treks[index];
                  final reviews = trek.reviews ?? [];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Trek title
                          Text(
                            trek.name,
                            style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Show image if exists
                          if (trek.imageUrl != null && trek.imageUrl!.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                _getFullImageUrl(trek.imageUrl),
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Text('Image not available'),
                              ),
                            ),
                          const SizedBox(height: 8),
                          // Reviews or "No reviews"
                          if (reviews.isEmpty)
                            const Text(
                              'No reviews',
                              style: TextStyle(color: Colors.grey),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: reviews.length,
                              separatorBuilder: (_, __) => const Divider(height: 12),
                              itemBuilder: (context, reviewIndex) {
                                final review = reviews[reviewIndex];
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: CircleAvatar(
                                    child: Text(
                                      review.username.isNotEmpty
                                          ? review.username[0].toUpperCase()
                                          : '?',
                                    ),
                                  ),
                                  title: Text(review.username),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(review.review),
                                      Text(
                                        DateFormat('MMM d, yyyy').format(review.date),
                                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const SizedBox(); // Initial or unknown state
            }
          },
        ),
      ),
    );
  }
}
