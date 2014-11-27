part of issuelib;

class IssueBoardService {
  var issueStore;
  
  IssueBoardService(this.issueStore);
  
  IssueBoard getAllIssues() {
    var issues = issueStore.getAllIssues();
    
    issues.sort((a,b) => b.dueDate.compareTo(a.dueDate));
    
    return new IssueBoard(issues);
  }
  
  IssueBoard getIssuesByName(String name) {
    List<Issue> issues = issueStore.getAllIssues();
    var issueFilter = issues.where((Issue issue) => issue.title.contains(name));
    
    return new IssueBoard(issueFilter.toList());
  }
  
}