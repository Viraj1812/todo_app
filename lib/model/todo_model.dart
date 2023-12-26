class TODO {
  String? title;
  String? desc;

  TODO({
    required this.title,
    required this.desc,
  });

  factory TODO.fromJson(Map<String, dynamic> json) => TODO(
        title: json["title"] ?? '',
        desc: json["desc"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "desc": desc,
      };
}
