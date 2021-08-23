import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class Transactions extends StatefulWidget {
  const Transactions({Key key}) : super(key: key);

  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          'Transactions',
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
          StreamBuilder(
              stream: FirebaseFirestore.instance.collection('Transactions').orderBy('Date', descending: true).snapshots(),
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
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ExpansionTile(
                          title: Padding(
                            padding:  EdgeInsets.only(top:0.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(mdoc['Phone'],style: TextStyle(color: Theme.of(context).accentColor,fontSize: 16.sp,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,),
                                Text(mdoc['Date'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.ellipsis,),

                              ],
                            ),
                          ),
                          children: [
                            Padding(
                              padding:  EdgeInsets.only(top:0),
                              child: Container(width:380.w,child: Center(child: Text(mdoc['Name'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 12.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.ellipsis,))),
                            ),
                            Padding(
                              padding:  EdgeInsets.only(top:10.h),
                              child: Container(width:380.w,child: Center(child: Text(mdoc['Email'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.ellipsis,))),
                            ),
                            Padding(
                              padding:  EdgeInsets.only(top:10.h),
                              child: Container(width:380.w,child: Center(child: Text('Amount: '+mdoc['Amount'].toString(),style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.ellipsis,))),
                            ),
                            Padding(
                              padding:  EdgeInsets.only(top:10.h),
                              child: Container(width:380.w,child: Center(child: Text('Batch Name: '+mdoc['Batch'].toString(),style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.ellipsis,))),
                            ),
                            Padding(
                              padding:  EdgeInsets.only(top:10.h),
                              child: Container(width:380.w,child: Center(child: Text('Subscription Period: '+mdoc['SubscriptionPeriod'].toString() + ' Months',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.ellipsis,))),
                            ),
                            Padding(
                              padding:  EdgeInsets.only(top:10.h),
                              child: Container(width:380.w,child: Center(child: Text('Payment ID: '+mdoc['PaymentID'].toString(),style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.ellipsis,))),
                            ),
                            if(mdoc['OrderID'] != null)
                            Padding(
                              padding:  EdgeInsets.only(top:10.h),
                              child: Container(width:380.w,child: Center(child: Text('Order ID: '+mdoc['OrderID'].toString(),style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.ellipsis,))),
                            ),
                            if(mdoc['Signature'] != null)
                              Padding(
                                padding:  EdgeInsets.only(top:10.h),
                                child: Container(width:380.w,child: Center(child: Text('Signature: '+mdoc['Signature'].toString(),style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.ellipsis,))),
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
