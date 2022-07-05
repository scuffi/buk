class BlockItem {
  String id;
  String name;

  BlockItem({
    required this.id,
    required this.name,
  });

  @override
  String toString() {
    // TODO: implement toString
    return {"id": id, "name": name}.toString();
  }
}
