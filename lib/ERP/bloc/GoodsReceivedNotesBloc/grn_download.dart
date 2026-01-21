import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../UI/Utils/messages_constants.dart';
import '../../api/services/add_goods_received_notes_service.dart';

/// =======================
/// EVENT
/// =======================
abstract class GRNDownloadEvent extends Equatable {
  const GRNDownloadEvent();

  @override
  List<Object?> get props => [];
}

class SubmitGRNDownloadEvent extends GRNDownloadEvent {
  final String grn_id;

  const SubmitGRNDownloadEvent({
    required this.grn_id,
  });

  @override
  List<Object?> get props => [grn_id];
}

/// =======================
/// STATE
/// =======================
abstract class GRNDownloadState extends Equatable {
  const GRNDownloadState();

  @override
  List<Object?> get props => [];
}

class GRNDownloadInitial extends GRNDownloadState {}

class GRNDownloadLoading extends GRNDownloadState {}

class GRNDownloadSuccess extends GRNDownloadState {
  final String downloadUrl;
  final String fileName;

  const GRNDownloadSuccess({
    required this.downloadUrl,
    required this.fileName,
  });

  @override
  List<Object?> get props => [downloadUrl, fileName];
}

class GRNDownloadFailed extends GRNDownloadState {
  final String message;

  const GRNDownloadFailed(this.message);

  @override
  List<Object?> get props => [message];
}

/// =======================
/// BLOC
/// =======================
class GRNDownloadBloc extends Bloc<GRNDownloadEvent, GRNDownloadState> {
  GRNDownloadBloc() : super(GRNDownloadInitial()) {
    on<SubmitGRNDownloadEvent>((event, emit) async {
      emit(GRNDownloadLoading());

      try {
        final result =
        await GRNDownloadService().fetchGRNDownload(event.grn_id);

        if (result == ConstantsMessage.serveError) {
          emit(GRNDownloadFailed(ConstantsMessage.serveError));
          return;
        }

        final decoded = jsonDecode(result);

        if (decoded is Map<String, dynamic>) {
          final String downloadUrl = decoded['download_url'] ?? '';
          final String fileName = decoded['file_name'] ?? '';

          if (downloadUrl.isNotEmpty) {
            emit(
              GRNDownloadSuccess(
                downloadUrl: downloadUrl,
                fileName: fileName,
              ),
            );
          } else {
            emit(const GRNDownloadFailed("Download URL not found"));
          }
        } else {
          emit(const GRNDownloadFailed("Invalid server response"));
        }
      } catch (e, st) {
        print("GRN Download Exception: $e\n$st");
        emit(GRNDownloadFailed(ConstantsMessage.serveError));
      }
    });
  }
}
