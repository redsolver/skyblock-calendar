import 'package:ical_serializer/ical_serializer.dart';
import 'dart:io';

class Event {
  int start;
  int duration;
  String name;
  Event({
    this.name,
    this.duration,
    this.start,
  });
}

final sDay = Duration(minutes: 20).inMilliseconds;
final sMonth = sDay * 31;

// Source: https://hypixel-skyblock.fandom.com/wiki/Events
final events = [
  Event(
    name: 'Traveling Zoo (Summer)',
    start: sMonth * 3, // Skyblock Month 3 (Early Summer)
    duration: sDay * 3,
  ),
  Event(
    name: 'Spooky Festival',
    start: sMonth * 7 + sDay * 28, // Skyblock Month 7 (Autumn)
    duration: sDay * 3,
  ),
  Event(
    name: 'Traveling Zoo (Winter)',
    start: sMonth * 9, // Skyblock Month 9 (Early Winter)
    duration: sDay * 3,
  ),
  Event(
    name: 'Season of Jerry',
    start: sMonth * 11, // Skyblock Month 11 (Late Winter)
    duration: sDay * 31,
  ),
  Event(
    name: 'Defend Jerry\'s Workshop',
    start: sMonth * 11 + sDay * 23, // Skyblock Month 11 (Late Winter)
    duration: sDay * 3,
  ),
  Event(
    name: 'New Year Celebration',
    start: sMonth * 11 + sDay * 28, // Skyblock Month 11 (Late Winter)
    duration: sDay * 3,
  ),
];

const skyStart = 1560275700000; // Start of Skyblock in milliseconds since 1970
void main() async {
  var cal = ICalendar();
  var i = 0;

  var skyBlockYear = 50;

  while (true) {
    for (var event in events) {
      var time = skyStart +
          Duration(hours: 124).inMilliseconds * skyBlockYear +
          event.start;

      var datetime = DateTime.fromMillisecondsSinceEpoch(time, isUtc: true);

      if (datetime.isBefore(DateTime.now())) continue;

      cal.addElement(
        IEvent(
          uid:
              'sky-${event.name.replaceAll(' ', '_')}-${datetime.toIso8601String()}',
          start: datetime,
          end: datetime
              .add(Duration(milliseconds: event.duration)), // 3 Skyblock Days
          status: IEventStatus.CONFIRMED,
          location: 'Hypixel SkyBlock',
          summary: event.name,
        ),
      );

      i++;
    }
    if (i > 300) break;
    skyBlockYear++;
  }

  File('skyblock-calendar.ics').writeAsStringSync(cal.serialize());
}
