class board_obj{
  String? flagImgName;
  String? name;
  String? country;
  int score = 0;
  bool? active;
  bool? selected;

  board_obj(this.name, this.country, this.score, this.active,this.selected, this.flagImgName);

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
      'full_name': name,
      'small_name': country,
      'score': score,
      'active': active,
      'selected': selected,
      'icon_name': flagImgName
  };

  board_obj.fromJson(Map<dynamic, dynamic> json)
      : name = json['full_name'] as String,
        country = json['small_name'] as String,
        score = json['score'] as int,
        active = json['active'] as bool,
        selected = json['selected'] as bool,
        flagImgName = json['icon_name'] as String;
}