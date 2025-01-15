class ManagerCaptainModel {

  final int managerId;
  final String playerName;
  final int multiplier;

  ManagerCaptainModel(this.managerId, this.playerName, this.multiplier);

  factory ManagerCaptainModel.fromJson(MapEntry<String, dynamic> managerCaptainPickJsonObj) {

    return ManagerCaptainModel(
      int.parse(managerCaptainPickJsonObj.key),
      managerCaptainPickJsonObj.value["playerName"],
      managerCaptainPickJsonObj.value["multiplier"]);
  }
}