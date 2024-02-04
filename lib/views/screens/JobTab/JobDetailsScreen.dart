import 'package:flutter/material.dart';
import 'package:uum_career_advisor_app/models/job.dart';

class JobDetailsPage extends StatelessWidget {
  final Job job;

  const JobDetailsPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Job Details"),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                job.title,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              SizedBox(height: 8),
              Text(
                job.company,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              _buildDetailSection(
                  "Position/Title", Icons.work_outline, job.title),
              _buildDetailSection("Location", Icons.location_on, job.location),
              _buildDetailSection(
                  "Salary Range", Icons.monetization_on, job.salaryRange),
              SizedBox(height: 16),
              _buildHeader("Job Description"),
              Text(
                job.description,
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 20),
              _buildHeader("Skills Required"),
              Wrap(
                spacing: 8.0,
                children: job.skillsRequired
                    .map((skill) => Chip(label: Text(skill)))
                    .toList(),
              ),
              SizedBox(height: 20),
              _buildHeader("Employee Review"),
              Text(
                job.employeeReview,
                style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, IconData icon, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: Colors.blueGrey),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              detail,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey),
      ),
    );
  }
}
