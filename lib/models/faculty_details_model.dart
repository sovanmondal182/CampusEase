class FacultyDetailsModel {
  String? facultyName;
  String? facultyEmail;
  String? facultyMobile;
  String? facultyBranch;
  String? facultyId;

  FacultyDetailsModel(
      {this.facultyName,
      this.facultyEmail,
      this.facultyMobile,
      this.facultyBranch,
      this.facultyId});

  FacultyDetailsModel.fromMap(Map<String, dynamic> data)
      : facultyName = data['facultyName'],
        facultyEmail = data['facultyEmail'],
        facultyMobile = data['facultyMobile'],
        facultyBranch = data['facultyBranch'],
        facultyId = data['facultyId'];

  Map<String, dynamic> toMap() {
    return {
      'facultyName': facultyName,
      'facultyEmail': facultyEmail,
      'facultyMobile': facultyMobile,
      'facultyBranch': facultyBranch,
      'facultyId': facultyId,
    };
  }
}
