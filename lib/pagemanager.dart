part of issuelib;

class PageManager {
  IssueBoardService issueBoardService;
  
  PageManager(this.issueBoardService);
  
  IssueBoard getNextPage(IssueBoard issueBoard) {
    
    var resultsToSkip = (issueBoard.pageInfo.pageSize + issueBoard.pageInfo.skipCount);
    
    issueBoard.searchQueryArgs
        ..add(new PageInfo(resultsToSkip, issueBoard.pageInfo.pageSize));
    
    var issueBoardInstance = reflect(this.issueBoardService);
    var result = issueBoardInstance.invoke(issueBoard.searchQueryMethod, issueBoard.searchQueryArgs);
    
    return result.reflectee as IssueBoard;
  }
  
  IssueBoard getPreviousPage(IssueBoard issueBoard) {
    var resultsToSkip = (issueBoard.pageInfo.skipCount - issueBoard.pageInfo.pageSize);
    
    if (resultsToSkip < 0) resultsToSkip = 0;
    
    issueBoard.searchQueryArgs
        ..add(new PageInfo(resultsToSkip, issueBoard.pageInfo.pageSize));
    
    var issueBoardInstance = reflect(this.issueBoardService);
    var result = issueBoardInstance.invoke(issueBoard.searchQueryMethod, issueBoard.searchQueryArgs);
    
    return result.reflectee as IssueBoard;
  }
}