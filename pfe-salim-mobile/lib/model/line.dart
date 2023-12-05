import 'package:pfe_salim/model/user.dart';
import 'package:pfe_salim/utils/json_utils.dart';

class Line {
  int id;
  int quantity;
  String reference;
  DateTime? date;
  //User user;

  Line({
    this.id = -1,
    required this.quantity,
    required this.reference,
    required this.date,
    //required this.user,
  });

  factory Line.fromJson(Map<String, dynamic> json) {
    return Line(
      id: json['id'],
      quantity: json['quantity'],
      reference: json['reference'] ?? '',
      date: JsonUtils.date(json['date']),
      //user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "quantity": quantity,
      "reference": reference,
      "date": date,
      //"user": user.toJson(),
    };
  }
}
