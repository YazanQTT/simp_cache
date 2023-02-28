class Student {
  late int id;
  late String name;
  late List<Marks> marks;

  Student({required this.id, required this.name, required this.marks});

  Student.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['marks'] != null) {
      marks = <Marks>[];
      json['marks'].forEach((v) {
        marks.add(new Marks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['marks'] = this.marks.map((v) => v.toJson()).toList();
    return data;
  }
}

class Marks {
  List<int>? english;
  List<int>? arabic;

  Marks({this.english, this.arabic});

  Marks.fromJson(Map<String, dynamic> json) {
    english = json['English'].cast<int>();
    arabic = json['Arabic'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['English'] = this.english;
    data['Arabic'] = this.arabic;
    return data;
  }
}