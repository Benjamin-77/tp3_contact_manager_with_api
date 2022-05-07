
class User {
  String _id = "";
  String _firstName = "";
  String _lastName = "";
  String _gender = "";
  String _phone = "";
  String _adresse = "";
  String _citation = "";
  String _photo = "user0.png";


  User() {
    this._id;
    this._firstName;
    this._lastName;
    this._gender;
    this._phone;
    this._adresse;
    this._citation;
    this._photo;
  }

  UserWithParameter(
      String id,
      String firstName,
      String lastName,
      String gender,
      String phone,
      String adresse,
      String citation,
      String photo
      ) {
    this._id = id;
    this._firstName = firstName;
    this._lastName = lastName;
    this._gender = gender;
    this._phone = phone;
    this._adresse = adresse;
    this._citation = citation;
    this._photo = photo;
  }

  User updateUser(User user) {
    this._firstName = user.getFirstName();
    this._lastName = user.getLastName();
    this._gender = user.getGender();
    this._phone = user.getPhone();
    this._adresse = user.getAdresse();
    this._citation = user.getCitation();
    this._photo = user.getPhoto();

    return this;
  }

  User.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _firstName = json['firstname'],
        _lastName = json['lastname'],
        _gender = json['gender'],
        _phone = json['phone'],
        _adresse = json['adress'],
        _citation = json['citation'],
        _photo = json['picture'];

  Map<String, dynamic> toJson() => {
        'firstname': _firstName,
        'lastname': _lastName,
        'adress': _adresse,
        'phone': _phone,
        'gender': _gender,
        'picture': _photo,
        'citation': _citation,
      };

  String getId() {
    return this._id;
  }

  void setId(String id) {
    this._id = id;
  }

  String getFirstName() {
    return this._firstName;
  }

  void setFirstName(String word) {
    this._firstName = word;
  }

  String getLastName() {
    return this._lastName;
  }

  void setLastName(String word) {
    this._lastName = word;
  }

  String getGender() {
    return this._gender;
  }

  void setGender(String word) {
    this._gender = word;
  }

  String getPhone() {
    return this._phone;
  }

  void setPhone(String word) {
    this._phone = word;
  }

  String getAdresse() {
    return this._adresse;
  }

  void setAdresse(String word) {
    this._adresse = word;
  }

  String getCitation() {
    return this._citation;
  }

  void setCitation(String word) {
    this._citation = word;
  }

  String getPhoto() {
    return this._photo;
  }

  void setPhoto(String word) {
    this._photo = word;
  }
}