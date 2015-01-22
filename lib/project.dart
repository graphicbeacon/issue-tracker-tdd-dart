part of issuelib;

class Project extends Object with Exportable {
  @export String name;
  @export String description;
  
  Project({String this.name, String this.description});
  
  bool operator ==(o) {
      return o is Project &&
          name == o.name &&
          description == o.description;  
    }
}