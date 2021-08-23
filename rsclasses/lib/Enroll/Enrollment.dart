import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class Enroll extends StatefulWidget {
  final String gclass,gsub,gbatch;

  const Enroll({Key key, this.gclass, this.gsub, this.gbatch}) : super(key: key);
  @override
  _EnrollState createState() => _EnrollState();
}

class _EnrollState extends State<Enroll> {
  String uclass,usub;
  String selectedBatch = null;
  int sMonths = 0;
  int tAmmount = 0;
  Razorpay _razorpay = Razorpay();
  String uname,uemail,uphone;
  ProgressDialog pr;

  @override
  void initState() {
    super.initState();
    getDetails();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response)async {
    BuildContext dialogContext;
    showDialog(context: context, builder: (BuildContext context) {
      dialogContext = context;
      return ShowPaymentStatus(
          status: 'Success');
    });
    DateTime dStart = DateTime.now();
    String SDate = DateFormat('dd-MM-yyyy').format(dStart);
    DateTime dEnd = dStart.add(Duration(days: 30*sMonths));
    String EDate = DateFormat('dd-MM-yyyy').format(dEnd);

    await FirebaseFirestore.instance.collection('Batch').doc(selectedBatch).collection('Enrollments').doc(uphone).set({
      'Name': uname,
      'StartDate': SDate,
      'EndDate': EDate,
      });
    await FirebaseFirestore.instance.collection('Transactions').doc().set({
      'Name': uname,
      'Phone' : uphone,
      'Email' : uemail,
      'Batch' : selectedBatch,
      'Amount' : tAmmount,
      'SubscriptionPeriod': sMonths,
      'OrderID' : response.orderId,
      'PaymentID' : response.paymentId,
      'Signature' : response.signature,
      'Date': SDate
    });
    await pr.hide();
    Fluttertoast.showToast(
        msg: "Enrolled Successfully...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Theme.of(context).cardColor,
        textColor: Theme.of(context).secondaryHeaderColor,
        fontSize: 16.0
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) async{
    await pr.hide();
    showDialog(context: context, builder: (BuildContext context) {
      return ShowPaymentStatus(
          status: 'Failed');
    });
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  void getDetails() async{
    DocumentSnapshot mydata =   await FirebaseFirestore.instance.collection('Users').doc(await FirebaseAuth.instance.currentUser.phoneNumber).collection('Account').doc('Profile').get();
    uname = mydata.data()['Name'];
    uemail = mydata.data()['Email'];
    uphone = await FirebaseAuth.instance.currentUser.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    if(widget.gclass != null){
      uclass = widget.gclass;
    }
    if(widget.gbatch != null){
      selectedBatch = widget.gbatch;
    }
    pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
    pr.style(
        message: 'Processing..',
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
          'Enrollment',
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
          if(uclass != null)
            Container(
              height: 650.h,
              child: Padding(
                  padding:  EdgeInsets.symmetric(vertical: 5.h,horizontal: 15.w),
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('Subjects').where('Class',isEqualTo: uclass).snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.docs.isNotEmpty) {
                            return ListView(
                              children: snapshot.data.docs.map((mdoc) =>
                                  ExpansionTile(
                                    initiallyExpanded: (widget.gsub == mdoc['Name'])?true:false,
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:  EdgeInsets.only(left:10.w),
                                          child: Text(
                                            mdoc['Name'],
                                            style: TextStyle(
                                                color: Theme.of(context).accentColor,
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Text(
                                          '₹' + mdoc['Fee'].toString() + '/month',
                                          style: TextStyle(
                                              color: Theme.of(context).secondaryHeaderColor,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                    children: <Widget>[
                                      StreamBuilder(
                                          stream: FirebaseFirestore.instance.collection('Batch').where('Subject',isEqualTo: mdoc.id).snapshots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<QuerySnapshot>snapshot) {
                                            if (snapshot.hasData) {
                                              if(snapshot.data.docs.isNotEmpty){
                                                return Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            IconButton(
                                                              icon: Icon(Icons.remove_circle,size: 30.r,color: Theme.of(context).accentColor),
                                                              onPressed: (){
                                                                setState(() {
                                                                  sMonths -= 1;
                                                                  if(sMonths <= 0){
                                                                    sMonths = 0;
                                                                  }
                                                                  tAmmount = mdoc['Fee'] * sMonths;
                                                                });
                                                              },
                                                            ),
                                                            Container(
                                                              width: 60.w,
                                                              height: 50.h,
                                                              decoration: BoxDecoration(
                                                                  color: Theme.of(context).cardColor,
                                                                  borderRadius: BorderRadius.circular(10)),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Center(
                                                                    child: Text(
                                                                      sMonths.toString(),
                                                                      style: TextStyle(
                                                                          fontSize: 16.sp,
                                                                          fontWeight: FontWeight.w600,
                                                                          color: Theme.of(context).secondaryHeaderColor),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    'Months'.toString(),
                                                                    style: TextStyle(
                                                                        fontSize: 10.sp,
                                                                        fontWeight: FontWeight.w300,
                                                                        color: Theme.of(context).secondaryHeaderColor),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            IconButton(
                                                              icon: Icon(Icons.add_circle_rounded,size: 30.r,color: Theme.of(context).accentColor,),
                                                              onPressed: (){
                                                                setState(() {
                                                                  sMonths += 1;
                                                                  tAmmount = mdoc['Fee'] * sMonths;

                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: 120.w,
                                                          height: 50.h,
                                                          child: FlatButton(
                                                            onPressed: () async{
                                                              showDialog(context: context, builder: (BuildContext context) {
                                                                return OnlineBlock();
                                                              });
                                                              /*
                                                              if(selectedBatch == null){
                                                                Fluttertoast.showToast(
                                                                    msg: "Select a Batch First!!!",
                                                                    toastLength: Toast.LENGTH_SHORT,
                                                                    gravity: ToastGravity.BOTTOM,
                                                                    backgroundColor: Theme.of(context).cardColor,
                                                                    textColor: Theme.of(context).secondaryHeaderColor,
                                                                    fontSize: 16.0
                                                                );
                                                              }
                                                              if(sMonths <= 0 || tAmmount <= 0 ){
                                                                Fluttertoast.showToast(
                                                                    msg: "Please Choose Subscription Period!!!",
                                                                    toastLength: Toast.LENGTH_SHORT,
                                                                    gravity: ToastGravity.BOTTOM,
                                                                    backgroundColor: Theme.of(context).cardColor,
                                                                    textColor: Theme.of(context).secondaryHeaderColor,
                                                                    fontSize: 16.0
                                                                );
                                                              }
                                                              if(selectedBatch != null && sMonths != 0){
                                                                await pr.show();
                                                                var options = {
                                                                  'key': 'rzp_test_vvmL74ruMq320f',
                                                                  'amount': tAmmount * 100,
                                                                  'name': 'Anurag Coaching Classes',
                                                                  'description':'Enrollment Fee for $sMonths Months',
                                                                  'prefill': {'contact': uphone, 'email': uemail},
                                                                  'external': {
                                                                    'wallets': ['paytm']
                                                                  }
                                                                };
                                                                try {
                                                                  _razorpay.open(options);
                                                                } catch (e) {
                                                                  debugPrint(e);
                                                                }
                                                              }

                                                               */
                                                            },
                                                            child: Padding(
                                                              padding:  EdgeInsets.symmetric(vertical: 8.h),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Text(
                                                                    'Pay: ₹',
                                                                    style: TextStyle(
                                                                        color: Theme.of(context).primaryColor,
                                                                        fontSize: 14.sp,
                                                                        fontWeight: FontWeight.w400),
                                                                  ),
                                                                  Text(
                                                                    tAmmount.toString(),
                                                                    style: TextStyle(
                                                                        color: Theme.of(context).primaryColor,
                                                                        fontSize: 14.sp,
                                                                        fontWeight: FontWeight.w400),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            color: Theme.of(context).accentColor,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(10.0)),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Column(
                                                      children: snapshot.data.docs.map((mdocc) => Padding(
                                                        padding:  EdgeInsets.only(top:10.h,bottom: 10.h),
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
                                                                        if(mdocc['Schedule']['Sunday'] == true)
                                                                          Text('Sun',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                                                        if(mdocc['Schedule']['Monday'] == true)
                                                                          Text('Mon',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                                                        if(mdocc['Schedule']['Tuesday'] == true)
                                                                          Text('Tue',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                                                        if(mdocc['Schedule']['Wednesday'] == true)
                                                                          Text('Wed',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                                                        if(mdocc['Schedule']['Thursday'] == true)
                                                                          Text('Thu',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                                                        if(mdocc['Schedule']['Friday'] == true)
                                                                          Text('Fri',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                                                        if(mdocc['Schedule']['Saturday'] == true)
                                                                          Text('Sat',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                                                      ]

                                                                  ),
                                                                ),
                                                                SizedBox(height: 20.h,)
                                                              ],
                                                            ),
                                                              Align(
                                                                alignment: Alignment.topLeft,
                                                                  child: Radio(value: mdocc.id, groupValue: selectedBatch, onChanged:(e){
                                                                    setState(() {
                                                                      selectedBatch = e;
                                                                    });
                                                                  }))
                                                            ],
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
                                      //SizedBox(height: 20.h,)
                                    ],

                                  ),
                              ).toList(),
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
                                    'Getting Classes...',
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

            )
        ],
      ),
    );
  }
}

class ShowPaymentStatus extends StatelessWidget {
  final String status;
  const ShowPaymentStatus({Key key, this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
    ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          height: 300.h,
          margin: EdgeInsets.only(top: 1.h),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: (status == 'Success')?
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.green,
              radius: 70.r,
              child: Icon(Icons.done,color: Theme.of(context).primaryColor,size: 50.r,)),
          Padding(
            padding:  EdgeInsets.only(top:20.h),
            child: Text(
              'Payment Successful',
              style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ):
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 70.r,
                  child: Icon(Icons.close,color: Theme.of(context).primaryColor,size: 50.r,)),
              Padding(
                padding:  EdgeInsets.only(top:20.h),
                child: Text(
                  'Payment Failed',
                  style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          )
    ));
  }
}

class OnlineBlock extends StatelessWidget {
  const OnlineBlock({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
            height: 300.h,
            margin: EdgeInsets.only(top: 1.h),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_rounded,color: Colors.red,size: 80.r,),
                Padding(
                  padding:  EdgeInsets.only(top:20.h),
                  child: Text(
                    'Online Enrollment is Disabled.',
                    style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(top:5.h),
                  child: Text(
                    'Contact administration for Enrollment.',
                    style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            )
        ));
  }
}


