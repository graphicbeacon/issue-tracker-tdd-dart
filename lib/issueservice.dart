part of issuelib;

class IssueService {
  
  Store store;
  String attachmentFilesDirectory;
  
  IssueService(this.store, this.attachmentFilesDirectory) {
    if(!attachmentFilesDirectory.endsWith('/')) {
      attachmentFilesDirectory += '/';
    }
  }
  
  void createIssue(String id, String title, String description, 
                   DateTime dueDate, IssueStatus status, 
                   String projectName, String sessionToken) {
    
    if (store.hasIssue(id))
      throw new ArgumentError("Please ensure ids are unique");
    
    if (!store.hasProject(projectName))
      throw new ArgumentError("Invalid projectId specified.");
    
    var userSession = store.getUserSession(sessionToken);
    if(userSession == null) 
      throw new ArgumentError("User must be logged in to perform this action");
    
    var user = store.getUser(userSession.username);
    
    store.storeIssue(new Issue(
      id: id,
      title: title,
      description: description,
      dueDate: dueDate,
      status: status,
      projectName: projectName,
      createdBy: '${user.firstName} ${user.lastName}',
      assignedTo: '${user.firstName} ${user.lastName}'
    ));
  }
  
  void saveAttachment(String issueId, String sessionToken, String fileName) {
    if(!store.hasUserSession(sessionToken))
      throw new ArgumentError("User must be logged in to perform this operation");
    
    var issue = store.getIssue(issueId);
    if(issue == null)
      throw new ArgumentError("Issue does not exist");
    
    var location = '${attachmentFilesDirectory}${issue.id}/${fileName}';
    issue.attachments.add(new Attachment(fileName, location));
    
    store.updateIssue(issueId, issue);
  }
  
  // TODO: Write attachment to file
  // TODO: Remove Attachments
}