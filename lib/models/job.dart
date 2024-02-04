class Job {
  final String id;
  final String title;
  final String company;
  final String location;
  final String salaryRange;
  final String description;
  final List<String> skillsRequired;
  final String employeeReview;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.salaryRange,
    required this.description,
    required this.skillsRequired,
    required this.employeeReview,
  });
}
