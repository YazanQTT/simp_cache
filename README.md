# SimpCache
**SimpCache** is a caching library for Flutter that allows you to store and retrieve objects in a simple and efficient manner. The library creates a local variable of type `Map` and stores each object as `JSON` within it. Additionally, it also stores the `JSON` representation of each object in SharedPreferences using the `EncryptedSharedPreferences` package to provide an extra layer of security.

When you retrieve an object from **SimpCache**, it first checks the local variable to see if the object is already available. If it is not, it checks the SharedPreferences and retrieves the object as a `JSON` file. This approach allows **SimpCache** to provide fast and efficient access to cached objects.

To use **SimpCache** with complex classes, you must implement the `toJson` and `fromJson` methods for those classes. These methods are used to serialize and deserialize the objects into `JSON` format, which is then stored and retrieved by **SimpCache**. It's important to note that this requirement is due to the lack of Dart Mirroring/Reflect in Flutter.

Overall, **SimpCache** provides a simple and efficient caching solution for Flutter developers, and its use of SharedPreferences and encryption make it a secure choice for storing sensitive data.

## Features 👇
- 🔸 Efficient caching: SimpCache provides an efficient caching solution for Flutter apps by storing objects in a local variable and SharedPreferences, which makes accessing cached objects fast and efficient.

- 🔸 Secure data storage: SimpCache uses the `EncryptedSharedPreferences` package to store JSON data in SharedPreferences, which provides an extra layer of security for sensitive data.

- 🔸 Easy to use: SimpCache is easy to use and requires minimal configuration. Once you have implemented the `toJson` and `fromJson` methods for your complex classes, you can start caching objects with just a few lines of code.

- 🔸 Works with complex classes: SimpCache allows you to cache complex objects that don't have a simple data type, by serializing and deserializing them to and from JSON format.


## Installing ✅
```yaml
dependencies:
  simp_cache: ^<latest_version>
```

## Usage ⚒️
##### *Create an instance of SimpCache*
```
final simp = SimpCache.instance;
```

1. Cache objects
##### *Cache objects using simp.cacheItem*
```swift
final Student student = Student(  
  id: 1,  
  name: 'Yazan',  
  marks: [  
    Marks(  
      english: [9, 30, 42],  
	  arabic: [7, 28, 37],  
   ),  
    Marks(  
      english: [10, 36, 45],  
	  arabic: [5, 31, 40],  
   ),  
  ],  
);  
  
await simp.cacheItem(student.id.toString(), student);
```

>Note : Student Class must implement toJson & fromJson methods

example:
```swift
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
```
2. Retrieve objects as JSON
##### *Use simp.getItemByKey*
```swift
//showSource -> Shows if the item is retrieved from RAM or SharedPreferences  
final result = await simp.getItemByKey('1', showSource: true);  
  
//Convert JSON to Student class  
final Student student = Student.fromJson(jsonDecode(result));  
  
debugPrint(student.name);  
  
//OUTPUT : Yazan
```
3. Show cached objects

##### *Use simp.showCachedItems*

```swift
//If kDebugMode it will print all cached items.  
await simp.showCachedItems(showSource: true);
```
4. Remove cached object
##### *Use simp.removeItemByKey*
```swift
await simp.removeItemByKey('1');
```
5. Clear all cached objects
##### *Use simp.clearCache*
```swift
await simp.clearCache();
```
## Bugs/Requests 🔴
Feel free to reach out and open an issue if you encounter any problems.
If you feel the library is missing a feature, please raise a ticket on Github and I'll look into it.
Pull request are also welcome.

