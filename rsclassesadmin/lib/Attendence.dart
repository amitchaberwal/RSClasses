import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key key}) : super(key: key);

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  String sBatch;
  String syear,smonth,tmonth;
  int tdate;
  @override

  int getdays(int m){
    DateTime  date = new DateFormat("MM-yyyy").parse( m.toString() +'-' + syear);
    int daysInMonth = DateTimeRange(
        start: date,
        end: DateTime(date.year, date.month + 1)).duration.inDays;
    return daysInMonth;
  }
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    syear = DateFormat('yyyy').format(today);
    tmonth = DateFormat('MM').format(today);
    tdate = int.parse(DateFormat('dd').format(today));
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          'Attendance',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 25.sp,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: ListView(
        children: [
          Padding(
            padding:  EdgeInsets.only(top:10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 280.w,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('Batch').snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.docs.isNotEmpty) {
                            return DropdownButtonFormField(
                              hint: Text(
                                'Choose Batch',
                                style: TextStyle(
                                    color: Theme.of(context).secondaryHeaderColor),
                              ),
                              style: TextStyle(color: Colors.white),
                              value: sBatch,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(30.0),
                                  ),
                                ),
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  sBatch = newValue;
                                });
                              },
                              items: snapshot.data.docs.map((document) {
                                return DropdownMenuItem(
                                  child: new Text(
                                    document.id,
                                    style: TextStyle(
                                        color:
                                        Theme.of(context).secondaryHeaderColor),
                                  ),
                                  value: document.id,
                                );
                              }).toList(),
                            );
                          } else {
                            return Text(
                              'Classes not found...',
                              style: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor),
                            );
                          }
                        } else {
                          return Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Getting Class...',
                                    style: TextStyle(
                                        color: Theme.of(context).secondaryHeaderColor),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  SizedBox(
                                      width: 20.w,
                                      height: 20.h,
                                      child: CircularProgressIndicator()),
                                ],
                              ));
                        }
                      }),
                ),
                SizedBox(
                  width: 80.w,
                  child: TextFormField(
                    controller: TextEditingController(text: syear),
                    keyboardType: TextInputType.number,
                    decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(15),
                          ),
                        ),
                        filled: true,
                        hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                        hintText: "Year",
                        fillColor: Theme.of(context).cardColor),
                    onChanged: (value) {
                      syear = value;
                    },
                  ),
                ),
              ],
            ),
          ),
          if(sBatch != null)
          Column(
            children: [
              ExpansionTile(
                initiallyExpanded: (tmonth == '01')?true:false,
                title: Text(
                'January',
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600),
              ),
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: Wrap(
                      children: List.generate(getdays(1), (index) =>
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 2.w,vertical: 2.h),
                            child: InkWell(
                              onTap: (){
                                String dt = (index+1).toString() + '-01-' + syear;
                                showDialog(context: context,
                                    builder: (BuildContext context){
                                      return PostAttendance(mbatch: sBatch,mdate: dt,);
                                    }
                                );
                              },
                              child: Container(
                                height: 50.h,
                                width: 50.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text((index + 1).toString(),
                                    style: TextStyle(
                                        color: Theme.of(context).secondaryHeaderColor,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                          )
                      ),
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                initiallyExpanded: (tmonth == '02')?true:false,title: Text(
                'February',
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600),
              ),
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: Wrap(
                      children: List.generate(getdays(2), (index) =>
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 2.w,vertical: 2.h),
                            child: InkWell(
                              onTap: (){
                                String dt = (index+1).toString() + '-02-' + syear;
                                showDialog(context: context,
                                    builder: (BuildContext context){
                                      return PostAttendance(mbatch: sBatch,mdate: dt,);
                                    }
                                );
                              },
                              child: Container(
                                height: 50.h,
                                width: 50.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text((index + 1).toString(),
                                    style: TextStyle(
                                        color: Theme.of(context).secondaryHeaderColor,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                          )
                      ),
                    ),
                  ),
                ],
              ),
              ExpansionTile(initiallyExpanded: (tmonth == '03')?true:false,
                title: Text(
                'March',
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600),
              ),
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: Wrap(
                      children: List.generate(getdays(3), (index) =>
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 2.w,vertical: 2.h),
                            child: InkWell(
                              onTap: (){
                                String dt = (index+1).toString() + '-03-' + syear;
                                showDialog(context: context,
                                    builder: (BuildContext context){
                                      return PostAttendance(mbatch: sBatch,mdate: dt,);
                                    }
                                );
                              },
                              child: Container(
                                height: 50.h,
                                width: 50.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text((index + 1).toString(),
                                    style: TextStyle(
                                        color: Theme.of(context).secondaryHeaderColor,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                          )
                      ),
                    ),
                  ),
                ],
              ),
              ExpansionTile(initiallyExpanded: (tmonth == '04')?true:false,
                title: Text(
                'April',
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600),
              ),
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: Wrap(
                      children: List.generate(getdays(4), (index) =>
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 2.w,vertical: 2.h),
                            child: InkWell(
                              onTap: (){
                                String dt = (index+1).toString() + '-04-' + syear;
                                showDialog(context: context,
                                    builder: (BuildContext context){
                                      return PostAttendance(mbatch: sBatch,mdate: dt,);
                                    }
                                );
                              },
                              child: Container(
                                height: 50.h,
                                width: 50.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text((index + 1).toString(),
                                    style: TextStyle(
                                        color: Theme.of(context).secondaryHeaderColor,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                          )
                      ),
                    ),
                  ),
                ],
              ),
              ExpansionTile(initiallyExpanded: (tmonth == '05')?true:false,
                title: Text(
                'May',
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600),
              ),
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: Wrap(
                      children: List.generate(getdays(5), (index) =>
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 2.w,vertical: 2.h),
                            child: InkWell(
                              onTap: (){
                                String dt = (index+1).toString() + '-05-' + syear;
                                showDialog(context: context,
                                    builder: (BuildContext context){
                                      return PostAttendance(mbatch: sBatch,mdate: dt,);
                                    }
                                );
                              },
                              child: Container(
                                height: 50.h,
                                width: 50.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text((index + 1).toString(),
                                    style: TextStyle(
                                        color: Theme.of(context).secondaryHeaderColor,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                          )
                      ),
                    ),
                  ),
                ],
              ),
              ExpansionTile(initiallyExpanded: (tmonth == '06')?true:false,
                title: Text(
                'June',
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600),
              ),
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: Wrap(
                      children: List.generate(getdays(6), (index) =>
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 2.w,vertical: 2.h),
                            child: InkWell(
                              onTap: (){
                                String dt = (index+1).toString() + '-06-' + syear;
                                showDialog(context: context,
                                    builder: (BuildContext context){
                                      return PostAttendance(mbatch: sBatch,mdate: dt,);
                                    }
                                );
                              },
                              child: Container(
                                height: 50.h,
                                width: 50.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text((index + 1).toString(),
                                    style: TextStyle(
                                        color: Theme.of(context).secondaryHeaderColor,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                          )
                      ),
                    ),
                  ),
                ],
              ),
              ExpansionTile(initiallyExpanded: (tmonth == '07')?true:false,
                title: Text(
                'July',
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600),
              ),
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: Wrap(
                      children: List.generate(getdays(7), (index) =>
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 2.w,vertical: 2.h),
                            child: InkWell(
                              onTap: (){
                                String dt = (index+1).toString() + '-07-' + syear;
                                showDialog(context: context,
                                    builder: (BuildContext context){
                                      return PostAttendance(mbatch: sBatch,mdate: dt,);
                                    }
                                );
                              },
                              child: Container(
                                height: 50.h,
                                width: 50.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text((index + 1).toString(),
                                    style: TextStyle(
                                        color: Theme.of(context).secondaryHeaderColor,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                          )
                      ),
                    ),
                  ),
                ],
              ),
              ExpansionTile(initiallyExpanded: (tmonth == '08')?true:false,
                title: Text(
                'August',
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600),
              ),
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: Wrap(
                      children: List.generate(getdays(8), (index) =>
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 2.w,vertical: 2.h),
                            child: InkWell(
                              onTap: (){
                                String dt = (index+1).toString() + '-08-' + syear;
                                showDialog(context: context,
                                    builder: (BuildContext context){
                                      return PostAttendance(mbatch: sBatch,mdate: dt,);
                                    }
                                );
                              },
                              child: Container(
                                height: 50.h,
                                width: 50.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text((index + 1).toString(),
                                    style: TextStyle(
                                        color: Theme.of(context).secondaryHeaderColor,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                          )
                      ),
                    ),
                  ),
                ],
              ),
              ExpansionTile(initiallyExpanded: (tmonth == '09')?true:false,
                title: Text(
                'September',
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600),
              ),
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: Wrap(
                      children: List.generate(getdays(9), (index) =>
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 2.w,vertical: 2.h),
                            child: InkWell(
                              onTap: (){
                                String dt = (index+1).toString() + '-09-' + syear;
                                showDialog(context: context,
                                    builder: (BuildContext context){
                                      return PostAttendance(mbatch: sBatch,mdate: dt,);
                                    }
                                );
                              },
                              child: Container(
                                height: 50.h,
                                width: 50.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text((index + 1).toString(),
                                    style: TextStyle(
                                        color: Theme.of(context).secondaryHeaderColor,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                          )
                      ),
                    ),
                  ),
                ],
              ),
              ExpansionTile(initiallyExpanded: (tmonth == '10')?true:false,
                title: Text(
                'October',
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600),
              ),
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: Wrap(
                      children: List.generate(getdays(10), (index) =>
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 2.w,vertical: 2.h),
                            child: InkWell(
                              onTap: (){
                                String dt = (index+1).toString() + '-10-' + syear;
                                showDialog(context: context,
                                    builder: (BuildContext context){
                                      return PostAttendance(mbatch: sBatch,mdate: dt,);
                                    }
                                );
                              },
                              child: Container(
                                height: 50.h,
                                width: 50.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text((index + 1).toString(),
                                    style: TextStyle(
                                        color: Theme.of(context).secondaryHeaderColor,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                          )
                      ),
                    ),
                  ),
                ],
              ),
              ExpansionTile(initiallyExpanded: (tmonth == '11')?true:false,
                title: Text(
                'November',
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600),
              ),
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: Wrap(
                      children: List.generate(getdays(11), (index) =>
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 2.w,vertical: 2.h),
                            child: InkWell(
                              onTap: (){
                                String dt = (index+1).toString() + '-11-' + syear;
                                showDialog(context: context,
                                    builder: (BuildContext context){
                                      return PostAttendance(mbatch: sBatch,mdate: dt,);
                                    }
                                );
                              },
                              child: Container(
                                height: 50.h,
                                width: 50.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text((index + 1).toString(),
                                    style: TextStyle(
                                        color: Theme.of(context).secondaryHeaderColor,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                          )
                      ),
                    ),
                  ),
                ],
              ),
              ExpansionTile(initiallyExpanded: (tmonth == '12')?true:false,
                title: Text(
                'December',
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600),
              ),
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: Wrap(
                      children: List.generate(getdays(12), (index) =>
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 2.w,vertical: 2.h),
                            child: InkWell(
                              onTap: (){
                                String dt = (index+1).toString() + '-12-' + syear;
                                showDialog(context: context,
                                    builder: (BuildContext context){
                                      return PostAttendance(mbatch: sBatch,mdate: dt,);
                                    }
                                );
                              },
                              child: Container(
                                height: 50.h,
                                width: 50.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text((index + 1).toString(),
                                    style: TextStyle(
                                        color: Theme.of(context).secondaryHeaderColor,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                          )
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class PostAttendance extends StatefulWidget {
  final String mdate,mbatch;
  const PostAttendance({Key key, this.mdate, this.mbatch}) : super(key: key);

  @override
  _PostAttendanceState createState() => _PostAttendanceState();
}

class _PostAttendanceState extends State<PostAttendance> {
  Map<String,dynamic> attendance = new Map();
  ProgressDialog pr;
  bool processed = false;
  List<String> AllStudents = new List();
  DateTime aDate,sDate;
  String dMY;
  @override
  void initState() {
    aDate = new DateFormat("dd-MM-yyyy").parse(widget.mdate);
    dMY = new DateFormat("MM-yyyy").format(aDate);
    super.initState();
    getAttendance();
  }
  void getAttendance()async{
    DocumentSnapshot ds = await FirebaseFirestore.instance.collection('Batch').doc(widget.mbatch).collection('Attendance').doc(widget.mdate).get();
    if(ds.exists){
      attendance = ds.data();
    }
    setState(() {
      processed = true;
    });
  }
  Future uploadAttendance(BuildContext context) async {
      await pr.show();
      attendance['MonthYear'] = dMY;
      attendance['Students'] = AllStudents;
      await FirebaseFirestore.instance.collection('Batch').doc(widget.mbatch).collection('Attendance').doc(widget.mdate).set(attendance);
      Fluttertoast.showToast(
          msg: "Attendance Posted...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).cardColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          fontSize: 16.0
      );
      await pr.hide();
      Navigator.pop(context);

  }
  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
        message: 'Posting..',
        borderRadius: 10.0,
        backgroundColor: Theme.of(context).primaryColor,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.sp, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Theme.of(context).secondaryHeaderColor, fontSize: 19.sp, fontWeight: FontWeight.w600)
    );
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
          height: 600.h,
          margin: EdgeInsets.only(top: 1.h),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListView(children: <Widget>[
            Padding(
              padding:  EdgeInsets.only(top: 10.h),
              child: Center(
                child: Text(
                  widget.mbatch,
                  style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            (processed == true)?
            Container(
              height: 520.h,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('Batch').doc(widget.mbatch).collection('Enrollments').snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot>snapshot) {
                    if (snapshot.hasData) {
                      return ListView(
                        children: snapshot.data.docs.map((mdoc)  {
                          sDate = new DateFormat("dd-MM-yyyy").parse(mdoc['EndDate']);
                          if(aDate.isBefore(sDate)){
                            return Padding(
                              padding:  EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 0),
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 100.w,
                                    child: Column(
                                      children: [
                                        Text(mdoc['Name'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w400),),
                                        Text(mdoc.id,style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 12.sp,fontWeight: FontWeight.w300),),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        children: [
                                          Radio(value: true, groupValue: attendance[mdoc.id], onChanged:(e){
                                            setState(() {
                                              attendance[mdoc.id] = e;
                                              if(AllStudents.contains(mdoc.id)){
                                              }
                                              else{
                                                AllStudents.add(mdoc.id);
                                              }
                                            });
                                          }),
                                          Text('Present',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(value: false, groupValue: attendance[mdoc.id], onChanged:(e){
                                            setState(() {
                                              attendance[mdoc.id] = e;
                                              if(AllStudents.contains(mdoc.id)){
                                              }
                                              else{
                                                AllStudents.add(mdoc.id);
                                              }
                                            });
                                          }),
                                          Text('Absent',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                        ],
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            );
                          }
                          else{
                            return Container(height: 0,width: 0,);
                          }
                          }
                        ).toList(),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            ):
        Container(height: 520.h,
        child: Center(
          child: Container(
            height: 50.h,
            width: 50.w,
            child: CircularProgressIndicator(),
          ),
        ),),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                FlatButton(
                  minWidth: 150.w,
                  child: Text('Cancel',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 18.sp,fontWeight: FontWeight.w600)),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  minWidth: 150.w,
                  child: Text('Post',style: TextStyle(color: Theme.of(context).accentColor,fontSize: 18.sp,fontWeight: FontWeight.w600),),
                  onPressed: (){
                    uploadAttendance(context);
                  },
                ),
              ],
            ),
          ])),
    );
  }
}

