import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
class CoursePage extends StatefulWidget {
  const CoursePage({Key key}) : super(key: key);

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  String uclass;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          'Course Page',
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
                                  onTap: (){Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (BuildContext context) => GetCoursePage(batchID: mdocc.id,)));},
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
class GetCoursePage extends StatefulWidget {
  final String batchID;
  const GetCoursePage({Key key, this.batchID}) : super(key: key);

  @override
  _GetCoursePageState createState() => _GetCoursePageState();
}

class _GetCoursePageState extends State<GetCoursePage> {
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
                    return CreateMaterial(batchId: widget.batchID,);
                  }
              );
            },
          )
        ],
      ),
      body: ListView(
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance.collection('Batch').doc(widget.batchID).collection('CourseMaterial').orderBy('PostDate',descending: true).snapshots(),
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
                                child: Container(width:380.w,child: Center(child: Text(mdoc['Description'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 12.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.ellipsis,))),
                              ),
                              Padding(
                                padding:  EdgeInsets.only(top:10.h),
                                child: Container(width:380.w,child: Center(child: Text(mdoc['Link'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,))),
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
                                 await FirebaseFirestore.instance.collection('Batch').doc(widget.batchID).collection('CourseMaterial').doc(mdoc.id).delete();
                                },
                                icon: Icon(Icons.delete_outline_rounded,
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
class CreateMaterial extends StatefulWidget {
  final String batchId;
  const CreateMaterial({Key key, this.batchId}) : super(key: key);

  @override
  _CreateMaterialState createState() => _CreateMaterialState();
}

class _CreateMaterialState extends State<CreateMaterial> {
  ProgressDialog pr;
  String mtitle,mdesc,mlink;
  Future uploadData(BuildContext context) async {
    DateTime mdate = DateTime.now();
    String sdate = DateFormat('dd-MM-yyyy').format(mdate);
    if(mtitle == null || mdesc == null||mlink == null){
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
      await FirebaseFirestore.instance.collection('Batch').doc(widget.batchId).collection('CourseMaterial').doc().set({
        'Title': mtitle,
        'Description': mdesc,
        'Link': mlink,
        'PostDate':sdate
      });
      Fluttertoast.showToast(
          msg: "Material Created Successfully...",
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
          height: 400.h,
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
                  'New Course Material',
                  style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
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
                    hintText: "Title",
                    fillColor: Theme.of(context).cardColor),
                onChanged: (value) {
                  mtitle = value;
                },
              ),
            ),
            Padding(
              padding:  EdgeInsets.fromLTRB(20.w, 20.h, 20.w,0),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 2,
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20),
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
                  mdesc = value;
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
                    hintText: "link",
                    fillColor: Theme.of(context).cardColor),
                onChanged: (value) {
                  mlink = value;
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

          ])),
    );
  }
}


