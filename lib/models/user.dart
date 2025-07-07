class UserDetails {
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? emailId;
  String? username;
  int? id;

  UserDetails(
      {this.id,this.firstName,
      this.lastName,
      this.username,
      this.phoneNumber,
      this.emailId});

  UserDetails.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    username = json['username'];
    phoneNumber = json['phoneNumber'];
    emailId = json['emailId'];
    id = json['id'];
  }
  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'username': username,
        'phoneNumber': phoneNumber,
        'emailId': emailId,
        'id': id
      };
}

