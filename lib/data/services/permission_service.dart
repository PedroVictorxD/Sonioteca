import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestStoragePermission() async {
    if (await Permission.audio.isGranted) {
      return true;
    }

    final status = await Permission.audio.request();
    if (status.isGranted) {
      return true;
    }

    if (await Permission.storage.isGranted) {
      return true;
    }

    final storageStatus = await Permission.storage.request();
    return storageStatus.isGranted;
  }

  Future<bool> hasStoragePermission() async {
    return await Permission.audio.isGranted || 
           await Permission.storage.isGranted;
  }

  Future<void> openAppSettings() async {
    await openAppSettings();
  }
}