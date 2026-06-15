import 'package:flutter/material.dart';
import '../services/prometheus_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    urlController.text = PrometheusService.baseUrl;
  }

  void saveUrl() {
    PrometheusService.baseUrl = urlController.text.trim();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Prometheus URL updated')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: urlController,
              decoration: const InputDecoration(
                labelText: 'Prometheus Base URL',
                hintText: 'http://192.168.0.169:9090',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveUrl,
                child: const Text('Save URL'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}