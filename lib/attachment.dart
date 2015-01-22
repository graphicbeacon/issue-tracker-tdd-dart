part of issuelib;

class Attachment extends Object with Exportable {
  @export String name;
  @export String location;
  
  Attachment(this.name, this.location);
}