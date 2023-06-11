import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:webrtcdemo/services/signaling.dart';

class WebRTCView extends StatefulWidget {
  const WebRTCView({super.key});

  @override
  State<WebRTCView> createState() => _WebRTCViewState();
}

class _WebRTCViewState extends State<WebRTCView> {
  Signaling signaling = Signaling();
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();
    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('WebRTC Test'),
      ),
      body: ScreenTypeLayout.builder(
        desktop: (p0) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [SizedBox(width: 900, child: mobile(p0))],
        ),
        mobile: (p0) => mobile(p0),
      ),
    );
  }

  Widget mobile(BuildContext p0) {
    return Column(
      children: [
        Text(signaling.currentRoomText ?? ''),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  signaling.openUserMedia(_localRenderer, _remoteRenderer);
                },
                child: const Text('Open Video and Audio')),
            ElevatedButton(
                onPressed: () {
                  signaling.hangUp(_localRenderer);
                },
                child: const Text('Hang Up')),
            ElevatedButton(
                onPressed: () {
                  signaling.joinRoom(
                    textEditingController.text.trim(),
                    _remoteRenderer,
                  );
                },
                child: const Text('Join a Room')),
            ElevatedButton(
                onPressed: () async {
                  roomId = await signaling.createRoom(_remoteRenderer);
                  textEditingController.text = roomId!;
                  setState(() {});
                },
                child: const Text('Create a Room')),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: RTCVideoView(
                    _localRenderer,
                    mirror: true,
                    placeholderBuilder: (context) => const Placeholder(),
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
                  ),
                ),
                Expanded(
                  child: RTCVideoView(
                    _remoteRenderer,
                    placeholderBuilder: (context) => const Placeholder(),
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Join the following Room: "),
              Flexible(
                child: TextFormField(
                  controller: textEditingController,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
