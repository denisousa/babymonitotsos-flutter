import 'package:flutter/material.dart';
import "package:dart_amqp/dart_amqp.dart";
import "package:threading/threading.dart";


class BabyMonitorPage extends StatefulWidget {
  @override
  _BabyMonitorPageState createState() => _BabyMonitorPageState();
}

class _BabyMonitorPageState extends State<BabyMonitorPage> {
  bool buttonConnection = false;
  bool buttonMessage = false;
  bool buttonShow = false;

  String breathing = 'False';
  String timeNoBreathing = '0';
  String crying = 'False';

  String queueConsume = "tv";
  String queueSend = "smartv";
  String msg = "Hello i am BabyMonitorSoS";
  ConnectionSettings settings = new ConnectionSettings(
    host : "prawn-01.rmq.cloudamqp.com",
    virtualHost: "zwdcwulz",
    authProvider: new AmqPlainAuthenticator("zwdcwulz","Ntmu4OcIDRA8FhOJeNs05JQU17nxuL-5")
  );

  void connection() {
    setState(() {
      buttonConnection = !buttonConnection;
      buttonShow = !buttonShow;
      Client clientReceive = new Client(settings: settings);
      clientReceive
        .channel()
        .then((Channel channel) => channel.queue(queueConsume, durable: false))
        .then((Queue queue) {
            print(" [*] Waiting for messages in ${queueConsume}. To Exit press CTRL+C");
            return queue.consume(consumerTag: queueConsume, noAck: true);
        })
        .then((Consumer consumer) {
            consumer.listen((AmqpMessage event) {
              print(" [x] Received ${event.payloadAsString}");
              breathing = event.payloadAsString.split(" ")[0];
              timeNoBreathing = event.payloadAsString.split(" ")[1];
              crying = event.payloadAsString.split(" ")[2];
            });
        });
    });
  }

  void send() {
    setState(() {
      Client client = new Client(settings: settings);
      buttonMessage = !buttonMessage;
      client.channel().then((Channel channel) {
        return channel.queue(queueSend, durable: false);
      }).then((Queue queue) {
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
            Container(
              margin: EdgeInsets.only(top: 40.0, bottom: 10.0),
              child: Image(
                image: AssetImage('assets/babymonitor.png'),
              )
            ),
            FlatButton(
              color: buttonConnection ? Colors.blueAccent : Colors.black38,
              onPressed: connection,
              child: Text(
                'Connect',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
            buttonShow
                ? FlatButton(
                    color: buttonMessage ? Colors.blueAccent : Colors.black38,
                    onPressed: send,
                    child: Text(  
                      'Send Confirm',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  )
                : Container(),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Column(children: <Widget>[
                Text('Breathing: $breathing', style: TextStyle(fontSize: 14.0)),
                Text('Time-no-breathing: $timeNoBreathing', style: TextStyle(fontSize: 14.0)),
                Text('Crying: $crying', style: TextStyle(fontSize: 14.0)),
              ],),
            ),
          ],
        ));
  }
}
