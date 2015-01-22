part of issuelib;

abstract class Store {
  // Commands
  Future storeIssue(Issue issue);
  Future storeProject(Project project);
  Future storeUser(User user);
  Future storeUserSession(UserSession userSession);
  Future deleteUserSession(String sessionToken);
    
  // Queries
  Future<List<Issue>> getAllIssues();
  Future<List<Project>> getAllProjects();
  Future<Issue> getIssue(String id);
  Future<User> getUser(String username);
  Future<UserSession> getUserSession(String sessionToken);

  Future<bool> hasIssue(String id);
  Future<bool> hasProject(String projectName);
  Future<bool> hasUser(String username);
  Future<bool> hasUserSession(String sessionToken);
}