
class User {
  int _id = 0;
  String _firstName = "";
  String _lastName = "";
  String _gender = "";
  String _phone = "";
  String _adresse = "";
  String _mail = "";
  String _birthday = "";
  String _citation = "";
  String _photo = "user0.png";

  User() {
    this._id;
    this._firstName;
    this._lastName;
    this._gender;
    this._phone;
    this._adresse;
    this._mail;
    this._birthday;
    this._citation;
    this._photo;
  }

  UserWithParameter(
      int id,
      String firstName,
      String lastName,
      String gender,
      String phone,
      String adresse,
      String mail,
      String birthday,
      String citation,
      String photo
      ) {
    this._id = id;
    this._firstName = firstName;
    this._lastName = lastName;
    this._gender = gender;
    this._phone = phone;
    this._adresse = adresse;
    this._mail = adresse;
    this._birthday = mail;
    this._citation = birthday;
    this._photo = photo;
  }

  User updateUser(User user) {
    this._firstName = user.getFirstName();
    this._lastName = user.getLastName();
    this._gender = user.getGender();
    this._phone = user.getPhone();
    this._adresse = user.getAdresse();
    this._mail = user.getMail();
    this._birthday = user.getBirthday();
    this._citation = user.getCitation();
    this._photo = user.getPhoto();

    return this;
  }

  User.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _firstName = json['firstName'],
        _lastName = json['lastName'],
        _gender = json['gender'],
        _phone = json['phone'],
        _adresse = json['adresse'],
        _mail = json['mail'],
        _birthday = json['birthday'],
        _citation = json['citation'],
        _photo = json['photo'];

  Map<String, dynamic> toJson() => {
        'firstName': _firstName,
        'lastName': _lastName,
        'gender': _gender,
        'phone': _phone,
        'adresse': _adresse,
        'mail': _mail,
        'birthday': _birthday,
        'citation': _citation,
        'photo': _photo,
      };

  int getId() {
    return this._id;
  }

  void setId(int id) {
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

  String getMail() {
    return this._mail;
  }

  void setMail(String word) {
    this._mail = word;
  }

  String getBirthday() {
    return this._birthday;
  }

  void setBirthday(String word) {
    this._birthday = word;
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
