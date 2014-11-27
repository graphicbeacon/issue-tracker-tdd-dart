part of issuelib;

abstract class Store {
  // Commands
  void storeIssue(Issue issue);
  void storeProject(Project project);
   
  // Queries
  List<Issue> getAllIssues();
  
  bool hasProject(int projectId);
  
}