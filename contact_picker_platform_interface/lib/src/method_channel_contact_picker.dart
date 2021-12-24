import 'dart:async';

import 'package:contact_picker_platform_interface/contact_picker_platform_interface.dart';
import 'package:flutter/services.dart';

const MethodChannel _channel = const MethodChannel('me.schlaubi.contactpicker');

class MethodChannelContactPicker extends ContactPickerPlatform {
  @override
  Future<PhoneContact> pickPhoneContact({bool askForPermission = true}) async =>
      PhoneContact.fromMap((await (_runCancellable(_channel
          .invokeMethod<Map<dynamic, dynamic>>(
              'pickPhoneContact', {'askForPermission': askForPermission})))));

  @override
  Future<EmailContact> pickEmailContact({bool askForPermission = true}) async =>
      EmailContact.fromMap((await (_runCancellable(_channel
          .invokeMethod<Map<dynamic, dynamic>>(
              'pickEmailContact', {'askForPermission': askForPermission})))));

  @override
  Future<FullContact> pickFullContact({bool askForPermission = true}) async =>
      FullContact.fromMap((await (_runCancellable(_channel
          .invokeMethod<Map<dynamic, dynamic>>(
              'pickContact', {'askForPermission': askForPermission})))));

  @override
  Future<bool> hasPermission() async =>
      (await _channel.invokeMethod('hasPermission'));

  Future<T> _runCancellable<T>(FutureOr<T?> cancellable) async {
    try {
      final contact = await cancellable;
      if (contact == null) {
        throw UserCancelledPickingException();
      }
      return contact;
    } on PlatformException catch (e) {
      if (e.code == 'CANCELLED') {
        throw UserCancelledPickingException();
      }
      rethrow;
    }
  }

  @override
  Future<bool> requestPermission({bool force = false}) async {
    if (!force) {
      var granted = await (hasPermission());
      if (granted) return true;
    }
    return await _channel.invokeMethod('requestPermission');
  }
}
