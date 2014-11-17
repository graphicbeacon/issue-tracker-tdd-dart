part of issuelib;

abstract class IssueStore {
   void store(Issue issue);
   
   List<Issue> getAllIssues();
}