class Employee {
  String? name;
  int? id;
  String? position;
  String? toDate;
  String? fromDate;
  String? timeStamp;
  String? status;

  Employee(
      {this.name,
      this.position,
      this.toDate,
      this.fromDate,
      this.timeStamp,
      this.status});

  Employee.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    position = json['position'];
    toDate = json['to_date'];
    fromDate = json['from_date'];
    timeStamp = json['time_stamp'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['position'] = this.position;
    data['to_date'] = this.toDate;
    data['from_date'] = this.fromDate;
    data['time_stamp'] = this.timeStamp;
    data['status'] = this.status;
    return data;
  }
}
