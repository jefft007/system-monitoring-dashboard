import 'package:flutter/material.dart';
import '../services/prometheus_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double cpuUsage = 0;
  double memoryAvailable = 0;
  double diskUsage = 0;

  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchMetrics();
  }

  Future<void> fetchMetrics() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final cpu = await PrometheusService.fetchValue(
        '100 - (avg(rate(windows_cpu_time_total{mode="idle"}[5m])) * 100)',
      );

      final memory = await PrometheusService.fetchValue(
        'windows_memory_available_bytes / 1024 / 1024 / 1024',
      );

      final disk = await PrometheusService.fetchValue(
        '100 - ((windows_logical_disk_free_bytes{volume="C:"} / windows_logical_disk_size_bytes{volume="C:"}) * 100)',
      );

      setState(() {
        cpuUsage = cpu;
        memoryAvailable = memory;
        diskUsage = disk;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch data. Check Prometheus and IP.';
        isLoading = false;
      });
    }
  }

  Widget percentageCard(String title, double value, IconData icon) {
    final safeValue = value.clamp(0, 100).toDouble();

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, size: 35, color: Colors.blue),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: safeValue),
                  duration: const Duration(seconds: 1),
                  builder: (context, animatedValue, child) {
                    return Text(
                      '${animatedValue.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 15),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: safeValue / 100),
              duration: const Duration(seconds: 1),
              builder: (context, progressValue, child) {
                return LinearProgressIndicator(
                  value: progressValue,
                  minHeight: 12,
                  borderRadius: BorderRadius.circular(10),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget memoryCard() {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            const Icon(Icons.storage, size: 35, color: Colors.blue),
            const SizedBox(width: 15),
            const Expanded(
              child: Text(
                'Available RAM',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              '${memoryAvailable.toStringAsFixed(2)} GB',
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget drawerMenu() {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Server Monitor',
              style: TextStyle(color: Colors.white, fontSize: 26),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () => Navigator.pushNamed(context, '/'),
          ),
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('Details'),
            onTap: () => Navigator.pushNamed(context, '/details'),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawerMenu(),
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: fetchMetrics,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchMetrics,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (isLoading) const CircularProgressIndicator(),

              if (errorMessage.isNotEmpty)
                Text(errorMessage, style: const TextStyle(color: Colors.red)),

              percentageCard('CPU Usage', cpuUsage, Icons.memory),
              memoryCard(),
              percentageCard('Disk Usage', diskUsage, Icons.folder),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/details'),
                child: const Text('View Details'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}