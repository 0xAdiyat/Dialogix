import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedUidsProvider =
    Provider.family<SelectedUids, Set<String>>((ref, uids) {
  return SelectedUids(uids: uids);
});

class SelectedUids {
  final Set<String> _uids;

  SelectedUids({required Set<String> uids}) : _uids = uids;

  void addUid(String uid) => _uids.add(uid);
  void removeUid(String uid) => _uids.remove(uid);
}
