import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frs/constants/enums.dart';

final selectedEmergencyTypeProvider = StateProvider<EmergencyType>((ref) {
  return EmergencyType.other; // Default value
});
