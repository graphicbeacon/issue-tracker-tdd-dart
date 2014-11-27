part of issuelib;

class IssueService {
  
  var store;
  
  IssueService(this.store);
  
  void createIssue(String title, String description, 
                   DateTime dueDate, IssueStatus status, int projectId) {
    
    if (!store.hasProject(projectId))
      throw new ArgumentError("Invalid projectId specified.");
      
    
    store.storeIssue(new Issue(
      title: title,
      description: description,
      dueDate: dueDate,
      status: status,
      projectId: projectId
    ));
  }
}