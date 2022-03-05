class Task {
  String id;
  String title;
  String notes; //Escape characters bro...
  bool isCompleted = false;

  Task(
      {required this.id,
      required this.title,
      this.notes = '[{"insert":"\\n"}]'});
}
