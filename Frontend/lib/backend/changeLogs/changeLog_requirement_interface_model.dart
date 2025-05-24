abstract class RequirementChangeLog {
  String? get id;
  String? get modifiedBy;
  String? get oldTitle;
  String? get oldDescription;
  String? get requirementId;
  List<String>? get header;
  List<String>? get oldAttributeDescription;
  String? get changeType;
  DateTime? get modifiedAt;
  String? get projectId;
}
