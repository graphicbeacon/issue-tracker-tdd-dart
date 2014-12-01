part of issuelib;

class IssueBoardService {
  
  Store store;
  
  IssueBoardService(this.store);
  
  IssueBoard getAllIssues() {
    var issues = store.getAllIssues();
    
    issues.sort((a,b) => b.dueDate.compareTo(a.dueDate));
    
    return new IssueBoard(issues);
  }
  
  IssueBoard getIssuesByName(String name) {
    List<Issue> issues = store.getAllIssues();
    var issueFilter = issues.where((Issue issue) => issue.title.contains(name));
    
    return new IssueBoard(issueFilter.toList());
  }
  
  IssueBoard getIssuesByProjectName(String projectName) {
    Project project = store
        .getAllProjects()
        .singleWhere((Project project) => project.name.toLowerCase() == projectName.toLowerCase());
    
    List<Issue> issues = store
        .getAllIssues()
        .where((Issue issue) => issue.projectName == project.name)
        .toList();
    
    return new IssueBoard(issues);
  }
  
}