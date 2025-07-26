import 'package:flutter/material.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/trek_entity.dart';

class TrekDetailView extends StatelessWidget {
  final TrekEntity trek;

  const TrekDetailView({Key? key, required this.trek}) : super(key: key);

  String fixImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    return 'http://10.0.2.2:5000$url'; // same logic as before
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(trek.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (trek.imageUrl != null && trek.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  fixImageUrl(trek.imageUrl),
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
            const SizedBox(height: 16),
            Text(
              trek.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            if (trek.location != null)
              Text('Location: ${trek.location!}'),
            if (trek.difficulty != null)
              Text('Difficulty: ${trek.difficulty!}'),
            if (trek.distance != null)
              Text('Distance: ${trek.distance} km'),
            if (trek.bestSeason != null)
              Text('Best season: ${trek.bestSeason!}'),
            if (trek.smallDescription != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(trek.smallDescription!),
              ),
            if (trek.description != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(trek.description!),
              ),
            if (trek.highlights != null && trek.highlights!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text('Highlights:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...trek.highlights!.map((h) => Text('• $h')),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
