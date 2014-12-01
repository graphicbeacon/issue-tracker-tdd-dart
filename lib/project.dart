part of issuelib;

class Project {
  int id;
  String name;
  String description;
  
  Project({int this.id, String this.name, String this.description});
  
  bool operator ==(o) {
      return o is Project && 
          id == o.id &&
          name == o.name &&
          description == o.description;  
    }
}