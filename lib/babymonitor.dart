import 'package:flutter/material.dart';
import "package:dart_amqp/dart_amqp.dart";

class BabyMonitorPage extends StatefulWidget {
  @override
  _BabyMonitorPageState createState() => _BabyMonitorPageState();
}

class _BabyMonitorPageState extends State<BabyMonitorPage> {
  bool buttonConnection = false;
  bool buttonMessage = false;
  bool buttonShow = false;

  String consumeTag = "hello";
  String msg = "Hello i am BabyMonitorSoS";
  static ConnectionSettings settings =
      new ConnectionSettings(host: "localhost");
  Client client = new Client(settings: settings);

  void connection() {
    setState(() {
      buttonConnection = !buttonConnection;
      buttonShow = !buttonShow;
    });
  }

  void send() {
    setState(() {
      buttonMessage = !buttonMessage;
      print(client);
      client.channel().then((Channel channel) {
        return channel.queue(consumeTag, durable: false);
      }).then((Queue queue) async {
        assert(queue != null);
        print(queue);
        print(msg);
        queue.publish(msg);
        print(" [x] Sent $msg");
        client.close();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("BabyMonitorSoS"),
          backgroundColor: Colors.blueAccent,
        ),
        body: Column(
          children: <Widget>[
            Text(''),
            Text(''),
            Text(''),
            Image(image: AssetImage('assets/babymonitor.png')),
            FlatButton(
              color: buttonConnection ? Colors.blueAccent : Colors.black38,
              onPressed: connection,
              child: Text(
                'Connect to Broker',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
            buttonShow
                ? FlatButton(
                    color: buttonMessage ? Colors.blueAccent : Colors.black38,
                    onPressed: send,
                    child: Text(
                      'Send a Message',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  )
                : Text(''),
          ],
        ));
  }
}
