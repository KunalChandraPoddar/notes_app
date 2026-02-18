import 'package:json_annotation/json_annotation.dart';
import 'package:notes_app/data/constants/app_strings.dart';

part 'note_model.g.dart';

@JsonSerializable()
class NoteModel {
  final int? id;
  final String title;

  @JsonKey(name: AppStrings.body)
  final String content;

  NoteModel({
    this.id,
    required this.title,
    required this.content,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) =>
      _$NoteModelFromJson(json);

  Map<String, dynamic> toJson() => _$NoteModelToJson(this);
}
