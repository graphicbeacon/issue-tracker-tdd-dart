part of issuelib;



class IssueBoardService {
  var issueStore;
  
  IssueBoardService(this.issueStore);
  
  IssueBoard getAllIssues() {
    var issues = issueStore.getAllIssues();
    
    issues.sort((a,b) => b.dueDate.compareTo(a.dueDate));
    
    return new IssueBoard(issues);
  }
  
}