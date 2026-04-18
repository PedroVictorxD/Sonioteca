import 'package:flutter_test/flutter_test.dart';
import 'package:sonioteca/domain/entities/track.dart';

void main() {
  group('QueueManager', () {
    test('should add track to queue', () {
      final manager = QueueManager();
      final track = Track(id: '1', title: 'Song', artist: 'Artist', filePath: '/1.mp3', duration: const Duration(minutes: 3));
      
      final updated = manager.addToQueue(track);
      
      expect(updated.queue.length, 1);
    });

    test('should add multiple tracks to queue', () {
      final manager = QueueManager();
      final track1 = Track(id: '1', title: 'Song1', artist: 'Artist', filePath: '/1.mp3', duration: const Duration(minutes: 3));
      final track2 = Track(id: '2', title: 'Song2', artist: 'Artist', filePath: '/2.mp3', duration: const Duration(minutes: 4));
      
      var updated = manager.addToQueue(track1);
      updated = updated.addToQueue(track2);
      
      expect(updated.queue.length, 2);
      expect(updated.queue[0].id, '1');
      expect(updated.queue[1].id, '2');
    });

    test('should remove track from queue', () {
      final manager = QueueManager();
      final track = Track(id: '1', title: 'Song', artist: 'Artist', filePath: '/1.mp3', duration: const Duration(minutes: 3));
      
      final withTrack = manager.addToQueue(track);
      final removed = withTrack.removeFromQueue('1');
      
      expect(removed.queue, isEmpty);
    });

    test('should reorder queue', () {
      final manager = QueueManager();
      final track1 = Track(id: '1', title: 'Song1', artist: 'Artist', filePath: '/1.mp3', duration: const Duration(minutes: 3));
      final track2 = Track(id: '2', title: 'Song2', artist: 'Artist', filePath: '/2.mp3', duration: const Duration(minutes: 4));
      final track3 = Track(id: '3', title: 'Song3', artist: 'Artist', filePath: '/3.mp3', duration: const Duration(minutes: 5));
      
      var updated = manager.addToQueue(track1).addToQueue(track2).addToQueue(track3);
      updated = updated.reorderQueue(0, 2);
      
      expect(updated.queue[0].id, '2');
      expect(updated.queue[1].id, '3');
      expect(updated.queue[2].id, '1');
    });

    test('should clear queue', () {
      final manager = QueueManager();
      final track1 = Track(id: '1', title: 'Song1', artist: 'Artist', filePath: '/1.mp3', duration: const Duration(minutes: 3));
      final track2 = Track(id: '2', title: 'Song2', artist: 'Artist', filePath: '/2.mp3', duration: const Duration(minutes: 4));
      
      final withTracks = manager.addToQueue(track1).addToQueue(track2);
      final cleared = withTracks.clearQueue();
      
      expect(cleared.queue, isEmpty);
    });

    test('should get queue count', () {
      final manager = QueueManager();
      final track1 = Track(id: '1', title: 'Song1', artist: 'Artist', filePath: '/1.mp3', duration: const Duration(minutes: 3));
      final track2 = Track(id: '2', title: 'Song2', artist: 'Artist', filePath: '/2.mp3', duration: const Duration(minutes: 4));
      
      final updated = manager.addToQueue(track1).addToQueue(track2);
      
      expect(updated.queueCount, 2);
    });

    test('should add track to top of queue', () {
      final manager = QueueManager();
      final track1 = Track(id: '1', title: 'Song1', artist: 'Artist', filePath: '/1.mp3', duration: const Duration(minutes: 3));
      final track2 = Track(id: '2', title: 'Song2', artist: 'Artist', filePath: '/2.mp3', duration: const Duration(minutes: 4));
      
      var updated = manager.addToQueue(track1);
      updated = updated.addToQueueNext(track2);
      
      expect(updated.queue[0].id, '2');
      expect(updated.queue[1].id, '1');
    });

    test('should play next from queue', () {
      final manager = QueueManager();
      final track1 = Track(id: '1', title: 'Song1', artist: 'Artist', filePath: '/1.mp3', duration: const Duration(minutes: 3));
      final track2 = Track(id: '2', title: 'Song2', artist: 'Artist', filePath: '/2.mp3', duration: const Duration(minutes: 4));
      
      final withTracks = manager.addToQueue(track1).addToQueue(track2);
      final next = withTracks.playNext();
      
      expect(next.track?.id, '1');
      expect(next.queue.queueCount, 1);
    });
  });
}

class QueueManager {
  final List<Track> queue;
  
  const QueueManager({this.queue = const []});
  
  QueueManager addToQueue(Track track) {
    return QueueManager(queue: [...queue, track]);
  }
  
  QueueManager addToQueueNext(Track track) {
    return QueueManager(queue: [track, ...queue]);
  }
  
  QueueManager removeFromQueue(String trackId) {
    return QueueManager(
      queue: queue.where((t) => t.id != trackId).toList(),
    );
  }
  
  QueueManager reorderQueue(int oldIndex, int newIndex) {
    final newQueue = List<Track>.from(queue);
    final item = newQueue.removeAt(oldIndex);
    newQueue.insert(newIndex, item);
    return QueueManager(queue: newQueue);
  }
  
  QueueManager clearQueue() => const QueueManager();
  
  int get queueCount => queue.length;
  
  ({QueueManager queue, Track? track}) playNext() {
    if (queue.isEmpty) {
      return (queue: this, track: null);
    }
    final next = queue.first;
    return (queue: removeFromQueue(next.id), track: next);
  }
}