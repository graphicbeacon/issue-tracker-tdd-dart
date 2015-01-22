part of issuelib;

class Issue extends Object with Exportable {
  
  @export String id;
  @export String title;
  @export String description;
  @export DateTime dueDate;
  @export IssueStatus status;
  @export String projectName;
  @export String createdBy;
  @export String assignedTo;
  @export List<Attachment> attachments;
  
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