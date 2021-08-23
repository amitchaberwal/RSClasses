import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
class Attendance extends StatefulWidget {
  const Attendance({Key key}) : super(key: key);

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  DateTime today;
  @override
  Widget build(BuildContext context) {
    today = DateTime.now();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          'Attendance',
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 25.sp,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Batch').orderBy('StartAt',descending: true).snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot>snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: snapshot.data.docs.map((mdoc) => FutureBuilder(
                      future: FirebaseFirestore.instance.collection('Batch').doc(mdoc.id).collection('Enrollments').doc(FirebaseAuth.instance.currentUser.phoneNumber).get(),
                      builder: (context, AsyncSnapshot<DocumentSnapshot>mdata) {
                        if (mdata.hasData) {
                          if(mdata.data.exists){
                            DateTime  sdate = new DateFormat("dd-MM-yyyy").parse(mdata.data['EndDate']);
                            if(today.isBefore(sdate)){
                              return Padding(padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                                child: InkWell(
                                  onTap: (){
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (BuildContext context) => GetAttendance(BatchId: mdoc.id,)));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(20)),
                                    child: Column(
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 20.h),
                                            child: Text(
                                              mdoc.id, style: TextStyle(color: Theme.of(context).accentColor, fontSize: 18.sp, fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 10.h),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Text('Class: ' + mdoc['Class'], style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 14.sp, fontWeight: FontWeight.w300),),
                                              Text('Subject Code: ' + mdoc['Subject'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 14.sp, fontWeight: FontWeight.w300)),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 10.h),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Text('Timing: ' + mdoc['StartAt'] + ' - ' + mdoc['EndAt'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 14.sp, fontWeight: FontWeight.w300)),
                                              Text('Location: ' + mdoc['Location'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 14.sp, fontWeight: FontWeight.w300),),
                                            ],
                                          ),
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 10.h),
                                            child: Text(
                                              'Faculty', style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 16.sp, fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:  EdgeInsets.only(top: 10.h,bottom: 20.h),
                                          child: FutureBuilder(
                                              future: FirebaseFirestore.instance.collection('Staff').doc(mdoc['Faculty']).get(),
                                              builder: (context, AsyncSnapshot<DocumentSnapshot>mdataa) {
                                                if (mdataa.hasData) {
                                                  return Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      Text('Name: ' + mdataa.data['Name'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 14.sp, fontWeight: FontWeight.w300)),
                                                      Text('Phone: ' + mdoc['Faculty'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 14.sp, fontWeight: FontWeight.w300),),
                                                    ],
                                                  );
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                            else{
                              return Container(height: 0,width: 0,);
                            }
                          }
                          else{
                            return Container(height: 0,width: 0,);
                          }
                        } else {
                          return Container(height: 0,width: 0,);
                        }
                      }),
                  ).toList(),
                );
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
    );
  }

}

class GetAttendance extends StatefulWidget {
  final String BatchId;
  const GetAttendance({Key key, this.BatchId}) : super(key: key);

  @override
  _GetAttendanceState createState() => _GetAttendanceState();
}

class _GetAttendanceState extends State<GetAttendance> {
  String sBatch;
  String syear,smonth,tmonth;
  int tdate,imonth =0,iyear = 0;
  List<String> sMonths = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  @override
  void initState() {
    super.initState();
    DateTime today = DateTime.now();
    syear = DateFormat('yyyy').format(today);
    tmonth = DateFormat('MM').format(today);
    tdate = int.parse(DateFormat('dd').format(today));
    setState(() {
      imonth = int.parse(tmonth);
      iyear = int.parse(syear);
    });
  }
  @override
  int getdays(){
    DateTime  date = new DateFormat("MM-yyyy").parse( imonth.toString() +'-' + iyear.toString());
    int daysInMonth = DateTimeRange(
        start: date,
        end: DateTime(date.year, date.month + 1)).duration.inDays;
    return daysInMonth;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          'Attendance',
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 25.sp,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
           children: [
             Row(
               children: [
                 CircleAvatar(
                   backgroundColor: Colors.green,
                   radius: 10.r,
                 ),
                 Padding(
                   padding:  EdgeInsets.only(left:10.w),
                   child: Text(
                     'Present',
                     style: TextStyle(
                         color: Theme.of(context).secondaryHeaderColor,
                         fontSize: 16.sp,
                         fontWeight: FontWeight.w300),
                   ),
                 ),
               ],
             ),
             Row(
               children: [
                 CircleAvatar(
                   backgroundColor: Colors.red,
                   radius: 10.r,
                 ),
                 Padding(
                   padding:  EdgeInsets.only(left:10.w),
                   child: Text(
                     'Absent',
                     style: TextStyle(
                         color: Theme.of(context).secondaryHeaderColor,
                         fontSize: 16.sp,
                         fontWeight: FontWeight.w300),
                   ),
                 ),
               ],
             ),
            ],
          ),
            Padding(
              padding:  EdgeInsets.only(top:20.h,bottom: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_rounded,size: 30.r,color: Theme.of(context).accentColor),
                    onPressed: (){
                      setState(() {
                        imonth -= 1;
                        if(imonth < 1){
                          iyear -=1;
                          imonth = 12;
                        }
                      });
                    },
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 30.w),
                    child: Center(
                      child: Text(
                        sMonths[imonth-1] + ' , ' + iyear.toString(),
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).secondaryHeaderColor),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios_rounded,size: 30.r,color: Theme.of(context).accentColor,),
                    onPressed: (){
                      setState(() {
                        imonth += 1;
                        if(imonth > 12){
                          iyear +=1;
                          imonth = 1;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 5.w),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('Batch').doc(widget.BatchId).collection('Attendance').where('MonthYear',isEqualTo: imonth.toString().padLeft(2, '0') + '-' + iyear.toString()).where('Students',arrayContains: FirebaseAuth.instance.currentUser.phoneNumber).snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot>snapshot) {
                          if (snapshot.hasData) {
                            Map<String,bool> attend = new Map();
                            snapshot.data.docs.forEach((element) {
                              attend[element.id] = element.data()[FirebaseAuth.instance.currentUser.phoneNumber];
                            });
                            return Padding(
                              padding: EdgeInsets.only(bottom: 10.h,top:10,right: 10.w,left: 10.w),
                              child: Wrap(
                                children: List.generate(getdays(), (index) {
                                  if(attend[((index + 1).toString()+ '-' + imonth.toString().padLeft(2, '0') + '-' + iyear.toString())] != null){
                                    if(attend[((index + 1).toString()+ '-' + imonth.toString().padLeft(2, '0') + '-' + iyear.toString())] == true){
                                      return Padding(
                                        padding:  EdgeInsets.symmetric(horizontal: 5.w,vertical: 5.h),
                                        child: CircleAvatar(
                                          radius: 20.r,
                                          backgroundColor: Colors.green,
                                          child: Center(
                                            child: Text((index + 1).toString(),
                                              style: TextStyle(
                                                  color: Theme.of(context).secondaryHeaderColor,
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    else{
                                      return Padding(
                                        padding:  EdgeInsets.symmetric(horizontal: 5.w,vertical: 5.h),
                                        child: CircleAvatar(
                                          radius: 20.r,
                                          backgroundColor: Colors.red,
                                          child: Center(
                                            child: Text((index + 1).toString(),
                                              style: TextStyle(
                                                  color: Theme.of(context).secondaryHeaderColor,
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                  else{
                                    return Padding(
                                      padding:  EdgeInsets.symmetric(horizontal: 5.w,vertical: 5.h),
                                      child: CircleAvatar(
                                        radius: 20.r,
                                        backgroundColor: Theme.of(context).primaryColor,
                                        child: Center(
                                          child: Text((index + 1).toString(),
                                            style: TextStyle(
                                                color: Theme.of(context).secondaryHeaderColor,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }
                                ),
                              ),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        }),
                  ),
                ),
              ],
            ),


        ],
      ),
    );
  }
}

