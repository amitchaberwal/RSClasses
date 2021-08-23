import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rsclassesadmin/HomePage/HomePage.dart';
class ManageBatch extends StatefulWidget {
  @override
  _ManageBatchState createState() => _ManageBatchState();
}

class _ManageBatchState extends State<ManageBatch> {
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
          'Manage Batch',
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
                    return CreateBatch();
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
                  stream: FirebaseFirestore.instance.collection('Batch').orderBy('Class',descending: true).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if(snapshot.hasData){
                      return Wrap(
                        children: snapshot.data.docs.map((document) => Padding(
                          padding:  EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
                          child: new
                          Container(
                            width: 400.w,
                            height: 220.h,
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
                                      Padding(
                                        padding:  EdgeInsets.only(top:10.h),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text('Class: ' + document['Class'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                            Text('Subject: ' + document['Subject'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:  EdgeInsets.only(top:10.h),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text('Timing: ' + document['StartAt'] + ' - ' + document['EndAt'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                            Text('Location: ' + document['Location'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                          ],
                                        ),
                                      ),
                                      Center(
                                        child: Padding(
                                          padding:  EdgeInsets.only(top: 10.h),
                                          child: Text('Faculty: ' + document['Faculty'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 16.sp,fontWeight: FontWeight.w400),),
                                        ),
                                      ),
                                      StreamBuilder(
                                          stream: FirebaseFirestore.instance.collection('Batch').doc(document.id).collection('Enrollments').snapshots(),
                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot) {
                                            if (snapshot.hasData) {
                                              return Padding(
                                                  padding:  EdgeInsets.fromLTRB(0, 10.h, 0, 0),
                                                  child:Center(
                                                    child: Text('Enrolled: ' + snapshot.data.docs.length.toString(),style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 16.sp,fontWeight: FontWeight.w400),),
                                                  ),
                                                );
                                            } else {
                                              return CircularProgressIndicator();
                                            }
                                          }),
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
                                            if(document['Schedule']['Sunday'] == true)
                                              Text('Sun',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                            if(document['Schedule']['Monday'] == true)
                                              Text('Mon',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                            if(document['Schedule']['Tuesday'] == true)
                                              Text('Tue',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                            if(document['Schedule']['Wednesday'] == true)
                                              Text('Wed',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                            if(document['Schedule']['Thursday'] == true)
                                              Text('Thu',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                            if(document['Schedule']['Friday'] == true)
                                              Text('Fri',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                            if(document['Schedule']['Saturday'] == true)
                                              Text('Sat',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                          ]

                                        ),
                                      )
                                    ],
                                  ),
                                  Align(
                                    alignment:Alignment.topRight,
                                    child: IconButton(
                                      onPressed:() async{
                                        await pr.show();
                                        await FirebaseFirestore.instance.collection('Batches').doc(document.id).delete();
                                        await pr.hide();
                                      },
                                      icon: Icon(Icons.delete_outline_rounded,size: 25.r,),
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                  Align(
                                    alignment:Alignment.topLeft,
                                    child: IconButton(
                                      onPressed:() async{
                                        showDialog(context: context,
                                            builder: (BuildContext context){
                                              return BatchSetting(BatchID: document.id,);
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
class CreateBatch extends StatefulWidget {
  @override
  _CreateBatchState createState() => _CreateBatchState();
}

class _CreateBatchState extends State<CreateBatch> {
  String uclass,usub,ustaff,nbatch,stime,etime,blocation;
  List<bool> isSelected = [false, false, false,false,false,false,false];
  ProgressDialog pr;
  Future uploadData(BuildContext context) async {
    if(uclass == null || usub == null || ustaff == null|| nbatch == null|| stime == null|| etime == null || blocation == null){
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
      Map<String,dynamic> sch = {'Sunday':false,'Monday':false,'Tuesday':false,'Wednesday':false,'Thursday':false,'Friday':false,'Saturday':false,};
      if(isSelected[0] == true)
        sch['Sunday'] = true;
      if(isSelected[1] == true)
        sch['Monday'] = true;
      if(isSelected[2] == true)
        sch['Tuesday'] = true;
      if(isSelected[3] == true)
        sch['Wednesday'] = true;
      if(isSelected[4] == true)
        sch['Thursday'] = true;
      if(isSelected[5] == true)
        sch['Friday'] = true;
      if(isSelected[6] == true)
        sch['Saturday'] = true;

      await FirebaseFirestore.instance.collection('Batch').doc(nbatch.toUpperCase()).set({
        'Name': nbatch.toUpperCase(),
        'Class' : uclass,
        'Subject' : usub,
        'Faculty' : ustaff,
        'StartAt' : stime,
        'EndAt' : etime,
        'Location' : blocation,
        'Schedule' : sch,
      });
      Fluttertoast.showToast(
          msg: "Batch Created Successfully...",
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
        height: 650.h,
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
                'Create Batch',
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding:  EdgeInsets.symmetric(vertical: 5.h,horizontal: 15.w),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Classes').snapshots(),
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
          Padding(
            padding:  EdgeInsets.symmetric(vertical: 5.h,horizontal: 15.w),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Subjects').where('Class',isEqualTo: uclass).snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.docs.isNotEmpty) {
                      return DropdownButtonFormField(
                        hint: Text(
                          'Choose Subject',
                          style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor),
                        ),
                        style: TextStyle(color: Colors.white),
                        value: usub,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(30.0),
                            ),
                          ),
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            usub = newValue;
                          });
                        },
                        items: snapshot.data.docs.map((document) {
                          return DropdownMenuItem(
                            child: new Text(
                              document['Name'],
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
                        'Subjects not found...',
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
                              'Getting Subjects...',
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
            padding:  EdgeInsets.symmetric(vertical: 5.h,horizontal: 15.w),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Staff').where('Subjects',arrayContains: usub).snapshots(),
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
                        value: ustaff,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(30.0),
                            ),
                          ),
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            ustaff = newValue;
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
          Padding(
            padding:  EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
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
                  hintText: "Batch Name",
                  fillColor: Theme.of(context).cardColor),
              onChanged: (value) {
                nbatch = value;
              },
            ),
          ),
          Padding(
            padding:  EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 10.h),
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
                    Icons.location_on,
                    color: Theme.of(context).accentColor,
                  ),
                  hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                  hintText: "Location",
                  fillColor: Theme.of(context).cardColor),
              onChanged: (value) {
                blocation = value;
              },
            ),
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
                    child: TextField(
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
                        stime = value;
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
                    child: TextField(
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
                        etime = value;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
            child: SizedBox(
              height: 55.h,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ToggleButtons(
                  children: <Widget>[
                    Text(
                      'Sun',
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w300),
                    ),
                    Text(
                      'Mon',
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w300),
                    ),
                    Text(
                      'Tue',
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w300),
                    ),
                    Text(
                      'Wed',
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w300),
                    ),
                    Text(
                      'Thu',
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w300),
                    ),
                    Text(
                      'Fri',
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w300),
                    ),
                    Text(
                      'Sat',
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                  fillColor: Theme.of(context).accentColor,
                  isSelected: isSelected,
                  borderRadius: BorderRadius.circular(10),
                  onPressed: (int index) {
                    setState(() {
                      isSelected[index] = !isSelected[index];
                    });
                  },
                ),
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

