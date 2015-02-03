part of issuelib;

class Attachment extends Object with Exportable {
    @export String name;
    @export String location;

    Attachment();

    Attachment.create(this.name, this.location);
}