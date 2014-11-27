part of issuelib;

abstract class Store {
  // Commands
  void storeIssue(Issue issue);
  void storeProject(Project project);
   
  // Queries
  List<Project> getAllProjects();
  List<Issue> getAllIssues();
}