import 'package:warisan_kating/shared/models/barter_model.dart';

/// Contract for barter/trade request operations.
abstract class BarterService {
  /// Create a new barter request (status = pending).
  Future<void> createRequest(Barter barter);

  /// Stream requests where the current user is the item owner.
  Stream<List<Barter>> incomingRequests(String ownerId);

  /// Stream requests the current user has sent.
  Stream<List<Barter>> outgoingRequests(String requesterId);

  /// Owner accepts a pending request.
  Future<void> acceptRequest(String barterId);

  /// Owner rejects a pending request.
  Future<void> rejectRequest(String barterId);

  /// Either party marks the barter as completed.
  Future<void> completeRequest(String barterId);
}
