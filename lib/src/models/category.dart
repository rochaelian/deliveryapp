import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  String? id;
  String? name;
  String? description;
  List<Category> toList = [];

  Category({
     this.id,
     this.name,
     this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
  };

  Category.fromJsonList(List<dynamic>? jsonList){
    if(jsonList == null){
      return;
    }else{
      jsonList.forEach((item) {
        Category category = Category.fromJson(item);
        toList.add(category);
      });
    }
  }

}