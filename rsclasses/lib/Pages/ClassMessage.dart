import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
class ClassMessage extends StatefulWidget {
  const ClassMessage({Key key}) : super(key: key);

  @override
  _ClassMessageState createState() => _ClassMessageState();
}

class _ClassMessageState extends State<ClassMessage> {
  DateTime today;
  @override
  Widget build(BuildContext context) {
    today = DateTime.now();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          'Class Messages',
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
                                        .push(MaterialPageRoute(builder: (BuildContext context) => getMessages(batchID: mdoc.id,)));
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

class getMessages extends StatefulWidget {
  final String batchID;
  const getMessages({Key key, this.batchID}) : super(key: key);

  @override
  _getMessagesState createState() => _getMessagesState();
}

class _getMessagesState extends State<getMessages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          widget.batchID,
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
          StreamBuilder(
              stream: FirebaseFirestore.instance.collection('Batch').doc(widget.batchID).collection('ClassMessage').orderBy('PostDate',descending: true).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot>snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.docs.map((mdoc) => Padding(
                      padding:  EdgeInsets.fromLTRB(10.w, 10.h, 10.w,0),
                      child: Container(
                        width: 400.w,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: (mdoc['Link'] != null)?Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding:  EdgeInsets.only(top:10.h),
                                  child: Container(width:280.w,child: Center(child: Text(mdoc['Title'],style: TextStyle(color: Theme.of(context).accentColor,fontSize: 16.sp,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,))),
                                ),
                                Padding(
                                  padding:  EdgeInsets.only(top:10.h),
                                  child: Container(width:280.w,child: Center(child: Text(mdoc['Message'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 12.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.ellipsis,))),
                                ),
                                Padding(
                                  padding:  EdgeInsets.only(top:10.h),
                                  child: Center(child: Text(mdoc['PostDate'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.ellipsis,)),
                                ),
                                SizedBox(
                                  height: 10.h,
                                )

                              ],
                            ),
                            Container(
                              height: 50.h,
                              child: FlatButton(
                                shape: CircleBorder(
                                ),
                                onPressed: () async{
                                  String url = mdoc['Link'];
                                  if (await canLaunch(url))
                                  await launch(url);
                                  else
                                  // can't launch url, there is some error
                                  throw "Could not launch $url";
                                },
                                child: Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,size: 30.r,),
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          ],
                        )
                            :
                        Column(
                          children: [
                            Padding(
                              padding:  EdgeInsets.only(top:10.h),
                              child: Container(width:380.w,child: Center(child: Text(mdoc['Title'],style: TextStyle(color: Theme.of(context).accentColor,fontSize: 16.sp,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,))),
                            ),
                            Padding(
                              padding:  EdgeInsets.only(top:10.h),
                              child: Container(width:380.w,child: Center(child: Text(mdoc['Message'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 12.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.ellipsis,))),
                            ),
                            Padding(
                              padding:  EdgeInsets.only(top:10.h),
                              child: Container(width:380.w,child: Center(child: Text(mdoc['PostDate'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.ellipsis,))),
                            ),
                            SizedBox(
                              height: 10.h,
                            )

                          ],
                        ),
                      ),
                    )
                    ).toList(),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ],
      ),
    );
  }
}



