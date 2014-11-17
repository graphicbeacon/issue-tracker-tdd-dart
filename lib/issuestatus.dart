part of issuelib;

class IssueStatus {
  int state;
  
  IssueStatus.opened() {
    this.state = 1;
  }
  
  IssueStatus.closed() {
    this.state = 0;    
  }
  
  IssueStatus.inProgress() {
    this.state = 2;
  }
  
}