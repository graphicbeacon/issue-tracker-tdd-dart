part of issuelib;

class Issue {
  
  String id;
  String title;
  String description;
  DateTime dueDate;
  IssueStatus status;
  String projectName;
  String createdBy;
  String assignedTo;
  List<Attachment> attachments;
  
  Issue({String this.id,
    String this.title, 
    String this.description, 
    DateTime this.dueDate, 
    IssueStatus this.status,
    String this.projectName,
    String this.createdBy,
    String this.assignedTo}) {
    attachments = new List<Attachment>(); 
  }
  
  bool operator ==(o) {
    return o is Issue && 
        id == o.id &&
        title == o.title &&
        description == o.description &&
        dueDate == o.dueDate &&
        status == o.status &&
        projectName == o.projectName &&
        createdBy == o.createdBy &&
        assignedTo == o.assignedTo;  
  }
}