part of issuelib;

class IssueBoardService {
  
  Store store;
  
  IssueBoardService(this.store);
  
  IssueBoard getAllIssues(PageInfo pageInfo) {
    if (pageInfo == null) throw new ArgumentError("PageInfo is mandatory");
    
    var issues = store.getAllIssues();
    
    
    issues.sort((a,b) => b.dueDate.compareTo(a.dueDate));
    
    return new IssueBoard(pageInfo, #getAllIssues, [], 
            issues.skip(pageInfo.skipCount).take(pageInfo.pageSize).toList());
  }
  
  IssueBoard getIssuesByName(String name, PageInfo pageInfo) {
    if (name == null || name.isEmpty) throw new ArgumentError("Name is mandatory");
    if (pageInfo == null) throw new ArgumentError("PageInfo is mandatory");
    
    List<Issue> issues = store.getAllIssues();
    var issueFilter = issues.where((Issue issue) => issue.title.contains(name));
    
    return new IssueBoard(pageInfo, #getIssuesByName, [name], 
            issueFilter.skip(pageInfo.skipCount).take(pageInfo.pageSize).toList());
  }
  
  IssueBoard getIssuesByProjectName(String projectName, PageInfo pageInfo) {
    if (projectName == null || projectName.isEmpty) throw new ArgumentError("Project name is mandatory");
    if (pageInfo == null) throw new ArgumentError("PageInfo is mandatory");
    
    Project project = store
        .getAllProjects()
        .singleWhere((Project project) => project.name.toLowerCase() == projectName.toLowerCase());
    
    List<Issue> issues = store
        .getAllIssues()
        .where((Issue issue) => issue.projectName == project.name)
        .toList();
    
    return new IssueBoard(pageInfo, #getIssuesByProjectName, [projectName], 
            issues.skip(pageInfo.skipCount).take(pageInfo.pageSize).toList());
  }
}