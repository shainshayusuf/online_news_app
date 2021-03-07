import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:online_news_app/models/article.dart';
import 'package:online_news_app/screens/article_view.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math';

class NewsTile extends StatefulWidget {
  final Article article;
  NewsTile({this.article});
  @override
  _NewsTileState createState() => _NewsTileState();
}

class _NewsTileState extends State<NewsTile> {
  DateTime _notificationTime;
  String _notificationTimeString;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Random random = new Random();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ArticleView(widget.article.url)));
      },
      child: Container(
          margin: EdgeInsets.only(bottom: 16),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: widget.article.urlToImage,
                      height: 180,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                        icon: Icon(Icons.notifications),
                        color: Colors.white,
                        onPressed: () {
                          _notificationTimeString =
                              DateFormat('HH:mm').format(DateTime.now());
                          showModalBottomSheet(
                            useRootNavigator: true,
                            context: context,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(24),
                              ),
                            ),
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setModalState) {
                                  return Container(
                                    padding: const EdgeInsets.all(32),
                                    child: Column(
                                      children: [
                                        FlatButton(
                                          onPressed: () async {
                                            var selectedTime =
                                                await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now(),
                                            );
                                            if (selectedTime != null) {
                                              final now = DateTime.now();
                                              var selectedDateTime = DateTime(
                                                  now.year,
                                                  now.month,
                                                  now.day,
                                                  selectedTime.hour,
                                                  selectedTime.minute);
                                              _notificationTime =
                                                  selectedDateTime;
                                              setModalState(() {
                                                _notificationTimeString =
                                                    DateFormat('HH:mm').format(
                                                        selectedDateTime);
                                              });
                                            }
                                          },
                                          child: Text(
                                            _notificationTimeString,
                                            style: TextStyle(fontSize: 32),
                                          ),
                                        ),
                                        SizedBox(height: 10.0),
                                        Text(
                                          'Click on above text to change time',
                                          style: TextStyle(
                                              fontSize: 15, letterSpacing: 2.0),
                                        ),
                                        SizedBox(height: 20.0),
                                        FloatingActionButton.extended(
                                          onPressed: scheduleNotification,
                                          icon: Icon(Icons.alarm),
                                          label: Text('Set  Reminder'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        }),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                widget.article.title,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 6),
              Text(widget.article.description),
              SizedBox(
                height: 6,
              ),
            ],
          )),
    );
  }

  Future<void> scheduleNotification() async {
    var scheduledNotificationDateTime = _notificationTime;
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel id',
      'channel name',
      'channel description',
      icon: 'launch_background',
      largeIcon: DrawableResourceAndroidBitmap('launch_background'),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        random.nextInt(100),
        'Reminder',
        widget.article.title,
        scheduledNotificationDateTime,
        platformChannelSpecifics);
    Navigator.pop(context);
  }
}
