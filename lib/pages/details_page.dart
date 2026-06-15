import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  Widget infoCard(String title, String description, IconData icon) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue, size: 35),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text('Metric Details'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            infoCard(
              'CPU Usage',
              'Shows how much processor power your system is currently using.',
              Icons.memory,
            ),
            infoCard(
              'Available RAM',
              'Shows how much memory is free and available on your system.',
              Icons.storage,
            ),
            infoCard(
              'Disk Usage',
              'Shows how much storage is used in your C drive.',
              Icons.folder,
            ),
            infoCard(
              'Prometheus API',
              'Flutter fetches live system metrics from Prometheus using HTTP requests.',
              Icons.api,
            ),
          ],
        ),
      ),
    );
  }
}