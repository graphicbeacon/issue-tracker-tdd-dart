library issuelib;

class Issue {
  
  String title;
  String description;
  DateTime dueDate;
  IssueStatus status;
  
  Issue({String this.title: "", 
    String this.description: "", 
    DateTime this.dueDate, 
    IssueStatus this.status});
  
}

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

abstract class IssueStore {
   void store(Issue issue);
   
   List<Issue> getAllIssues();
}

class IssueStatus {
  int state;
  
  IssueStatus.opened() {
    this.state = 1;
  }
  
  IssueStatus.closed() {
    this.state = 0;    
  }
  
  IssueStatus.inProgress() {
    this.state = 2;
  }
  
}

class IssueBoard {
  List<Issue> issues;
  
  IssueBoard(this.issues);
}

class IssueBoardService {
  var issueStore;
  
  IssueBoardService(this.issueStore);
  
  IssueBoard getAllIssues() {
    var issues = issueStore.getAllIssues();
    
    issues.sort((a,b) => b.dueDate.compareTo(a.dueDate));
    
    return new IssueBoard(issues);
  }
  
}