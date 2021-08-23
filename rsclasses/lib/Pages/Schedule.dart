import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rsclasses/Enroll/Enrollment.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key key}) : super(key: key);

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  String tDate,sDay;
  DateTime today;
  @override
  Widget build(BuildContext context) {
    today = DateTime.now();
    tDate = DateFormat('dd-MM-yyyy').format(today);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          'My Courses',
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 25.sp,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        //toolbarHeight: 60,
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
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(15)),
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
                                            padding:  EdgeInsets.only(top: 10.h),
                                            child: Text('Schedule',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 16.sp,fontWeight: FontWeight.w400),),
                                          ),
                                        ),
                                        Padding(
                                          padding:  EdgeInsets.only(top:10.h),
                                          child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                if(mdoc['Schedule']['Sunday'] == true)
                                                  Text('Sun',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                                if(mdoc['Schedule']['Monday'] == true)
                                                  Text('Mon',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                                if(mdoc['Schedule']['Tuesday'] == true)
                                                  Text('Tue',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                                if(mdoc['Schedule']['Wednesday'] == true)
                                                  Text('Wed',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                                if(mdoc['Schedule']['Thursday'] == true)
                                                  Text('Thu',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                                if(mdoc['Schedule']['Friday'] == true)
                                                  Text('Fri',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                                if(mdoc['Schedule']['Saturday'] == true)
                                                  Text('Sat',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                              ]

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
                                );
                            }
                            else{
                              return Padding(
                                padding: EdgeInsets.only(top:10.h,left:10.w,right: 10.w),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Stack(
                                    children: [
                                      Column(
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding:  EdgeInsets.only(top: 20.h),
                                            child: Text(mdoc.id,style: TextStyle(color: Theme.of(context).accentColor,fontSize: 18.sp,fontWeight: FontWeight.w600),),
                                          ),
                                        ),
                                        Padding(
                                          padding:  EdgeInsets.only(top:10.h),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Text('Subscription Expired',style: TextStyle(color: Colors.red,fontSize: 16.sp,fontWeight: FontWeight.w500),),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:  EdgeInsets.only(top:10.h),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Text('Class: ' + mdoc['Class'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                              Text('Subject Code: ' + mdoc['Subject'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:  EdgeInsets.only(top:10.h,bottom: 20.h),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Text('Timing: ' + mdoc['StartAt'] + ' - ' + mdoc['EndAt'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                              Text('Location: ' + mdoc['Location'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: SizedBox(
                                          width: 90.w,
                                          height: 60.h,
                                          child: FlatButton(
                                            onPressed: () async{
                                              DocumentSnapshot mydata =   await FirebaseFirestore.instance.collection('Subjects').doc(mdoc['Subject']).get();
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(builder: (BuildContext context) => Enroll(gclass: mdoc['Class'],gsub: mydata.data()['Name'],gbatch: mdoc.id,)));
                                            },
                                            child: Padding(
                                              padding:  EdgeInsets.symmetric(vertical: 8.h),
                                              child: Text(
                                                'Renew',
                                                style: TextStyle(
                                                    color: Theme.of(context).primaryColor,
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w400),
                                              ),
                                            ),
                                            color: Theme.of(context).accentColor,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0)),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
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
