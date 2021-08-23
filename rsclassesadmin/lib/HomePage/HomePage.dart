import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rsclassesadmin/Attendence.dart';
import 'package:rsclassesadmin/ClassMessage.dart';
import 'package:rsclassesadmin/CoursePage.dart';
import 'package:rsclassesadmin/Enrollment.dart';
import 'package:rsclassesadmin/Grades.dart';
import 'package:rsclassesadmin/ManageDatabase/ManageDatabase.dart';
import 'package:rsclassesadmin/Pages/Login/Splash.dart';
import 'package:rsclassesadmin/Transactions.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class _HomePageState extends State<HomePage> {
  String tDate,sDay;
  DateTime today;
  void initState() {
    today = DateTime.now();
    tDate = DateFormat('dd-MM-yyyy').format(today);
    sDay = DateFormat('EEEE').format(today);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Widget drawerHeader = SizedBox(
      child: Column(
        children: [
          Column(
                  children: [
                    ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: FirebaseAuth.instance.currentUser.photoURL,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        fit: BoxFit.cover,
                        width: 120.w,
                        height: 120.h,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      FirebaseAuth.instance.currentUser.displayName,
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp),
                    ),
                  ],
                ),
          Padding(
            padding:  EdgeInsets.fromLTRB(0, 4.h, 0, 0),
            child: Text(FirebaseAuth.instance.currentUser.email,
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
              color: Theme.of(context).primaryColor,
              fontSize: 25.sp,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.segment,
              color: Theme.of(context).primaryColor,
          size: 35.r,),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
        elevation: 0,
        //toolbarHeight: 60,
        backgroundColor: Theme.of(context).accentColor,
      ),
      drawer: Drawer(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10.w, 30.h, 10.w, 15.h),
                child: drawerHeader,
              ),
              Divider(
                thickness: 1,
                color: Theme.of(context).accentColor,
                indent: 15.w,
                endIndent:30.w,
              ),
              InkWell(
                onTap: () {},
                child: ListTile(
                  title: Text('Home',
                      style: Theme.of(context).textTheme.bodyText1),
                  leading: Icon(Icons.home_rounded,
                  color: Theme.of(context).accentColor),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) => Enrollment()));
                },
                child: ListTile(
                  title: Text('Enrollments',
                      style: Theme.of(context).textTheme.bodyText1),
                  leading: Icon(Icons.person_pin_rounded,
                      color: Theme.of(context).accentColor),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) => ManageDatabase()));
                },
                child: ListTile(
                  title: Text('Manage Database',
                      style: Theme.of(context).textTheme.bodyText1),
                  leading: Icon(Icons.storage_rounded,
                      color: Theme.of(context).accentColor),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) => Attendance()));

                },
                child: ListTile(
                  title: Text('Attendence',
                      style: Theme.of(context).textTheme.bodyText1),
                  leading: Icon(Icons.date_range_rounded,
                      color: Theme.of(context).accentColor),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) => CoursePage()));

                },
                child: ListTile(
                  title: Text('Course Page',
                      style: Theme.of(context).textTheme.bodyText1),
                  leading: Icon(Icons.menu_book,
                      color: Theme.of(context).accentColor),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) => ClassMessage()));

                },
                child: ListTile(
                  title: Text('Class Message',
                      style: Theme.of(context).textTheme.bodyText1),
                  leading: Icon(Icons.message,
                      color: Theme.of(context).accentColor),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) => Grades()));

                },
                child: ListTile(
                  title: Text('Grades',
                      style: Theme.of(context).textTheme.bodyText1),
                  leading: Icon(Icons.score_rounded,
                      color: Theme.of(context).accentColor),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) => Transactions()));
                },
                child: ListTile(
                  title: Text('Transactions',
                      style: Theme.of(context).textTheme.bodyText1),
                  leading: Icon(Icons.monetization_on_rounded,
                      color: Theme.of(context).accentColor),
                ),
              ),
              Divider(
                thickness: 1,
                color: Theme.of(context).accentColor,
                indent: 15.w,
                endIndent: 30.w,
              ),
              InkWell(
                onTap: (){
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (BuildContext context) => Splash()));
                },
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
                    children: snapshot.data.docs.map((mdoc) {
                      if (mdoc['Schedule'][sDay] == true) {
                        return Stack(
                          children: [
                            Padding(padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
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
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                onPressed: () async {
                                  showDialog(context: context,
                                      builder: (BuildContext context){
                                        return BatchSetting(BatchID: mdoc.id,);
                                      }
                                  );
                                },
                                icon: Icon(Icons.edit,
                                  size: 25.r,
                                ),
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          ],
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
        ],
      ),
    );
  }
}
class BatchSetting extends StatefulWidget {
  final String BatchID;
  const BatchSetting({Key key, this.BatchID}) : super(key: key);

  @override
  _BatchSettingState createState() => _BatchSettingState();
}

class _BatchSettingState extends State<BatchSetting> {
  Map<String,dynamic> batchData = new Map();
  ProgressDialog pr;
  bool processed = false;

  @override
  void initState() {
    super.initState();
    getData();

  }
  void getData()async{
    DocumentSnapshot ds = await FirebaseFirestore.instance.collection('Batch').doc(widget.BatchID).get();
    if(ds.exists){
      batchData = ds.data();
    }
    setState(() {
      processed = true;
    });

  }

  Future uploadData(BuildContext context) async {
      await pr.show();
      if(batchData['Online'] == true){
        batchData['Location'] = 'Online';
      }
      else{
        batchData['ClassLink'] = null;
      }
      await FirebaseFirestore.instance.collection('Batch').doc(widget.BatchID).update(batchData);
      Fluttertoast.showToast(
          msg: "Class Created Successfully...",
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
        message: 'Uploading...',
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
      child: contentBox(context),
    );
  }
  contentBox(context) {
    return Container(
        height: 420.h,
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
                'Edit Batch',
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if(processed == true)
          Column(
            children: [
              Padding(
                padding:  EdgeInsets.symmetric(vertical: 5.h,horizontal: 15.w),
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('Staff').where('Subjects',arrayContains: batchData['Subject']).snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.docs.isNotEmpty) {
                          return DropdownButtonFormField(
                            hint: Text(
                              'Choose Staff',
                              style: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor),
                            ),
                            style: TextStyle(color: Colors.white),
                            value: batchData['Faculty'],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(30.0),
                                ),
                              ),
                            ),
                            onChanged: (newValue) {
                              setState(() {
                                batchData['Faculty'] = newValue;
                              });
                            },
                            items: snapshot.data.docs.map((document) {
                              return DropdownMenuItem(
                                child: new Text(
                                  document['Name'],
                                  style: TextStyle(
                                      color: Theme.of(context).secondaryHeaderColor),
                                ),
                                value: document.id,
                              );
                            }).toList(),
                          );
                        } else {
                          return Text(
                            'Faculty not found...',
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
                                  'Getting Faculties...',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        'Start At',
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(
                        width: 100.w,
                        child: TextFormField(
                          controller: TextEditingController(text: batchData['StartAt']),
                          keyboardType: TextInputType.name,
                          decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(15),
                                ),
                              ),
                              filled: true,
                              hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                              hintText: "HH:MM",
                              fillColor: Theme.of(context).cardColor),
                          onChanged: (value) {
                            batchData['StartAt'] = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Ends At',
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(
                        width: 100.w,
                        child: TextFormField(
                          controller: TextEditingController(text: batchData['EndAt']),
                          keyboardType: TextInputType.name,
                          decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(15),
                                ),
                              ),
                              filled: true,

                              hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                              hintText: "HH:MM",
                              fillColor: Theme.of(context).cardColor),
                          onChanged: (value) {
                            batchData['EndAt'] = value;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Radio(value: true, groupValue: batchData['Online'], onChanged:(e){
                            setState(() {
                              batchData['Online'] = e;
                            });
                          }),
                          Text('Online',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                        ],
                      ),
                      if(batchData['Online'] == true)
                        SizedBox(
                          width: 300.w,
                          child: TextFormField(
                            controller: TextEditingController(text: batchData['ClassLink']),
                            keyboardType: TextInputType.name,
                            decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(15),
                                  ),
                                ),
                                filled: true,
                                hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                                hintText: "Link",
                                fillColor: Theme.of(context).cardColor),
                            onChanged: (value) {
                              batchData['ClassLink'] = value;
                            },
                          ),
                        ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Radio(value: false, groupValue: batchData['Online'], onChanged:(e){
                            setState(() {
                              batchData['Online'] = e;
                            });
                          }),
                          Text('Offline',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                        ],
                      ),
                      if(batchData['Online'] == false)
                        SizedBox(
                          width: 300.w,
                          child: TextFormField(
                            controller: TextEditingController(text: batchData['Location']),
                            keyboardType: TextInputType.name,
                            decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(15),
                                  ),
                                ),
                                filled: true,
                                hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                                hintText: "Link",
                                fillColor: Theme.of(context).cardColor),
                            onChanged: (value) {
                              batchData['Location'] = value;
                            },
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding:  EdgeInsets.fromLTRB(50.w, 10.h, 50.w, 10.h),
            child: SizedBox(
              height: 60.h,
              child: FlatButton(
                onPressed:(){
                  uploadData(context);
                },
                child: Center(
                  child: Text("Submit",style: TextStyle(color: Colors.black,fontSize: 18.sp,fontWeight: FontWeight.w800 ),),
                ),
                color: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              ),
            ),
          ),

        ]));
  }
}

