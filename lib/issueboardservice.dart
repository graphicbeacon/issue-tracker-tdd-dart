part of issuelib;

class IssueBoardService {
  
  Store store;
  
  IssueBoardService(this.store);
  
  IssueBoard getAllIssues(PageInfo pageInfo) {
    var issues = store.getAllIssues();
    
    issues.sort((a,b) => b.dueDate.compareTo(a.dueDate));
    
    return pageInfo != null 
        ? new IssueBoard.withPaging(pageInfo, #getAllIssues, [], issues.take(pageInfo.pageSize).toList())
        : new IssueBoard(issues);
  }
  
  IssueBoard getIssuesByName(String name, PageInfo pageInfo) {
    List<Issue> issues = store.getAllIssues();
    var issueFilter = issues.where((Issue issue) => issue.title.contains(name));
    
    return pageInfo != null 
        ? new IssueBoard.withPaging(pageInfo, #getIssuesByName, [name], issueFilter.take(pageInfo.pageSize).toList())
        : new IssueBoard(issueFilter.toList());
  }
  
  IssueBoard getIssuesByProjectName(String projectName, PageInfo pageInfo) {
    Project project = store
        .getAllProjects()
        .singleWhere((Project project) => project.name.toLowerCase() == projectName.toLowerCase());
    
    List<Issue> issues = store
        .getAllIssues()
        .where((Issue issue) => issue.projectName == project.name)
        .toList();
    
    return pageInfo != null
        ? new IssueBoard.withPaging(pageInfo, #getIssuesByProjectName, [projectName], issues.take(pageInfo.pageSize).toList())
        : new IssueBoard(issues);
  }
  
  IssueBoard getNextPage(IssueBoard issueBoard) {
    // TODO: PageSize may be null
    
    var resultsToSkip = (issueBoard.pageInfo.pageSize + issueBoard.pageInfo.skipCount);
    
    
    issueBoard.searchQueryArgs
        ..add(new PageInfo(resultsToSkip, issueBoard.pageInfo.pageSize));
    
    var thisInstance = reflect(this);
    var result = thisInstance.invoke(issueBoard.searchQueryMethod, issueBoard.searchQueryArgs);
    
    return result.reflectee as IssueBoard;
  }
  
}