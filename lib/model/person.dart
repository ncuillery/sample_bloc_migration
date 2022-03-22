class Person {
  final String name;

  const Person({required this.name});

  @override
  String toString() {
    return 'Person{name: $name}';
  }
}
