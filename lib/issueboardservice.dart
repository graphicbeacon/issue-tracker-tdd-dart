part of issuelib;

class IssueBoardService {
  
  Store store;
  
  IssueBoardService(this.store);
  
  Future<IssueBoard> getAllIssues(PageInfo pageInfo) async {
    if (pageInfo == null) throw new ArgumentError("PageInfo is mandatory");
    
    var issues = await store.getAllIssues();
    
    
    issues.sort((a,b) => b.dueDate.compareTo(a.dueDate));
    
    return new IssueBoard(pageInfo, #getAllIssues, [], 
            issues.skip(pageInfo.skipCount).take(pageInfo.pageSize).toList());
  }
  
  Future<IssueBoard> getIssuesByName(String name, PageInfo pageInfo) async {
    if (name == null || name.isEmpty) throw new ArgumentError("Name is mandatory");
    if (pageInfo == null) throw new ArgumentError("PageInfo is mandatory");
    
    List<Issue> issues = await store.getAllIssues();
    var issueFilter = issues.where((Issue issue) => issue.title.contains(name));
    
    return new IssueBoard(pageInfo, #getIssuesByName, [name], 
            issueFilter.skip(pageInfo.skipCount).take(pageInfo.pageSize).toList());
  }
  
  Future<IssueBoard> getIssuesByProjectName(String projectName, PageInfo pageInfo) async {
    if (projectName == null || projectName.isEmpty) throw new ArgumentError("Project name is mandatory");
    if (pageInfo == null) throw new ArgumentError("PageInfo is mandatory");
    
    Project project = (await store
        .getAllProjects())
        .singleWhere((Project project) => project.name.toLowerCase() == projectName.toLowerCase());
    
    List<Issue> issues = (await store
        .getAllIssues())
        .where((Issue issue) => issue.projectName == project.name)
        .toList();
    
    return new IssueBoard(pageInfo, #getIssuesByProjectName, [projectName], 
            issues.skip(pageInfo.skipCount).take(pageInfo.pageSize).toList());
  }
}