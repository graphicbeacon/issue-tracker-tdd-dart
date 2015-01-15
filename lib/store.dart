part of issuelib;

abstract class Store {
  // Commands
  void storeIssue(Issue issue);
  void storeProject(Project project);
  void storeUser(User user);
  
  // Queries
  List<Issue> getAllIssues();
  List<Project> getAllProjects();
  
  bool hasProject(String projectName);
}