import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_trek_e/features/trek/presentation/view_model/review_view_model.dart';
import 'package:flutter_application_trek_e/features/trek/presentation/view_model/review_event.dart';
import 'package:flutter_application_trek_e/features/trek/presentation/view_model/review_state.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_trek_e/app/service_locator/service_locator.dart';
import 'package:flutter_application_trek_e/app/constant/api_endpoint.dart';

class ReviewView extends StatelessWidget {
  const ReviewView({super.key});

  /// Helper to ensure full image URL
  String _getFullImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return '';
    if (imageUrl.startsWith('http')) return imageUrl;
    return '${ApiEndpoints.serverAddress}$imageUrl';
  }

  /// Helper to format date relative to now
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else if (difference < 30) {
      final weeks = (difference / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }

  /// Helper to get star rating widget

@override
Widget build(BuildContext context) {
  return BlocProvider(
    create: (_) => serviceLocator<ReviewViewModel>()..add(LoadAllReviews()),
    child: Builder(
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: const Text(
              'Trek Reviews',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 0,
            shadowColor: Colors.black12,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search trek reviews...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      suffixIcon: Icon(Icons.search),
                    ),
                    onChanged: (query) {
                      context.read<ReviewViewModel>().add(SearchReviews(query));
                    },
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  context.read<ReviewViewModel>().add(LoadAllReviews());
                },
              ),
            ],
          ),
          body: BlocBuilder<ReviewViewModel, ReviewState>(
            builder: (context, state) {
              if (state is ReviewLoading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Loading trek reviews...',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ],
                  ),
                );
              } else if (state is ReviewError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text(
                        'Oops! Something went wrong',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Error: ${state.message}',
                        style: TextStyle(color: Colors.red[600], fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<ReviewViewModel>().add(LoadAllReviews());
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try Again'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is ReviewLoaded) {
                final treks = state.treks;
                if (treks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.rate_review_outlined, size: 80, color: Colors.grey[400]),
                        const SizedBox(height: 24),
                        Text(
                          'No Trek Reviews Yet',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.grey[800]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Be the first to share your trekking experience!',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ReviewViewModel>().add(LoadAllReviews());
                },
                child: ListView.builder(
                  itemCount: treks.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final trek = treks[index];
                    final reviews = trek.reviews ?? [];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Trek Header with Image
                          if (trek.imageUrl != null &&
                              trek.imageUrl!.isNotEmpty)
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                              child: Container(
                                height: 200,
                                width: double.infinity,
                                child: Stack(
                                  children: [
                                    Image.network(
                                      _getFullImageUrl(trek.imageUrl),
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (
                                        context,
                                        child,
                                        loadingProgress,
                                      ) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Container(
                                          height: 200,
                                          color: Colors.grey[200],
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.grey[400]!,
                                                  ),
                                            ),
                                          ),
                                        );
                                      },
                                      errorBuilder:
                                          (_, __, ___) => Container(
                                            height: 200,
                                            color: Colors.grey[200],
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.landscape_outlined,
                                                  size: 48,
                                                  color: Colors.grey[400],
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'Image not available',
                                                  style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                    ),
                                    // Gradient overlay
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: 80,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withOpacity(0.7),
                                            ],
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              trek.name,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          // Trek Title (if no image)
                          if (trek.imageUrl == null || trek.imageUrl!.isEmpty)
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.hiking,
                                    color: Colors.green[600],
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      trek.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // Reviews Section
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Reviews Header
                                Row(
                                  children: [
                                    Icon(
                                      Icons.rate_review,
                                      size: 20,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      reviews.isEmpty
                                          ? 'No Reviews Yet'
                                          : '${reviews.length} Review${reviews.length > 1 ? 's' : ''}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),

                                if (reviews.isEmpty) ...[
                                  const SizedBox(height: 16),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey[200]!,
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.chat_bubble_outline,
                                          size: 32,
                                          color: Colors.grey[400],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'No reviews available',
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Be the first to share your experience!',
                                          style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ] else ...[
                                  const SizedBox(height: 16),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: reviews.length,
                                    separatorBuilder:
                                        (_, __) => Container(
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          height: 1,
                                          color: Colors.grey[200],
                                        ),
                                    itemBuilder: (context, reviewIndex) {
                                      final review = reviews[reviewIndex];
                                      return Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Reviewer Header
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor:
                                                      Colors.blue[100],
                                                  child: Text(
                                                    review.username.isNotEmpty
                                                        ? review.username[0]
                                                            .toUpperCase()
                                                        : '?',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blue[700],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        review.username,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                      Text(
                                                        _formatDate(
                                                          review.date,
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Add rating stars if you have rating data
                                                // _buildStarRating(review.rating ?? 0),
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                            // Review Text
                                            Text(
                                              review.review,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                height: 1.4,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.hiking, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 24),
                    Text(
                      'Welcome to Trek Reviews',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Discover what fellow trekkers have to say',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
          },
        ),
      );
      },
    )
    );
  }
}
