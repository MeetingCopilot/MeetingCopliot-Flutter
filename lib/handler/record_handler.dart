import 'dart:typed_data';

import 'package:record/record.dart';

class RecordHandler {
  final AudioRecorder _audioRecorder = AudioRecorder();

  List<InputDevice> _inputDevices = [];

  Future<List<InputDevice>> listDevices() async {
    _inputDevices = await _audioRecorder.listInputDevices();
    return _inputDevices;
  }

  Future<void> startRecord(String deviceLabel) async {
    InputDevice device = _inputDevices.firstWhere(
        (device) => device.label == deviceLabel,
        orElse: () => _inputDevices.first);

    RecordConfig config = RecordConfig(
      encoder: AudioEncoder.pcm16bits,
      sampleRate: 16000,
      numChannels: 1,
      device: device,
    );
    _audioRecorder.startStream(config).then((stream) => {
          stream.listen((data) {
            // Do something with the audio data
            _sendToServer(data);
          }),
        });
  }

  Future<void> stopRecord() async {
    await _audioRecorder.stop();
  }

  void _sendToServer(Uint8List data) {
    print(data);
  }
}
