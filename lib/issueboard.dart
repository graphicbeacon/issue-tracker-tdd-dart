part of issuelib;

class IssueBoard {
  // Metadata
  PageInfo pageInfo;
  Symbol searchQueryMethod;
  List searchQueryArgs;
  
  // Data
  List<Issue> issues;
  
  IssueBoard(this.issues);
  
  IssueBoard.withPaging(this.pageInfo, this.searchQueryMethod, this.searchQueryArgs, this.issues);
}