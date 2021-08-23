import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
class Grades extends StatefulWidget {
  const Grades({Key key}) : super(key: key);

  @override
  _GradesState createState() => _GradesState();
}

class _GradesState extends State<Grades> {
  String uclass;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          'Grades',
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
          if(uclass!=null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('Batch').where('Class',isEqualTo: uclass).snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot>snapshot) {
                    if (snapshot.hasData) {
                      if(snapshot.data.docs.isNotEmpty){
                        return Column(
                          children: [
                            Column(
                              children: snapshot.data.docs.map((mdocc) => Padding(
                                padding:  EdgeInsets.only(top:10.h,bottom: 10.h),
                                child: InkWell(
                                  onTap: (){
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (BuildContext context) => getGrades(batchID: mdocc.id,)));
                                  },
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
                                                child: Text(mdocc.id,style: TextStyle(color: Theme.of(context).accentColor,fontSize: 18.sp,fontWeight: FontWeight.w600),),
                                              ),
                                            ),
                                            Padding(
                                              padding:  EdgeInsets.only(top:10.h),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Text('Class: ' + mdocc['Class'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                                  Text('Subject: ' + mdocc['Subject'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:  EdgeInsets.only(top:10.h),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Text('Timing: ' + mdocc['StartAt'] + ' - ' + mdocc['EndAt'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                                  Text('Location: ' + mdocc['Location'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:  EdgeInsets.only(top: 10.h,),
                                              child: FutureBuilder(
                                                  future: FirebaseFirestore.instance.collection('Staff').doc(mdocc['Faculty']).get(),
                                                  builder: (context, AsyncSnapshot<DocumentSnapshot>mdataa) {
                                                    if (mdataa.hasData) {
                                                      return Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text('Faculty: ' + mdataa.data['Name'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 14.sp, fontWeight: FontWeight.w300)),
                                                        ],
                                                      );
                                                    } else {
                                                      return CircularProgressIndicator();
                                                    }
                                                  }),
                                            ),
                                            SizedBox(height: 20.h,)
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              ).toList(),
                            ),
                          ],
                        );
                      }
                      else{
                        return Padding(
                          padding:  EdgeInsets.symmetric(vertical: 20.h),
                          child: Text(
                            'Classes not found...',
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).secondaryHeaderColor),
                          ),
                        );
                      }

                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            ),
        ],
      ),
    );
  }
}
class getGrades extends StatefulWidget {
  final String batchID;
  const getGrades({Key key, this.batchID}) : super(key: key);

  @override
  _getGradesState createState() => _getGradesState();
}

class _getGradesState extends State<getGrades> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          widget.batchID,
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
                    return CreateExam(batchId: widget.batchID,);
                  }
              );

            },
          )
        ],
      ),
      body: ListView(
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance.collection('Batch').doc(widget.batchID).collection('Grades').orderBy('PostDate', descending: true).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot>snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.docs.map((mdoc) => Padding(
                      padding:  EdgeInsets.fromLTRB(10.w, 10.h, 10.w,0),
                      child:Container(
                        width: 400.w,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding:  EdgeInsets.only(top:10.h),
                                    child: Container(width:380.w,child: Center(child: Text(mdoc['Title'],style: TextStyle(color: Theme.of(context).accentColor,fontSize: 16.sp,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,))),
                                  ),
                                  Padding(
                                    padding:  EdgeInsets.only(top:10.h),
                                    child: Container(width:380.w,child: Center(child: Text('Total Marks: '+mdoc['TotalMarks'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w400),overflow: TextOverflow.ellipsis,))),
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
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance.collection('Batch').doc(widget.batchID).collection('Grades').doc(mdoc.id).delete();
                                  },
                                  icon: Icon(Icons.delete_outline_rounded,
                                    size: 25.r,
                                  ),
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                  onPressed: () async {
                                    showDialog(context: context,
                                        builder: (BuildContext context){
                                          return CreateExam(batchId: widget.batchID,testID: mdoc.id,);
                                        }
                                    );
                                  },
                                  icon: Icon(Icons.edit,
                                    size: 25.r,
                                  ),
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            ]
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
class CreateExam extends StatefulWidget {
  final String batchId,testID;
  const CreateExam({Key key, this.batchId, this.testID}) : super(key: key);

  @override
  _CreateExamState createState() => _CreateExamState();
}

class _CreateExamState extends State<CreateExam> {
  Map<String,dynamic> Grades = new Map();
  bool processed = false;
  ProgressDialog pr;
  String mtitle,tmarks,pdate;
  DateTime aDate,sDate;

  @override
  void initState() {
    aDate = DateTime.now();
    pdate = new DateFormat("dd-MM-yyyy").format(aDate);
    super.initState();
    getGrades();
  }
  void getGrades()async{
    if(widget.testID == null){
      setState(() {
        processed = true;
      });
    }
    else{
      DocumentSnapshot ds = await FirebaseFirestore.instance.collection('Batch').doc(widget.batchId).collection('Grades').doc(widget.testID).get();
      if(ds.exists){
        Grades = ds.data();
      }
      setState(() {
        processed = true;
      });
    }

  }

  Future uploadData(BuildContext context) async {
    if(widget.testID == null){
      if(mtitle == null || tmarks == null){
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
        Grades['Title'] = mtitle;
        Grades['PostDate'] = pdate;
        Grades['TotalMarks'] = tmarks;
        await FirebaseFirestore.instance.collection('Batch').doc(widget.batchId).collection('Grades').doc().set(Grades);
        Fluttertoast.showToast(
            msg: "Grades Posted Successfully...",
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
    else{
      await pr.show();
      await FirebaseFirestore.instance.collection('Batch').doc(widget.batchId).collection('Grades').doc(widget.testID).update(Grades);
      Fluttertoast.showToast(
          msg: "Grades Posted Successfully...",
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
      child: Container(
          height: 700.h,
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
                  'New Test',
                  style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

            (processed == true)?
            Column(
              children: [
                Padding(
                  padding:  EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
                  child: TextFormField(
                    controller: TextEditingController(text: (Grades['Title'] != null)?Grades['Title']:null ),
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
                        hintText: "Title",
                        fillColor: Theme.of(context).cardColor),
                    onChanged: (value) {
                      mtitle = value;
                    },
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.fromLTRB(40.w, 10.h, 40.w, 0),
                  child: SizedBox(
                    width: 120.w,
                    child: TextFormField(
                      controller: TextEditingController(text: (Grades['TotalMarks'] != null)?Grades['TotalMarks']:null ),
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
                          hintText: "Total Marks",
                          fillColor: Theme.of(context).cardColor),
                      onChanged: (value) {
                        tmarks = value;
                      },
                    ),
                  ),
                ),
                Container(
                  height: 440.h,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('Batch').doc(widget.batchId).collection('Enrollments').snapshots(),
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
                                      SizedBox(
                                        width: 80,
                                        child: TextFormField(
                                          controller: TextEditingController(text: (Grades[mdoc.id] != null)?Grades[mdoc.id]:null ),
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
                                              hintText: "Grade",
                                              fillColor: Theme.of(context).cardColor),
                                          onChanged: (value) {
                                            Grades[mdoc.id] = value;
                                          },
                                        ),
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
                ),
              ],
            ):
            Container(height: 520.h,
              child: Center(
                child: Container(
                  height: 50.h,
                  width: 50.w,
                  child: CircularProgressIndicator(),
                ),
              ),),
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

          ])),
    );
  }
}


