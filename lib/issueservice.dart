part of issuelib;

class IssueService {
  
  Store store;
  
  IssueService(this.store);
  
  void createIssue(String title, String description, 
                   DateTime dueDate, IssueStatus status, String projectName) {
    
    if (!store.hasProject(projectName))
      throw new ArgumentError("Invalid projectId specified.");
      
    store.storeIssue(new Issue(
      title: title,
      description: description,
      dueDate: dueDate,
      status: status,
      projectName: projectName
    ));
  }
  
  // TODO: Make issue names unique within a project
}