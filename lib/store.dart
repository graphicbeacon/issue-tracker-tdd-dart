part of issuelib;

abstract class Store {
  // Commands
  void storeIssue(Issue issue);
  void storeProject(Project project);
  void storeUser(User user);
  void storeUserSession(UserSession userSession);
  void deleteUserSession(String sessionToken);
  
  // Queries
  List<Issue> getAllIssues();
  List<Project> getAllProjects();
  User getUser(String username);
  
  bool hasProject(String projectName);
  bool hasUser(String username);
}