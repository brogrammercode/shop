class BranchInputModel {
  final String name;
  final String address;

  const BranchInputModel({required this.name, required this.address});

  Map<String, dynamic> toJson() {
    return {'name': name, 'address': address};
  }
}
