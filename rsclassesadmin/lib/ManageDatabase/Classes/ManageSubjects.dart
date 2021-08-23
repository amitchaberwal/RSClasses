import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
class ManageSubjects extends StatefulWidget {
  @override
  _ManageSubjectsState createState() => _ManageSubjectsState();
}

class _ManageSubjectsState extends State<ManageSubjects> {
  ProgressDialog pr;
  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
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
            color: Colors.black, fontSize: 13.sp, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Theme.of(context).secondaryHeaderColor, fontSize: 19.sp, fontWeight: FontWeight.w600)
    );
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          'Manage Subjects',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 25.sp,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).accentColor,
        actions: <Widget>[
          new IconButton(
            icon: Icon(
              Icons.add_box_rounded,
              color: Theme.of(context).primaryColor,
              size: 35.r,
            ),
            onPressed: (){
              showDialog(context: context,
                  builder: (BuildContext context){
                    return CreateSubject();
                  }
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 710.h,
            child: SingleChildScrollView(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('Subjects').orderBy('Class',descending: true).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if(snapshot.hasData){
                      return Wrap(
                        children: snapshot.data.docs.map((document) => Padding(
                          padding:  EdgeInsets.fromLTRB(10.w, 10.h, 0, 10.h),
                          child: new
                          Container(
                            width: 180.w,
                            height: 150.h,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Center(
                                        child: Padding(
                                          padding:  EdgeInsets.only(top: 20.h),
                                          child: Text(document.id,style: TextStyle(color: Theme.of(context).accentColor,fontSize: 18.sp,fontWeight: FontWeight.w600),),
                                        ),
                                      ),
                                      Center(
                                        child: Padding(
                                          padding:  EdgeInsets.only(top: 10.h),
                                          child: Text(document['Name'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 18.sp,fontWeight: FontWeight.w600),),
                                        ),
                                      ),

                                      Center(
                                        child: Padding(
                                          padding:  EdgeInsets.only(top: 10.h),
                                          child: Text('Class: ' + document['Class'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                        ),
                                      ),
                                      Center(
                                        child: Padding(
                                          padding:  EdgeInsets.only(top: 10.h),
                                          child: Text('Fee: ₹' + document['Fee'].toString(),style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 16.sp,fontWeight: FontWeight.w600),),
                                        ),
                                      ),

                                    ],
                                  ),
                                  Align(
                                    alignment:Alignment.topRight,
                                    child: IconButton(
                                      onPressed:() async{
                                        showDialog(context: context,
                                            builder: (BuildContext context){
                                              return EditSubject(subID: document.id,);
                                            }
                                        );
                                         },
                                      icon: Icon(Icons.edit,size: 20.r,),
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                ]),
                          ),
                        )
                        ).toList(),
                      );
                    }
                    else{
                      return Container(height: 50.h,width: 50.w,);
                    }
                  }
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class CreateSubject extends StatefulWidget {
  @override
  _CreateSubjectState createState() => _CreateSubjectState();
}

class _CreateSubjectState extends State<CreateSubject> {
  String uclass,subname,mfee,scode;
  ProgressDialog pr;
  Future uploadData(BuildContext context) async {
    if(subname == null || uclass == null || mfee == null || scode == null){
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
      await FirebaseFirestore.instance.collection('Subjects').doc(scode.toUpperCase()).set({
        'Name': subname,
        'Class' : uclass,
        'Fee': int.parse(mfee)
      });
      Fluttertoast.showToast(
          msg: "Subject Created Successfully...",
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
                'Create Subject',
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding:  EdgeInsets.symmetric(vertical: 15.h,horizontal: 15.w),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Classes').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.docs.isNotEmpty) {
                      return DropdownButtonFormField(
                        hint: Text(
                          'Choose Class',
                          style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor),
                        ),
                        style: TextStyle(color: Colors.white),
                        value: uclass,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(30.0),
                            ),
                          ),
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            uclass = newValue;
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
                        'Categories not found...',
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
                              'Getting Categories...',
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
                    Icons.code,
                    color: Theme.of(context).accentColor,
                  ),
                  hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                  hintText: "Subject Code",
                  fillColor: Theme.of(context).cardColor),
              onChanged: (value) {
                scode = value;
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
                  hintText: "Subject Name",
                  fillColor: Theme.of(context).cardColor),
              onChanged: (value) {
                subname = value;
              },
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
                    Icons.monetization_on_rounded,
                    color: Theme.of(context).accentColor,
                  ),
                  hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                  hintText: "Monthly fee",
                  fillColor: Theme.of(context).cardColor),
              onChanged: (value) {
                mfee = value;
              },
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
class EditSubject extends StatefulWidget {
  final String subID;

  const EditSubject({Key key, this.subID}) : super(key: key);
  @override
  _EditSubjectState createState() => _EditSubjectState();
}

class _EditSubjectState extends State<EditSubject> {
  String subname,mfee;
  ProgressDialog pr;
  Future uploadData(BuildContext context) async {
    if(mfee == null || mfee == ""){
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
      await FirebaseFirestore.instance.collection('Subjects').doc(widget.subID).update({
        'Fee': int.parse(mfee)
      });
      Fluttertoast.showToast(
          msg: "Subject Updated Successfully...",
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
        height: 250.h,
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
                'Edit Subject',
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          FutureBuilder(
              future: FirebaseFirestore.instance.collection('Subjects').doc(widget.subID).get(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> mdata) {
                if (mdata.hasData) {
                  return Column(
                    children: [
                      Padding(
                        padding:  EdgeInsets.only(top: 10.h),
                        child: Center(
                          child: Text(
                            mdata.data['Name'],
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      Padding(
                        padding:  EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
                        child: TextFormField(
                          controller: TextEditingController(text: mdata.data['Fee'].toString()),
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
                                Icons.monetization_on_rounded,
                                color: Theme.of(context).accentColor,
                              ),
                              hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                              hintText: "Monthly fee",
                              fillColor: Theme.of(context).cardColor),
                          onChanged: (value) {
                            mfee = value;
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
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


