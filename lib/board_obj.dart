class board_obj{
  String? full_name;
  String? small_name;
  int score = 0;
  bool? active;
  bool? selected;
  String? icon_name;

  board_obj(
      this.full_name, this.small_name, this.score, this.active,this.selected, this.icon_name);

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
      'full_name': full_name,
      'small_name': small_name,
      'score': score,
      'active': active,
      'selected': selected,
      'icon_name': icon_name
  };

  board_obj.fromJson(Map<dynamic, dynamic> json)
      : full_name = json['full_name'] as String,
        small_name = json['small_name'] as String,
        score = json['score'] as int,
        active = json['active'] as bool,
        selected = json['selected'] as bool,
        icon_name = json['icon_name'] as String;
}