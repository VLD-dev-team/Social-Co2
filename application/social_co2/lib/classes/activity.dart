class SCO2activity {
  final int? activityID;
  final String? userID;
  final String activityType;
  final int? activityCO2Impact;
  final String activityName;
  final DateTime activityTimestamp;
  final String? activityMealIngredients;
  final String? activityPurchase;
  final double? activityDistance;
  final String? activityVehicule;
  final String? activityBuild;

  SCO2activity({
    required this.activityType,
    required this.activityName,
    required this.activityTimestamp,
    this.userID,
    this.activityID,
    this.activityCO2Impact,
    this.activityMealIngredients,
    this.activityPurchase,
    this.activityDistance,
    this.activityVehicule,
    this.activityBuild,
  });

  factory SCO2activity.fromJSON(Map<String, dynamic> json) {
    return SCO2activity(
      activityID: json['activityID'],
      userID: json['userID'],
      activityType: json['activityType'],
      activityCO2Impact: json['activityCO2Impact'],
      activityName: json['activityName'],
      activityMealIngredients: json['activityMealIngredients'],
      activityPurchase: json['activityPurchase'],
      activityDistance: double.tryParse(json['activityDistance']),
      activityVehicule: json['activityVehicle'],
      activityBuild: json['activityBuild'],
      activityTimestamp: DateTime.parse(json['activityTimestamp']),
    );
  }

  Map<String, String> toJson() {
    final Map<String, String> data = {
      'activityType': activityType,
      'activityName': activityName,
      'activityTimestamp': activityTimestamp.toIso8601String(),
    };

    if (activityID != null) data['activityID'] = activityID.toString();
    if (userID != null) data['userID'] = userID.toString();
    if (activityCO2Impact != null) {
      data['activityCO2Impact'] = activityCO2Impact.toString();
    }
    if (activityMealIngredients != null) {
      data['activityMealIngredients'] = activityMealIngredients!;
    }
    if (activityPurchase != null) data['activityPurchase'] = activityPurchase!;
    if (activityDistance != null) {
      data['activityDistance'] = activityDistance!.toString();
    }
    if (activityVehicule != null) data['activityVehicle'] = activityVehicule!;
    if (activityBuild != null) data['activityBuild'] = activityBuild!;

    return data;
  }
}
