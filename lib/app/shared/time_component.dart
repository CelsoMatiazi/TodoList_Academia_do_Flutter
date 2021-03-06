import 'package:flutter/material.dart';

class TimeComponent extends StatefulWidget {

  DateTime date;
  ValueChanged<DateTime> onSelectedTime;
  TimeComponent({
    Key? key,
    required this.date,
    required this.onSelectedTime
  }) : super(key: key);

  @override
  _TimeComponentState createState() => _TimeComponentState();
}

class _TimeComponentState extends State<TimeComponent> {


  final List<String> _hours = List.generate(24, (index) => index++).map((h) => '${h.toString().padLeft(2, '0')}').toList();
  final List<String> _min = List.generate(60, (index) => index++).map((h) => '${h.toString().padLeft(2, '0')}').toList();
  final List<String> _sec = List.generate(60, (index) => index++).map((h) => '${h.toString().padLeft(2, '0')}').toList();

  String _hourSelected = '00';
  String _minSelected = '00';
  String _secSelected = '00';

  void invokeCallback(){
    var newDate = DateTime(
        widget.date.year,
        widget.date.month,
        widget.date.day,
        int.parse(_hourSelected),
        int.parse(_minSelected),
        int.parse(_secSelected),
    );

    widget.onSelectedTime(newDate);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildBox(_hours, (value){
          setState(() {
            _hourSelected = value;
            invokeCallback();
          });
        }),
        _buildBox(_min, (value){
          setState(() {
            _minSelected = value;
            invokeCallback();
          });
        }),
        _buildBox(_sec, (value){
          setState(() {
            _secSelected = value;
            invokeCallback();
          });
        }),
      ],
    );
  }

  Widget _buildBox(List<String> options, ValueChanged<String> onChange) {
    return Container(
      height: 110,
      width: 95,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            spreadRadius: 0,
            blurRadius: 10,
            color: Theme.of(context).primaryColor,
            offset: Offset(2, 5)
          )
        ]
      ),

      child: ListWheelScrollView(
        onSelectedItemChanged: (value) => onChange(value.toString().padLeft(2, '0')),
        physics: FixedExtentScrollPhysics(),
        itemExtent: 60,
        perspective: 0.007,
        children: options.map<Text>((e) => Text(e, style: TextStyle(
          fontSize: 40,
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),)).toList()

      ),
    );
  }
}
