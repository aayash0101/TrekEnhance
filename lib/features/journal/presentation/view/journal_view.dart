import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_trek_e/features/journal/presentation/view_model/journal_view_model.dart';

class JournalView extends StatefulWidget {
  const JournalView({Key? key}) : super(key: key);

  @override
  State<JournalView> createState() => _JournalViewState();
}

class _JournalViewState extends State<JournalView> {
  @override
  void initState() {
    super.initState();
    // Fetch all journals on page load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<JournalViewModel>(context, listen: false).fetchAllJournals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Journal Entries'),
      ),
      body: Consumer<JournalViewModel>(
        builder: (context, journalVM, _) {
          if (journalVM.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (journalVM.error != null) {
            return Center(child: Text('Error: ${journalVM.error}'));
          }

          if (journalVM.journals.isEmpty) {
            return const Center(child: Text('No journal entries found.'));
          }

          return ListView.builder(
            itemCount: journalVM.journals.length,
            itemBuilder: (context, index) {
              final journal = journalVM.journals[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User and trek info
                      Text(
                        'User: ${journal.user?.username ?? 'Unknown'}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Trek: ${journal.trek?.name ?? 'Unknown'}',
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Date
                      Text(
                        'Date: ${journal.date}',
                        style: const TextStyle(color: Colors.blueGrey),
                      ),

                      const SizedBox(height: 8),

                      // Journal text
                      Text(journal.text),

                      const SizedBox(height: 8),

                      // Photos if available
                      if (journal.photos.isNotEmpty)
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: journal.photos.length,
                            itemBuilder: (context, photoIndex) {
                              final photoUrl = journal.photos[photoIndex];
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Image.network(
                                  photoUrl,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.broken_image);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
