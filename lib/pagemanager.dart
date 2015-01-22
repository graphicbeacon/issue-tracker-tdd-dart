part of issuelib;

class PageManager {
  IssueBoardService issueBoardService;
  
  PageManager(this.issueBoardService);
  
  Future<IssueBoard> getNextPage(IssueBoard issueBoard) async {
    
    var resultsToSkip = (issueBoard.pageInfo.pageSize + issueBoard.pageInfo.skipCount);
    
    issueBoard.searchQueryArgs
        ..add(new PageInfo(resultsToSkip, issueBoard.pageInfo.pageSize));
    
    var issueBoardInstance = reflect(this.issueBoardService);
    var result = issueBoardInstance.invoke(issueBoard.searchQueryMethod, issueBoard.searchQueryArgs);
    var future = result.reflectee as Future<IssueBoard>; 
    
    return await future;
  }
  
  Future<IssueBoard> getPreviousPage(IssueBoard issueBoard) async {
    var resultsToSkip = (issueBoard.pageInfo.skipCount - issueBoard.pageInfo.pageSize);
    
    if (resultsToSkip < 0) resultsToSkip = 0;
    
    issueBoard.searchQueryArgs
        ..add(new PageInfo(resultsToSkip, issueBoard.pageInfo.pageSize));
    
    var issueBoardInstance = reflect(this.issueBoardService);
    var result = issueBoardInstance.invoke(issueBoard.searchQueryMethod, issueBoard.searchQueryArgs);
    var future = result.reflectee as Future<IssueBoard>; 
    
    return await future;
  }
}