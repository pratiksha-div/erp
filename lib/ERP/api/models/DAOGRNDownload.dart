import 'package:json_annotation/json_annotation.dart';

part 'DAOGRNDownload.g.dart';

@JsonSerializable()
class DAOGRNDownload {
  String? file_path;
  String? file_name;
  String? download_url;

  DAOGRNDownload({
    this.file_path,
    this.file_name,
    this.download_url
  });

  factory DAOGRNDownload.fromJson(Map<String, dynamic> json) => _$DAOGRNDownloadFromJson(json);

  Map<String, dynamic> toJson() => _$DAOGRNDownloadToJson(this);
}