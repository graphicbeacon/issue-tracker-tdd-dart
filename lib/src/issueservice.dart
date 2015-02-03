part of issuelib;

class IssueService {

    Store store;
    String attachmentFilesDirectory;

    IssueService(this.store, this.attachmentFilesDirectory) {
        if (!attachmentFilesDirectory.endsWith('/')) {
            attachmentFilesDirectory += '/';
        }
    }

    Future createIssue(String id, String title, String description, DateTime dueDate, IssueStatus status, String projectName, String sessionToken) async {

        if (await store.hasIssue(id) == true) throw new ArgumentError("Please ensure ids are unique");

        if (await store.hasProject(projectName) == false) throw new ArgumentError("Invalid projectId specified.");

        var userSession = await store.getUserSession(sessionToken);
        if (userSession == null) throw new ArgumentError("User must be logged in to perform this action");

        var user = await store.getUser(userSession.username);

        var issue = new Issue.create(id, title, description, dueDate, status, projectName, '${user.firstName} ${user.lastName}', '${user.firstName} ${user.lastName}');

        store.storeIssue(issue);
    }

    Future saveAttachment(String issueId, String sessionToken, String fileName) async {
        if (await store.hasUserSession(sessionToken) == false) throw new ArgumentError("User must be logged in to perform this operation");

        var issue = await store.getIssue(issueId);
        if (issue == null) throw new ArgumentError("Issue does not exist");

        var location = '${attachmentFilesDirectory}${issue.id}/${fileName}';
        issue.attachments.add(new Attachment.create(fileName, location));

        store.storeIssue(issue);
    }

    // TODO: Write attachment to file
    // TODO: Remove Attachments
}
