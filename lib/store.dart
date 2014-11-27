part of issuelib;

abstract class Store {
  // Commands
  void storeIssue(Issue issue);
  void storeProject(Project project);
   
  // Queries
  List<Issue> getAllIssues();
  List<Project> getAllProjects();
  
  bool hasProject(int projectId);
  
}