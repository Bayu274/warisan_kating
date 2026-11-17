import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:warisan_kating/core/constants/app_constants.dart';
import 'package:warisan_kating/services/barter_service.dart';
import 'package:warisan_kating/shared/models/barter_model.dart';

/// Production [BarterService] backed by Cloud Firestore.
class FirestoreBarterService implements BarterService {
  FirestoreBarterService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection(AppConstants.bartersCollection);

  // ---------------------------------------------------------------------------
  // CREATE
  // ---------------------------------------------------------------------------

  @override
  Future<void> createRequest(Barter barter) async {
    try {
      await _col.doc(barter.id).set(barter.toMap());
    } on FirebaseException catch (e) {
      throw Exception('Failed to create barter request: ${e.message}');
    }
  }

  // ---------------------------------------------------------------------------
  // READ (streams)
  // ---------------------------------------------------------------------------

  @override
  Stream<List<Barter>> incomingRequests(String ownerId) {
    return _col
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => Barter.fromMap(d.data())).toList())
        .handleError((Object e) {
      throw Exception('Incoming requests stream error: $e');
    });
  }

  @override
  Stream<List<Barter>> outgoingRequests(String requesterId) {
    return _col
        .where('requesterId', isEqualTo: requesterId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => Barter.fromMap(d.data())).toList())
        .handleError((Object e) {
      throw Exception('Outgoing requests stream error: $e');
    });
  }

  // ---------------------------------------------------------------------------
  // UPDATE status
  // ---------------------------------------------------------------------------

  @override
  Future<void> acceptRequest(String barterId) =>
      _updateStatus(barterId, BarterStatus.accepted);

  @override
  Future<void> rejectRequest(String barterId) =>
      _updateStatus(barterId, BarterStatus.rejected);

  @override
  Future<void> completeRequest(String barterId) =>
      _updateStatus(barterId, BarterStatus.completed);

  Future<void> _updateStatus(String barterId, BarterStatus status) async {
    try {
      await _col.doc(barterId).update({'status': status.name});
    } on FirebaseException catch (e) {
      throw Exception('Failed to update barter $barterId: ${e.message}');
    }
  }
}
