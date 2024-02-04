import 'package:flutter/material.dart';
import 'package:uum_career_advisor_app/models/job.dart';
import 'package:uum_career_advisor_app/models/mock_jobs.dart';
import 'package:uum_career_advisor_app/models/user.dart';
import 'JobDetailsScreen.dart';

class JobTabScreen extends StatefulWidget {
  final User user;

  const JobTabScreen({super.key, required this.user});

  @override
  _JobTabScreenState createState() => _JobTabScreenState();
}

class _JobTabScreenState extends State<JobTabScreen> {
  List<Job> jobs = getMockJobs(); // Your mock jobs data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Job Listings"),
        backgroundColor: Colors.blueGrey,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: JobSearchDelegate(jobs, _navigateToJobDetails),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          return _buildJobItem(jobs[index]);
        },
      ),
    );
  }

  Widget _buildJobItem(Job job) {
    return Card(
      child: ListTile(
        title: Text(job.title),
        subtitle: Text("${job.company} - ${job.location}"),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () => _navigateToJobDetails(job),
      ),
    );
  }

  void _navigateToJobDetails(Job job) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JobDetailsPage(job: job)),
    );
  }
}

class JobSearchDelegate extends SearchDelegate<Job?> {
  final List<Job> jobs;
  final Function(Job) navigateToJobDetails;
  JobSearchDelegate(this.jobs, this.navigateToJobDetails);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Filter the jobs list based on the search query
    List<Job> filteredJobs = jobs.where((job) {
      return job.title.toLowerCase().contains(query.toLowerCase()) ||
          job.company.toLowerCase().contains(query.toLowerCase()) ||
          job.location.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: filteredJobs.length,
      itemBuilder: (context, index) {
        final Job job = filteredJobs[index];
        return ListTile(
          title: Text(job.title),
          subtitle: Text("${job.company} - ${job.location}"),
          onTap: () {
            close(context, job);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show some suggestions based on the current query
    List<Job> suggestedJobs = query.isEmpty
        ? []
        : jobs.where((job) {
            return job.title.toLowerCase().contains(query.toLowerCase()) ||
                job.company.toLowerCase().contains(query.toLowerCase()) ||
                job.location.toLowerCase().contains(query.toLowerCase());
          }).toList();

    return ListView.builder(
      itemCount: suggestedJobs.length,
      itemBuilder: (context, index) {
        final Job job = suggestedJobs[index];
        return ListTile(
          title: Text(suggestedJobs[index].title),
          subtitle: Text("${job.company} - ${job.location}"),
          onTap: () {
            navigateToJobDetails(suggestedJobs[index]);
          },
        );
      },
    );
  }
}
