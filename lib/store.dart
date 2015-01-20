part of issuelib;

abstract class Store {
  // Commands
  void storeIssue(Issue issue);
  void storeProject(Project project);
  void storeUser(User user);
  void storeUserSession(UserSession userSession);
  void deleteUserSession(String sessionToken);
  void updateIssue(String id, Issue issue);
    
  // Queries
  List<Issue> getAllIssues();
  List<Project> getAllProjects();
  Issue getIssue(String id);
  User getUser(String username);
  UserSession getUserSession(String sessionToken);

  bool hasIssue(String id);
  bool hasProject(String projectName);
  bool hasUser(String username);
  bool hasUserSession(String sessionToken);
}