import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rsclasses/Enroll/Enrollment.dart';
import 'package:rsclasses/Login/LoginPageA.dart';
import 'package:rsclasses/Pages/AccountPage.dart';
import 'package:rsclasses/Pages/Attendance.dart';
import 'package:rsclasses/Pages/ClassMessage.dart';
import 'package:rsclasses/Pages/CoursePage.dart';
import 'package:rsclasses/Pages/Grades.dart';
import 'package:rsclasses/Pages/Schedule.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String tDate,sDay;
  DateTime today;
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String sitem = "";

  Future<DocumentSnapshot> getData() async {
    return await FirebaseFirestore.instance.collection('Users').doc(await FirebaseAuth.instance.currentUser.phoneNumber).collection('Account').doc('Profile').get();
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Fluttertoast.showToast(
          msg: "Logged Out...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).cardColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          fontSize: 16.0);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    today = DateTime.now();
    tDate = DateFormat('dd-MM-yyyy').format(today);
    sDay = DateFormat('EEEE').format(today);
    Widget drawerHeader = SizedBox(
      child: Column(
        children: [
          FutureBuilder(
            future: FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser.phoneNumber).collection('Account').doc('Profile').get(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> mdata) {
              if (mdata.hasData) {
                return Column(
                  children: [
                    ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: mdata.data['ProfileImage'],
                        placeholder: (context, url) =>
                            Center(child: Image.asset("images/Spinner2.gif")),
                        fit: BoxFit.cover,
                        width: 120.w,
                        height: 120.h,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      mdata.data['Name'],
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp),
                    )
                  ],
                );
              } else {
                return Center(child: Image.asset("images/DualBall.gif",height: 100));
              }
            },
          ),
          Padding(
            padding:  EdgeInsets.fromLTRB(0, 4.h, 0, 0),
            child: Text(
              FirebaseAuth.instance.currentUser.phoneNumber,
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
          ),
        ],
      ),
    );
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          'HOME',
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 25.sp,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            size: 25.r,
            color: Theme.of(context).accentColor, //20
          ),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
        elevation: 0,
        //toolbarHeight: 60,
        backgroundColor: Theme.of(context).primaryColor,

      ),
      drawer: Drawer(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: ListView(
            children: [
              Padding(
                padding:  EdgeInsets.fromLTRB(10.w, 30.h, 10.w, 15.h),
                child: drawerHeader,
              ),
              Divider(
                thickness: 1.h,
                color: Theme.of(context).accentColor,
                indent: 15.w,
                endIndent: 30.w,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: ListTile(
                  title: Text('Home',
                      style: Theme.of(context).textTheme.bodyText1),
                  leading: Icon(
                    Icons.home,
                    color: Theme.of(context).accentColor, //20
                  ),
                ),
              ),
              InkWell(
                onTap: () => {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) => AccountPage()))
                },
                child: ListTile(
                  title: Text('Account',
                      style: Theme.of(context).textTheme.bodyText1),
                  leading: Icon(Icons.account_circle,
                      color: Theme.of(context).accentColor),
                ),
              ),
              InkWell(
                onTap: () => {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) => Enroll()))
                },
                child: ListTile(
                  title: Text('Enroll',
                      style: Theme.of(context).textTheme.bodyText1),
                  leading: Icon(Icons.shopping_bag,
                      color: Theme.of(context).accentColor),
                ),
              ),
              InkWell(
                onTap: () => {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) => Schedule()))
                },
                child: ListTile(
                  title: Text('My Courses',
                      style: Theme.of(context).textTheme.bodyText1),
                  leading: Icon(Icons.book,
                      color: Theme.of(context).accentColor),
                ),
              ),
              InkWell(
                onTap: () => {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) => Attendance()))
                },
                child: ListTile(
                  title: Text('Attendence',
                      style: Theme.of(context).textTheme.bodyText1),
                  leading: Icon(Icons.date_range_rounded,
                      color: Theme.of(context).accentColor),
                ),
              ),
              InkWell(
                onTap: () => {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) => CoursePage()))
                },
                child: ListTile(
                  title: Text('Course Page',
                      style: Theme.of(context).textTheme.bodyText1),
                  leading: Icon(Icons.menu_book_outlined,
                      color: Theme.of(context).accentColor),
                ),
              ),
              InkWell(
                onTap: () => {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) => ClassMessage()))
                },
                child: ListTile(
                  title: Text('Class Messages',
                      style: Theme.of(context).textTheme.bodyText1),
                  leading: Icon(Icons.message,
                      color: Theme.of(context).accentColor),
                ),
              ),
              InkWell(
                onTap: () => {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) => Grades()))
                },
                child: ListTile(
                  title: Text('Grades',
                      style: Theme.of(context).textTheme.bodyText1),
                  leading: Icon(Icons.score,
                      color: Theme.of(context).accentColor),
                ),
              ),
              Divider(
                thickness: 1.h,
                color: Theme.of(context).accentColor,
                indent: 15.w,
                endIndent: 30.w,
              ),
              InkWell(
                onTap: logout,
                child: ListTile(
                  title: Text('Sign Out',
                      style: Theme.of(context).textTheme.bodyText1),
                  leading: Icon(
                    Icons.logout,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: new ListView(
        children: [
          Padding(
            padding:  EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 8.h),
            child: Text(
              'Classes',
              style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.sp),
            ),
          ),
          StreamBuilder(
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
                                      if (mdoc.data()['Schedule'][sDay] == true) {
                                        if(mdoc.data()['Online'] == true){
                                          var ltime;
                                          DateTime ntime = DateTime.now();
                                          DateTime  ctime = new DateFormat("dd-MM-yyy-HH:mm").parse(DateFormat("dd-MM-yyyy").format(ntime) + '-' + mdoc.data()['StartAt']);
                                          ltime = ntime.difference(ctime).inMinutes;
                                          return Padding(padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context).cardColor,
                                                  borderRadius: BorderRadius.circular(15)),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:MainAxisAlignment.spaceAround,
                                                    children: [
                                                      Center(
                                                        child: Padding(
                                                          padding: EdgeInsets.only(top: 20.h),
                                                          child: Text(
                                                            mdoc.id, style: TextStyle(color: Theme.of(context).accentColor, fontSize: 18.sp, fontWeight: FontWeight.w600),
                                                          ),
                                                        ),
                                                      ),
                                                        SizedBox(
                                                          width: 120.w,
                                                          height: 40.h,
                                                          child: FlatButton(
                                                            onPressed: () async{
                                                              if(ltime >= -5 && ltime <= 30){
                                                              String url = mdoc['ClassLink'];
                                                              if (await canLaunch(url))
                                                                await launch(url);
                                                              else
                                                                throw "Could not launch $url";
                                                            }
                                                              else{
                                                                Fluttertoast.showToast(
                                                                    msg: "Link will be enabled before 5 min of Class Time",
                                                                    toastLength: Toast.LENGTH_SHORT,
                                                                    gravity: ToastGravity.BOTTOM,
                                                                    backgroundColor: Theme.of(context).accentColor,
                                                                    textColor: Theme.of(context).primaryColor,
                                                                    fontSize: 14.0
                                                                );
                                                              }
                                                            },
                                                            child: Padding(
                                                              padding:  EdgeInsets.symmetric(vertical: 8.h),
                                                              child: Text(
                                                                'Start Class',
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
                                                        )
                                                    ],
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
                                                    padding: EdgeInsets.only(top: 10.h,),
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
                                          );
                                        }
                                        else{
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
                                                    padding: EdgeInsets.only(top: 10.h,),
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
                                          );
                                        }
                                      }
                                      else{

                                        return Container(height: 0,width: 0,);
                                      }
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
        ],
      ),
    );
  }
}
