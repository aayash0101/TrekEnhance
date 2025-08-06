import 'package:flutter/material.dart';
import 'package:flutter_application_trek_e/app/service_locator/service_locator.dart';
import 'package:flutter_application_trek_e/features/auth/domain/repository/user_repository.dart';
import 'package:flutter_application_trek_e/features/auth/domain/use_case/user_get_current_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/entity/journal_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_trek_e/app/constant/api_endpoint.dart';
import 'package:flutter_application_trek_e/features/journal/presentation/view_model/journal_view_model.dart';
import 'package:flutter_application_trek_e/features/journal/presentation/view_model/journal_event.dart';
import 'package:flutter_application_trek_e/features/journal/presentation/view_model/journal_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JournalView extends StatefulWidget {
  const JournalView({Key? key}) : super(key: key);

  @override
  State<JournalView> createState() => _JournalViewState();
}

class _JournalViewState extends State<JournalView> {
  final TextEditingController _searchController = TextEditingController();
  String? _userId;

  String get userId => _userId ?? '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserId();
    });

    _searchController.addListener(() {
      final query = _searchController.text;
      context.read<JournalViewModel>().add(FilterJournals(query));
    });
  }

  Future<void> _loadUserId() async {
    final usecase = UserGetCurrentUsecase(userRepository: serviceLocator<IUserRepository>());

    final result = await usecase();

    result.fold(
      (failure) {
        print("❌ Failed to get current user: ${failure.toString()}");
      },
      (user) {
        final userId = user.userId;
        print("✅ Got userId: $userId");

        if (userId != null && userId.isNotEmpty) {
          setState(() {
            _userId = userId;
          });
          context.read<JournalViewModel>().add(FetchAllJournals(userId));
        } else {
          print("❌ User ID is null or empty, cannot load journals");
        }
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatDate(String date) {
    try {
      final DateTime parsedDate = DateTime.parse(date);
      final now = DateTime.now();
      final difference = now.difference(parsedDate).inDays;

      if (difference == 0) {
        return 'Today';
      } else if (difference == 1) {
        return 'Yesterday';
      } else if (difference < 7) {
        return '$difference days ago';
      } else {
        return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
      }
    } catch (e) {
      return date;
    }
  }

  String _getFullImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return '';
    if (imageUrl.startsWith('http')) return imageUrl;
    return '${ApiEndpoints.serverAddress}$imageUrl';
  }

  void _handleSaveJournal(dynamic journal) {
    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 16),
              Text('Please log in to save journals'),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    context.read<JournalViewModel>().add(
      ToggleSaveJournal(journalId: journal.id!, userId: userId),
    );
  }

  void _handleFavoriteJournal(dynamic journal) {
    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 16),
              Text('Please log in to favorite journals'),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    context.read<JournalViewModel>().add(
      ToggleFavoriteJournal(journalId: journal.id!, userId: userId),
    );
  }

  bool _isSaving(String journalId, JournalState state) {
    return state is JournalSavingSavingState && state.journalId == journalId;
  }

  bool _isFavoriting(String journalId, JournalState state) {
    return state is JournalFavoritingState && state.journalId == journalId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search journals...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.grey[200],
            filled: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          ),
        ),
        centerTitle: false,
      ),
      body: BlocConsumer<JournalViewModel, JournalState>(
        listener: (context, state) {
          print('🔄 DEBUG: State changed to: ${state.runtimeType}');
          
          if (state is JournalLoaded) {
            print('✅ DEBUG: JournalLoaded - ${state.journals.length} total journals, ${state.filteredJournals.length} filtered');
          }
          
          if (state is JournalError) {
            print('❌ DEBUG: JournalError - ${state.message}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.white),
                    const SizedBox(width: 16),
                    Expanded(child: Text(state.message)),
                  ],
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          print('🏗️ DEBUG: Building with state: ${state.runtimeType}');
          
          if (state is JournalLoading) {
            print('⏳ DEBUG: Showing loading state');
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
                    'Loading journal entries...',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is JournalError) {
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
                    style: TextStyle(
                      color: Colors.red[600],
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<JournalViewModel>().add(ClearError());
                      _loadUserId();
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
          }

          List<JournalEntity> journals = [];
          if (state is JournalLoaded) {
            journals = state.filteredJournals;
          } else if (state is JournalSavingSavingState && state.previousState is JournalLoaded) {
            journals = (state.previousState as JournalLoaded).filteredJournals;
          } else if (state is JournalFavoritingState && state.previousState is JournalLoaded) {
            journals = (state.previousState as JournalLoaded).filteredJournals;
          }

          if (journals.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 24),
                  Text(
                    'No Journal Entries Found',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try a different search query or add new journals!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await _loadUserId();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: journals.length,
              itemBuilder: (context, index) {
                final journal = journals[index];
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
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with user, date, and action buttons
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blue[100],
                              radius: 20,
                              child: Icon(Icons.person, color: Colors.blue[700], size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    journal.user?.username ?? 'Unknown User',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    _formatDate(journal.date),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Action buttons - Simple and responsive
                            Row(
                              children: [
                                // Save button
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onTap: _isSaving(journal.id!, state) 
                                        ? null 
                                        : () => _handleSaveJournal(journal),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: _isSaving(journal.id!, state)
                                          ? SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                  Colors.orange,
                                                ),
                                              ),
                                            )
                                          : Icon(
                                              journal.isSaved ? Icons.bookmark : Icons.bookmark_border,
                                              color: journal.isSaved ? Colors.orange : Colors.grey[600],
                                              size: 24,
                                            ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Favorite button
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onTap: _isFavoriting(journal.id!, state) 
                                        ? null 
                                        : () => _handleFavoriteJournal(journal),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: _isFavoriting(journal.id!, state)
                                          ? SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                  Colors.red,
                                                ),
                                              ),
                                            )
                                          : Icon(
                                              journal.isFavorite ? Icons.favorite : Icons.favorite_border,
                                              color: journal.isFavorite ? Colors.red : Colors.grey[600],
                                              size: 24,
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Trek info
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green[200]!, width: 1),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.hiking, size: 16, color: Colors.green[700]),
                              const SizedBox(width: 8),
                              Text(
                                journal.trek?.name ?? 'Unknown Trek',
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Journal content
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            journal.text,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              color: Colors.black87,
                            ),
                          ),
                        ),

                        // Photos section
                        if (journal.photos.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Icon(Icons.photo_library_outlined, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 8),
                              Text(
                                '${journal.photos.length} Photo${journal.photos.length > 1 ? 's' : ''}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: journal.photos.length,
                              itemBuilder: (context, photoIndex) {
                                final photoUrl = journal.photos[photoIndex];
                                return Container(
                                  margin: const EdgeInsets.only(right: 12),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      width: 120,
                                      height: 120,
                                      color: Colors.grey[200],
                                      child: Image.network(
                                        _getFullImageUrl(photoUrl),
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                Colors.grey[400]!,
                                              ),
                                            ),
                                          );
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.broken_image_outlined,
                                                  color: Colors.grey[400],
                                                  size: 32,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Failed to load',
                                                  style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}