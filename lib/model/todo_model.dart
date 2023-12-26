class TODO {
  String? title;
  String? desc;

  TODO({
    this.title,
    this.desc,
  });

  toJson() {
    return {
      'title': title,
      'desc': desc,
    };
  }

  fromJson(jsonData) {
    return TODO(
      title: jsonData['title'] ?? '',
      desc: jsonData['desc'] ?? '',
    );
  }
}
