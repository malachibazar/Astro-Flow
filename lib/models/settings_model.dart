// The reward model is used to store the user's break rewards.
import 'dart:convert';

class RewardModel {
  // The number of milliseconds to work to get a reward.
  int workTime;
  // The number of milliseconds to reward the user for.
  int rewardTime;

  // Constructor
  RewardModel({
    this.workTime = 60000,
    this.rewardTime = 0,
  });

  // Convert the reward model to a json string.
  String toJson() {
    return jsonEncode({
      'workTime': workTime,
      'rewardTime': rewardTime,
    });
  }

  // Convert a json string to a reward model.
  factory RewardModel.fromJson(String jsonString) {
    var json = jsonDecode(jsonString);
    return RewardModel(
      workTime: json['workTime'],
      rewardTime: json['rewardTime'],
    );
  }
}

class RewardsForBreaksModel {
  late RewardModel reward1;
  late RewardModel reward2;
  late RewardModel reward3;
  late RewardModel reward4;

  RewardsForBreaksModel() {
    reward1 = RewardModel();
    reward2 = RewardModel();
    reward3 = RewardModel();
    reward4 = RewardModel();
  }

  // A method to convert the model to a JSON string.
  String toJson() {
    return jsonEncode({
      'reward1': reward1.toJson(),
      'reward2': reward2.toJson(),
      'reward3': reward3.toJson(),
      'reward4': reward4.toJson(),
    });
  }

  // A method to convert a JSON string to a model.
  factory RewardsForBreaksModel.fromJson(String jsonString) {
    var json = jsonDecode(jsonString);
    return RewardsForBreaksModel()
      ..reward1 = RewardModel.fromJson(json['reward1'])
      ..reward2 = RewardModel.fromJson(json['reward2'])
      ..reward3 = RewardModel.fromJson(json['reward3'])
      ..reward4 = RewardModel.fromJson(json['reward4']);
  }
}
