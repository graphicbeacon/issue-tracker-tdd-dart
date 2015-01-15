part of issuelib;

class IssueBoard {
  // Metadata
  PageInfo pageInfo;
  Symbol searchQueryMethod;
  List searchQueryArgs;
  
  // Data
  List<Issue> issues;
  
  IssueBoard(this.pageInfo, this.searchQueryMethod, this.searchQueryArgs, this.issues);
}