part of issuelib;

class IssueService {
  
  var store;
  
  IssueService(this.store);
  
  void createIssue(String title, String description, 
                   DateTime dueDate, IssueStatus status) {
    
    store.storeIssue(new Issue(
      title: title,
      description: description,
      dueDate: dueDate,
      status: status
    ));
  }
}