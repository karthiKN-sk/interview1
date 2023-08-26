class TransactionModel {
  String? place;
  String? address;

  TransactionModel(
    this.place,
    this.address,
  );

  TransactionModel.fromJson(Map<String, dynamic> json) {
    place = json['place'];
    address = json['address'];
  }
}

var deliverylistdetailData = [
  {
    "place": "Work",
    "address": '38, Mahatma Gandhi Road, VGN Phase4...',
  },
  {
    "place": "Home",
    "address": "38, Mahatma Gandhi Road, VGN Phase4...",
  },
];
var data = {
  "place": "Work",
  "address": '38, Mahatma Gandhi Road, VGN Phase4...',
};

getData() async {
  try {
    dynamic res;
    var response = deliverylistdetailData;
    if (response.isNotEmpty) {
      res = List<TransactionModel>.from(
          response.map((e) => TransactionModel.fromJson(e)));
    } else {
      res = TransactionModel.fromJson(data);
    }
    return res;
  } catch (e) {
    print(e);
  }
}
