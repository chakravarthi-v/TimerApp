import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/services.dart';

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  CountDownController _controller = CountDownController();
  bool _isPause = false;
  bool _isTicking=true;
  int hours=0;
  int minutes=0;
  int seconds=0;
  bool changed=false;
  int duration=0;
  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      //Appbar of the App
      appBar: AppBar(iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
        title:Text('Timer',style:TextStyle(color: Colors.black,
            fontWeight:FontWeight.w500,
            fontSize: 25,
            letterSpacing: 0.1),),),
      body: Padding(
        padding: const EdgeInsets.only(top:80.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  Padding(
                    padding: const EdgeInsets.fromLTRB(90,0,90,0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        //text input fields-hours
                        Flexible(
                          child: TextField(
                            textAlign: TextAlign.center,
                            maxLength: 2,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(hintText: "HH",),
                            textInputAction: TextInputAction.next,
                            onEditingComplete: ()=>node.nextFocus(),
                            onChanged:(value) {
                              setState(() {
                                hours=int.parse(value);
                              });
                              },
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        //text input fields-minutes
                        Flexible(
                          child:TextField(
                            maxLength: 2,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(hintText: "MM",contentPadding: EdgeInsets.all(4),),
                            textInputAction: TextInputAction.next,
                            onEditingComplete: ()=>node.nextFocus(),
                            onChanged: (value) {
                              setState(() {
                                minutes=int.parse(value);
                              });
                              },
                        ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        //text input fields-seconds
                        Flexible(
                          child: TextField(
                            maxLength: 2,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(hintText: "SS"),
                            textInputAction: TextInputAction.next,
                            onEditingComplete: ()=>node.unfocus(),
                            onChanged: (value) {
                              seconds=int.parse(value);
                              setState(() {
                                duration=(hours*3600)+(minutes*60)+seconds;
                                changed=true;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  //countdown Animation widget where the input duration is given in seconds
                  Center(
                    child: CircularCountDownTimer(
                      duration:duration,
                      autoStart: false,
                      controller: _controller,
                      width: MediaQuery.of(context).size.width/2,
                      height: MediaQuery.of(context).size.height/2.5,
                      ringColor: Colors.blueGrey[100],
                      fillColor: Colors.blueGrey,
                      backgroundColor: null,
                      strokeWidth: 20,
                      textStyle: TextStyle(
                          fontSize: 22.0,
                          letterSpacing: 5.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                      isReverse: true,
                      isReverseAnimation: true,
                      isTimerTextShown: true,
                      onComplete: () {
                        setState(() {
                          _isPause=false;
                          _isTicking=false;
                        });
                      },
                    ),
                  ),
                  //Start Timer Button
                  ButtonTheme(
                      minWidth: 240.0,
                      height: 50.0,
                    child: RaisedButton(
                        color: Colors.blueGrey,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: EdgeInsets.all(10),
                        child: Text("Start"),
                        onPressed:(){
                          print(duration);
                          setState(() {
                            if(changed) {
                              _controller.restart(duration: duration);
                              changed=false;
                            }
                          });
                        }),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  //Pause and continue button of the timer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70.0),
                          color: Colors.blueGrey,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: IconButton(
                              icon: Icon(
                                _isTicking?_isPause? Icons.play_arrow : Icons.pause:Icons.pause,
                                size: 30.0,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (_isPause) {
                                    _isPause = false;
                                    _controller.resume();
                                  } else {
                                    _isPause = true;
                                    _controller.pause();
                                  }
                                });
                                _isPause ? _controller.pause() : _controller.resume();
                              }),
                        ),
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      //Restart button of the Timer
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70.0),
                          color: Colors.blueGrey,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: IconButton(
                              icon: Icon(
                                Icons.refresh_sharp,
                                size: 30.0,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                _controller.restart();
                                setState(() {
                                  _isPause=false;
                                  _isTicking=true;
                                });
                              }
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
