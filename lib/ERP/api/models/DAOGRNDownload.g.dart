// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DAOGRNDownload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DAOGRNDownload _$DAOGRNDownloadFromJson(Map<String, dynamic> json) =>
    DAOGRNDownload(
      file_path: json['file_path'] as String?,
      file_name: json['file_name'] as String?,
      download_url: json['download_url'] as String?,
    );

Map<String, dynamic> _$DAOGRNDownloadToJson(DAOGRNDownload instance) =>
    <String, dynamic>{
      'file_path': instance.file_path,
      'file_name': instance.file_name,
      'download_url': instance.download_url,
    };
