import 'package:flutter/material.dart';

class StudentProgressWidget extends StatelessWidget {
  const StudentProgressWidget({super.key});

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
              'Student Progress Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildProgressItem(
              'John Doe',
              'Ewondo Basics',
              0.75,
              Colors.green,
            ),
            const SizedBox(height: 12),
            _buildProgressItem(
              'Jane Smith',
              'Bulu Grammar',
              0.60,
              Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildProgressItem(
              'Bob Johnson',
              'Fang Vocabulary',
              0.45,
              Colors.red,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to detailed student progress
              },
              child: const Text('View All Students'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItem(
    String studentName,
    String courseName,
    double progress,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              studentName,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          courseName,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }
}