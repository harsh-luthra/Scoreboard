class board_obj{
  int id;
  String? flagImgName;
  String? name;
  String? country;
  int reps = 0;
  int distance = 0;
  int time = 0;
  int score = 0;
  int total = 0;
  int place = 0;
  bool? active;
  bool? selected;

  board_obj(this.id,this.name, this.country, this.reps,this.distance,this.time,this.score,this.total,this.place, this.active,this.selected, this.flagImgName);

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
      'id': id,
      'name': name,
      'country': country,
      'reps': reps,
      'distance': distance,
      'time': time,
      'score': score,
      'total': total,
      'place': place,
      'active': active,
      'selected': selected,
      'icon_name': flagImgName
  };

  board_obj.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'] as int,
        name = json['name'] as String,
        country = json['country'] as String,
        reps = json['reps'] as int,
        distance = json['distance'] as int,
        time = json['time'] as int,
        score = json['score'] as int,
        total = json['total'] as int,
        place = json['place'] as int,
        active = json['active'] as bool,
        selected = json['selected'] as bool,
        flagImgName = json['icon_name'] as String;
}