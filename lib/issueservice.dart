part of issuelib;

class IssueService {
  
  var issueStore;
  
  IssueService(this.issueStore);
  
  void createIssue(String title, String description, 
                   DateTime dueDate, IssueStatus status) {
    
    issueStore.store(new Issue(
      title: title,
      description: description,
      dueDate: dueDate,
      status: status
    ));
  }
}