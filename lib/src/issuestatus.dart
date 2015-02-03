part of issuelib;

class IssueStatus extends Object with Exportable {
    @export int state;

    IssueStatus();

    IssueStatus.opened() {
        this.state = 1;
    }

    IssueStatus.closed() {
        this.state = 0;
    }

    IssueStatus.inProgress() {
        this.state = 2;
    }

    bool operator ==(o) => o is IssueStatus && state == o.state;

}