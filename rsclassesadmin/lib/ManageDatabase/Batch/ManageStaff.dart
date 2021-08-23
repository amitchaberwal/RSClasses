import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:path/path.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
class ManageStaff extends StatefulWidget {
  @override
  _ManageStaffState createState() => _ManageStaffState();
}

class _ManageStaffState extends State<ManageStaff> {
  ProgressDialog pr;
  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
        message: 'Deleting...',
        borderRadius: 10.0,
        backgroundColor: Theme.of(context).primaryColor,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13..sp, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
            fontSize: 19.sp,
            fontWeight: FontWeight.w600));
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          'Manage Staff',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 25.sp,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        //toolbarHeight: 60,
        backgroundColor: Theme.of(context).accentColor,
        actions: <Widget>[
          new IconButton(
              icon: Icon(
                Icons.add_box_rounded,
                color: Theme.of(context).primaryColor,
                size: 35.r,
              ),
              onPressed: () {
                showDialog(context: context,
                    builder: (BuildContext context){
                      return AddStaff();
                    }
                );
              }),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Container(
              width: double.infinity,
              height: 720.h,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('Staff').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: snapshot.data.docs.map((document) => Padding(
                          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 10.h),
                          child: new Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top:10.h),
                                      child: Text(document.id,
                                        style: TextStyle(
                                            color: Theme.of(context).accentColor,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      EdgeInsets.only(top:5.h),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('Name: ',
                                            style: TextStyle(
                                                color: Theme.of(context).secondaryHeaderColor,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w300),
                                          ),
                                          Container(
                                              width: 150.w,
                                              child: Text(document['Name'],overflow: TextOverflow.ellipsis,
                                                style: TextStyle(color: Theme.of(context).secondaryHeaderColor,
                                                    fontSize: 18.sp,fontWeight: FontWeight.w300),
                                              )),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10.h),
                                  child: Text('Subjects',
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Padding(
                                  padding:  EdgeInsets.only(left: 10.w,right: 20.w),
                                  child: Column(
                                    children: document['Subjects'].map<Widget>((doc) => Padding(
                                      padding: EdgeInsets.only(top:10.h),
                                      child: FutureBuilder(
                                          future: FirebaseFirestore.instance.collection('Subjects').doc(doc).get(),
                                          builder: (context, AsyncSnapshot<DocumentSnapshot>mdata) {
                                            if (mdata.hasData) {
                                              return Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(mdata.data['Name'],
                                                    style: TextStyle(
                                                        color: Theme.of(context).secondaryHeaderColor,
                                                        fontSize: 16.sp,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                  Text(mdata.data['Class'],
                                                    style: TextStyle(
                                                        color: Theme.of(context).secondaryHeaderColor,
                                                        fontSize: 16.sp,
                                                        fontWeight: FontWeight.w400),
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return CircularProgressIndicator();
                                            }
                                          }),
                                    )).toList(),
                                  ),
                                ),

                                SizedBox(height: 20.h,),

                              ],
                            ),
                          ),
                        )).toList(),
                      );
                    } else {
                      return Container(
                        height: 50.h,
                        width: 50.w,
                      );
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
class AddStaff extends StatefulWidget {
  @override
  _AddStaffState createState() => _AddStaffState();
}

class _AddStaffState extends State<AddStaff> {
  String sPhone,sName,sDesc;
  List<String> ASubjects = new List();
  final picker = ImagePicker();
  ProgressDialog pr;



  Future uploadData(BuildContext context) async {

    if(sPhone == null|| sName == null||sDesc == null){
      Fluttertoast.showToast(
          msg: "Please fill all details..",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).cardColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          fontSize: 16.0
      );
    }
    else{
      await pr.show();
      FirebaseFirestore.instance.collection('Staff').doc(sPhone).set({
        'Name': sName,
        'Description': sDesc,
        'Subjects': ASubjects
      });
      Fluttertoast.showToast(
          msg: "Category Created Successfully...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).cardColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          fontSize: 16.0
      );
      await pr.hide();
      Navigator.pop(context);
    }
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
        height: 500.h,
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
                'Staff',
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding:  EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(30),
                    ),
                  ),
                  filled: true,
                  prefixIcon: Icon(
                    Icons.category_rounded,
                    color: Theme.of(context).accentColor,
                  ),
                  hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                  hintText: "Phone Number",
                  fillColor: Theme.of(context).cardColor),
              onChanged: (value) {
                sPhone = value;
              },
            ),
          ),
          Padding(
            padding:  EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
            child: TextField(
              keyboardType: TextInputType.name,
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(30),
                    ),
                  ),
                  filled: true,
                  prefixIcon: Icon(
                    Icons.category_rounded,
                    color: Theme.of(context).accentColor,
                  ),
                  hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                  hintText: "Name",
                  fillColor: Theme.of(context).cardColor),
              onChanged: (value) {
                sName = value;
              },
            ),
          ),
          Padding(
            padding:  EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 2,
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(30),
                    ),
                  ),
                  filled: true,
                  prefixIcon: Icon(
                    Icons.category_rounded,
                    color: Theme.of(context).accentColor,
                  ),
                  hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                  hintText: "Description",
                  fillColor: Theme.of(context).cardColor),
              onChanged: (value) {
                sDesc = value;
              },
            ),
          ),
          Padding(
            padding:  EdgeInsets.fromLTRB(50.w, 10.h, 50.w, 10.h),
            child: SizedBox(
              height: 60.h,
              child: FlatButton(
                onPressed:() async {
                  var Subjectdata = await showDialog(context: context,
                      builder: (BuildContext context) {
                        return AllotSubjects();
                      });
                  setState(() {
                    ASubjects = Subjectdata;
                  });
                },
                child: Center(
                  child: Text("Allot Subjects",style: TextStyle(color: Colors.black,fontSize: 18.sp,fontWeight: FontWeight.w600 ),),
                ),
                color: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
              ),
            ),
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
class AllotSubjects extends StatefulWidget {
  @override
  _AllotSubjectsState createState() => _AllotSubjectsState();
}
class _AllotSubjectsState extends State<AllotSubjects> {
  List<String> subs = new List();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
          height: 450.h,
          margin: EdgeInsets.only(top: 1),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.design_services,
                      color: Theme.of(context).accentColor,
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                    Text(
                      "Subjects",
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 15.w),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('Subjects').orderBy('Class',descending: true).snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> mdata) {
                    if (mdata.hasData) {
                      return Column(
                        children: [
                          Container(
                            height: 365.h,
                            width: 250.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: SingleChildScrollView(
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                direction: Axis.horizontal,
                                children: mdata.data.docs.map((document) => Padding(
                                      padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 80.h,
                                            width: 100.w,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: InkWell(
                                              onTap: () async{
                                                setState(() {
                                                  if(subs.contains(document.id)){
                                                    subs.remove(document.id);
                                                  }
                                                  else{
                                                    subs.add(document.id);
                                                  }
                                                });
                                              },
                                              child: Stack(
                                                  children:[
                                                    Center(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                              document['Name'],
                                                              style: TextStyle(
                                                                  color: Theme.of(context).secondaryHeaderColor,
                                                                  fontSize: 14.sp,
                                                                  fontWeight: FontWeight.w600)
                                                          ),
                                                          Text(
                                                              document['Class'],
                                                              style: TextStyle(
                                                                  color: Theme.of(context).secondaryHeaderColor,
                                                                  fontSize: 14.sp,
                                                                  fontWeight: FontWeight.w300)
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    if (subs.contains(document.id))
                                                      Container(
                                                        width: 100.w,
                                                        height: 150.h,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(15.0),
                                                            color: Theme.of(context).accentColor.withOpacity(0.7)),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Icon(
                                                              Icons.done,
                                                              color: Colors.black,
                                                              size: 40.r,
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                  ]),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),).toList()
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              FlatButton(
                                child: Text('Cancel',
                                    style: TextStyle(
                                        color: Theme.of(context).secondaryHeaderColor)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text(
                                  'Submit',
                                  style: TextStyle(color: Theme.of(context).accentColor),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop(subs);
                                },)
                            ],
                          ),
                        ],
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            ),

          ])),
    );
  }
}


