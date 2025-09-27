import 'package:flutter/material.dart';

class AdminStatsWidget extends StatelessWidget {
  const AdminStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'System Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatItem(
                  context,
                  'Total Users',
                  '2,847',
                  Icons.people,
                  Colors.blue,
                ),
                const SizedBox(width: 16),
                _buildStatItem(
                  context,
                  'Active Sessions',
                  '456',
                  Icons.online_prediction,
                  Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatItem(
                  context,
                  'Total Revenue',
                  '\$12,456',
                  Icons.attach_money,
                  Colors.amber,
                ),
                const SizedBox(width: 16),
                _buildStatItem(
                  context,
                  'Server Uptime',
                  '99.9%',
                  Icons.cloud_done,
                  Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            _buildActivityItem('New user registration', '2 minutes ago'),
            _buildActivityItem('Payment processed', '5 minutes ago'),
            _buildActivityItem('Content updated', '12 minutes ago'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String activity, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              activity,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}