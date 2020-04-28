import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_service/background/audio-context.dart';

class AudioTask extends BackgroundAudioTask {
  final AudioContext _context = AudioContext();
  final Completer _completer = Completer();

  Future<void> onStart() async {
    _context.mediaPlayer.playbackStateStream
        .where((state) => state == AudioPlaybackState.completed)
        .listen((_) => _dispose());

    await _completer.future;
  }

  @override
  void onStop() => _stop();
  void _stop() async {
    await _context.stateHandler.stop();
    await _dispose();
  }

  @override
  void onPause() => _context.stateHandler.pause();

  @override
  void onPlay() => _context.stateHandler.play();

  @override
  void onPlayFromMediaId(String mediaId) => _onPlayFromMediaId(mediaId);
  void _onPlayFromMediaId(String mediaId) async {
    final future = _context.stateHandler.setUrl(mediaId);
    _context.stateHandler.play();
    await future;
  }
  
  @override
  void onFastForward() => onSeekTo((_context.playBackState?.currentPosition ?? 0) + 15 * Duration.millisecondsPerSecond);

  @override
  void onRewind() => onSeekTo((_context.playBackState?.currentPosition ?? 0) - 15 * Duration.millisecondsPerSecond);

  @override
  void onSeekTo(int position) {
    _context.stateHandler.seek(Duration(milliseconds: position));
  }

  @override
  void onCustomAction(String name, dynamic arguments) {}

  Future<void> _dispose() async {
    await _context.mediaPlayer.dispose();
    _completer.complete();
  }

  @override
  void onAudioFocusGained() {}
  @override
  void onAudioFocusLost() {}
  @override
  void onAudioFocusLostTransient() {}
  @override
  void onAudioFocusLostTransientCanDuck() {}
  @override
  void onAudioBecomingNoisy() {}
  @override
  void onClick(MediaButton button) {}
  @override
  void onPrepare() {}
  @override
  void onPrepareFromMediaId(String mediaId) {}
  @override
  void onAddQueueItem(MediaItem mediaItem) {}
  @override
  void onAddQueueItemAt(MediaItem mediaItem, int index) {}
  @override
  void onRemoveQueueItem(MediaItem mediaItem) {}
  @override
  void onSkipToNext() {}
  @override
  void onSkipToPrevious() {}
  @override
  void onSkipToQueueItem(String mediaId) {}
  @override
  void onSetRating(Rating rating, Map<dynamic, dynamic> extras) {}
}
