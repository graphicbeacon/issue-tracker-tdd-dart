part of issuelib;

class IssueBoard {
    // Metadata
    PageInfo pageInfo;
    Symbol searchQueryMethod;
    List searchQueryArgs;

    // Data
    List<Issue> issues;

    IssueBoard();

    IssueBoard.create(this.pageInfo, this.searchQueryMethod, this.searchQueryArgs, this.issues);
}