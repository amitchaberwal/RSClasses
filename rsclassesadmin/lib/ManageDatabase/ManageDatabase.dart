import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rsclassesadmin/ManageDatabase/Batch/ManageBatch.dart';
import 'package:rsclassesadmin/ManageDatabase/Batch/ManageStaff.dart';
import 'package:rsclassesadmin/ManageDatabase/Classes/ManageClasses.dart';
import 'package:rsclassesadmin/ManageDatabase/Classes/ManageSubjects.dart';

class ManageDatabase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          'Manage Database',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 25.sp,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
                child: new
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10.h,),
                      Text(
                        'Classes',
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top:10.h),
                        child: SizedBox(
                          height: 60.h,
                          width: 250.w,
                          child: FlatButton(
                            onPressed:(){
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (BuildContext context) => ManageClasses()));
                              },
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.category_rounded),
                                  SizedBox(width: 15.w,),
                                  Text("Manage Class",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 18.sp,fontWeight: FontWeight.w800 ),),
                                ],
                              ),
                            ),
                            color: Theme.of(context).accentColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top:10.h,bottom: 20.h),
                        child: SizedBox(
                          height: 60.h,
                          width: 250.w,
                          child: FlatButton(
                            onPressed:(){
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (BuildContext context) => ManageSubjects()));
                            },
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.category_rounded),
                                  SizedBox(width: 15.w,),
                                  Text("Manage Subjects",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 18.sp,fontWeight: FontWeight.w800 ),),
                                ],
                              ),
                            ),
                            color: Theme.of(context).accentColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ),

                    ],
                  ),
                )),
            Padding(
                padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
                child: new
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10.h,),
                      Text(
                        'Batch',
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10.h, 0, 0.h),
                        child: SizedBox(
                          height:60.h,
                          width: 280.w,
                          child: FlatButton(
                            onPressed:(){
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (BuildContext context) => ManageStaff()));

                            },
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.category_rounded),
                                  SizedBox(width: 15.w,),
                                  Text("Manage Staff",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 18.sp,fontWeight: FontWeight.w800 ),),
                                ],
                              ),
                            ),
                            color: Theme.of(context).accentColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10.h, 0, 20.h),
                        child: SizedBox(
                          height:60.h,
                          width: 280.w,
                          child: FlatButton(
                            onPressed:(){
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (BuildContext context) => ManageBatch()));
                            },
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.category_rounded),
                                  SizedBox(width: 15.w,),
                                  Text("Manage Batch",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 18.sp,fontWeight: FontWeight.w800 ),),
                                ],
                              ),
                            ),
                            color: Theme.of(context).accentColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ),

                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
