part of issuelib;

class Issue {
  
  String title;
  String description;
  DateTime dueDate;
  IssueStatus status;
  
  Issue({String this.title: "", 
    String this.description: "", 
    DateTime this.dueDate, 
    IssueStatus this.status});
  
}