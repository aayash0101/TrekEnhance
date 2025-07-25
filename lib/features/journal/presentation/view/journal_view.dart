import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_trek_e/features/journal/domain/entity/journal_entity.dart';
import 'package:flutter_application_trek_e/features/journal/presentation/view_model/journal_view_model.dart';

class JournalView extends StatefulWidget {
  final String trekId;
  final String userId;

  const JournalView({Key? key, required this.trekId, required this.userId}) : super(key: key);

  @override
  _JournalViewState createState() => _JournalViewState();
}

class _JournalViewState extends State<JournalView> {
  @override
  void initState() {
    super.initState();
    final journalVM = context.read<JournalViewModel>();
    journalVM.fetchJournalsByTrekAndUser(widget.trekId, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journals'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // TODO: open create journal form
              _showJournalForm(context);
            },
          ),
        ],
      ),
      body: Consumer<JournalViewModel>(
        builder: (context, journalVM, _) {
          if (journalVM.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (journalVM.error != null) {
            return Center(child: Text('Error: ${journalVM.error}'));
          }

          final journals = journalVM.journals;

          if (journals.isEmpty) {
            return Center(child: Text('No journals found.'));
          }

          return ListView.builder(
            itemCount: journals.length,
            itemBuilder: (context, index) {
              final journal = journals[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(journal.text),
                  subtitle: Text('Date: ${journal.date}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // TODO: open edit form with journal data
                          _showJournalForm(context, journal: journal);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirmed = await _confirmDelete(context);
                          if (confirmed) {
                            await journalVM.deleteJournal(journal.id);
                          }
                        },
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

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Delete Journal'),
            content: Text('Are you sure you want to delete this journal?'),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text('Cancel')),
              TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text('Delete')),
            ],
          ),
        ) ??
        false;
  }

  void _showJournalForm(BuildContext context, {JournalEntity? journal}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: JournalForm(
            trekId: widget.trekId,
            userId: widget.userId,
            existingJournal: journal,
          ),
        );
      },
    );
  }
}

class JournalForm extends StatefulWidget {
  final String trekId;
  final String userId;
  final JournalEntity? existingJournal;

  const JournalForm({
    Key? key,
    required this.trekId,
    required this.userId,
    this.existingJournal,
  }) : super(key: key);

  @override
  State<JournalForm> createState() => _JournalFormState();
}

class _JournalFormState extends State<JournalForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dateController;
  late TextEditingController _textController;
  List<String> _photos = [];

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(text: widget.existingJournal?.date ?? '');
    _textController = TextEditingController(text: widget.existingJournal?.text ?? '');
    _photos = widget.existingJournal?.photos ?? [];
  }

  @override
  void dispose() {
    _dateController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingJournal != null;
    final journalVM = context.read<JournalViewModel>();

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(isEditing ? 'Edit Journal' : 'New Journal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),

            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
              validator: (val) => val == null || val.isEmpty ? 'Please enter date' : null,
            ),

            SizedBox(height: 12),

            TextFormField(
              controller: _textController,
              decoration: InputDecoration(labelText: 'Journal Text'),
              maxLines: 4,
              validator: (val) => val == null || val.isEmpty ? 'Please enter journal text' : null,
            ),

            SizedBox(height: 12),

            // For simplicity, photos input as comma separated URLs
            TextFormField(
              initialValue: _photos.join(', '),
              decoration: InputDecoration(labelText: 'Photos (comma separated URLs)'),
              onChanged: (val) {
                _photos = val.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
              },
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  if (isEditing) {
                    await journalVM.updateJournal(
                      id: widget.existingJournal!.id,
                      date: _dateController.text,
                      text: _textController.text,
                      photos: _photos,
                    );
                  } else {
                    await journalVM.createJournal(
                      userId: widget.userId,
                      trekId: widget.trekId,
                      date: _dateController.text,
                      text: _textController.text,
                      photos: _photos,
                    );
                  }
                  Navigator.of(context).pop();
                }
              },
              child: Text(isEditing ? 'Update' : 'Create'),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
