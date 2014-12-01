part of issuelib;

class Issue {
  
  String title;
  String description;
  DateTime dueDate;
  IssueStatus status;
  String projectName;
  
  Issue({String this.title, 
    String this.description, 
    DateTime this.dueDate, 
    IssueStatus this.status,
    String this.projectName});
  
  bool operator ==(o) {
    return o is Issue && 
        title == o.title &&
        description == o.description &&
        dueDate == o.dueDate &&
        status == o.status &&
        projectName == o.projectName;  
  }
}