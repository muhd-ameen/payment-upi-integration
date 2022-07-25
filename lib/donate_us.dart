import 'package:flutter/material.dart';
import 'package:payment_integration/show_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';


class DonateUs extends StatefulWidget {
  const DonateUs({Key? key}) : super(key: key);

  @override
  State<DonateUs> createState() => _DonateUsState();
}

class _DonateUsState extends State<DonateUs> {
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController amountController = TextEditingController(text: "");
  TextEditingController emailController = TextEditingController(text: "");

  bool isUpiVisible = false;
  double amount = 0.0;
  String toUpi = "9746670322@paytm";


  void _launchURL({amount, upiId, context}) async {
    String url =
        'upi://pay?pa=$upiId&pn=Muhasabah&am=$amount&tn=Muhasabah_Donation&cu=INR';
    var result = await launch(url);
    debugPrint(result.toString());
    if (result == true) {
      debugPrint("Done");
    } else if (result == false) {
      debugPrint("Fail");
    }
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Donate Us'),
      ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF4ECCA3).withOpacity(0.05),
                      border: const OutlineInputBorder(),
                      labelText: 'Name',
                      //   hintText: 'Enter your name',
                      prefixIcon: const Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF4ECCA3).withOpacity(0.05),
                      border: const OutlineInputBorder(),
                      labelText: 'Email',
                      //   hintText: 'Enter your name',
                      prefixIcon: const Icon(Icons.mail),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                      controller: amountController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF4ECCA3).withOpacity(0.05),
                        border: const OutlineInputBorder(),
                        labelText: 'Amount',
                        //   hintText: 'Enter your amount',
                        prefixIcon: const Icon(Icons.volunteer_activism),
                      ),
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () {
                      if (amountController.text.isEmpty ||
                          emailController.text.isEmpty) {
                        showSnackBar(
                            message: 'Please fill the fields',
                            context: context);
                      } else {
                        setState(() {
                          amount = double.parse(amountController.text);
                        });
                        if (amount <= 0) {
                          showSnackBar(
                              message: 'Please enter a valid amount ',
                              context: context);
                        } else {
                          _launchURL(
                              amount: amount,
                              upiId: toUpi,
                              context: context);
                          //   Navigator.push(context, MaterialPageRoute(builder: (context)=> UpiPayment(amount: amount,upi: donateProvider.upiId)));
                        }
                      }
                    },
                    child: Container(
                      height: 50.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            offset: const Offset(1.0, 1.0),
                            blurRadius: 8.0,
                          ),
                          const BoxShadow(
                            color: Color(0xFFFFFFFF),
                            offset: Offset(-2.0, -2.0),
                            blurRadius: 8.0,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Donate',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}


// class UpiPayment extends StatefulWidget {
//
//   final double amount;
//   final String upi;
//
//   const UpiPayment({Key? key,required this.amount,required this.upi}) : super(key: key);
//
//   @override
//   _UpiPaymentState createState() => _UpiPaymentState();
// }
//
// class _UpiPaymentState extends State<UpiPayment> {
//   Future<UpiResponse>? _transaction;
//   final UpiIndia _upiIndia = UpiIndia();
//   List<UpiApp>? apps;
//
//   TextStyle header = const TextStyle(
//     fontSize: 14,
//     fontWeight: FontWeight.w500,
//   );
//
//   TextStyle value = const TextStyle(
//     fontWeight: FontWeight.w400,
//     fontSize: 14,
//   );
//
//   @override
//   void initState() {
//     _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
//       setState(() {
//         apps = value;
//       });
//     }).catchError((e) {
//       apps = [];
//     });
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         Expanded(
//           child: displayUpiApps(widget.amount,widget.upi),
//         ),
//         Expanded(
//           child: FutureBuilder(
//             future: _transaction,
//             builder: (BuildContext context, AsyncSnapshot<UpiResponse> snapshot) {
//               if (snapshot.connectionState == ConnectionState.done) {
//                 if (snapshot.hasError) {
//                   return Center(
//                     child: Text(
//                       _upiErrorHandler(snapshot.error.runtimeType),
//                       style: header,
//                     ), // Print's text message on screen
//                   );
//                 }
//
//                 // If we have data then definitely we will have UpiResponse.
//                 // It cannot be null
//                 UpiResponse _upiResponse = snapshot.data!;
//
//                 // Data in UpiResponse can be null. Check before printing
//                 String txnId = _upiResponse.transactionId ?? 'N/A';
//                 String resCode = _upiResponse.responseCode ?? 'N/A';
//                 String txnRef = _upiResponse.transactionRefId ?? 'N/A';
//                 String status = _upiResponse.status ?? 'N/A';
//                 String approvalRef = _upiResponse.approvalRefNo ?? 'N/A';
//                 _checkTxnStatus(status);
//
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       displayTransactionData('Transaction Id', txnId),
//                       displayTransactionData('Response Code', resCode),
//                       displayTransactionData('Reference Id', txnRef),
//                       displayTransactionData('Status', status.toUpperCase()),
//                       displayTransactionData('Approval No', approvalRef),
//                     ],
//                   ),
//                 );
//               } else {
//                 return const Center(
//                   child: Text(''),
//                 );
//               }
//             },
//           ),
//         )
//       ],
//     );
//   }
//
//   Future<UpiResponse> initiateTransaction(UpiApp app,double amount,String upi) async {
//     return _upiIndia.startTransaction(
//       app: app,
//       receiverUpiId: upi,
//       receiverName: 'Muhasabha',
//       transactionRefId: '',
//       transactionNote: '',
//       amount: amount,
//     );
//   }
//
//   Widget displayUpiApps(amount,upi) {
//     if (apps == null) {
//       return const Center(child: CircularProgressIndicator());
//     } else if (apps!.isEmpty) {
//       return Center(
//         child: Text(
//           "No apps found to handle transaction.",
//           style: header,
//         ),
//       );
//     } else {
//       return Align(
//         alignment: Alignment.topCenter,
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: Wrap(
//             children: apps!.map<Widget>((UpiApp app) {
//               return GestureDetector(
//                 onTap: () {
//                   _transaction = initiateTransaction(app,amount,upi);
//                   // setState(() {});
//                 },
//                 child: SizedBox(
//                   height: 100,
//                   width: 100,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Image.memory(
//                         app.icon,
//                         height: 60,
//                         width: 60,
//                       ),
//                       Text(app.name),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         ),
//       );
//     }
//   }
//
//   String _upiErrorHandler(error) {
//     switch (error) {
//       case UpiIndiaAppNotInstalledException:
//         return 'Requested app not installed on device';
//       case UpiIndiaUserCancelledException:
//         return 'You cancelled the transaction';
//       case UpiIndiaNullResponseException:
//         return 'Requested app didn\'t return any response';
//       case UpiIndiaInvalidParametersException:
//         return 'Requested app cannot handle the transaction';
//       default:
//         return 'An Unknown error has occurred';
//     }
//   }
//
//   void _checkTxnStatus(String status) {
//     switch (status) {
//       case UpiPaymentStatus.SUCCESS:
//         print('Transaction Successful');
//         break;
//       case UpiPaymentStatus.SUBMITTED:
//         print('Transaction Submitted');
//         break;
//       case UpiPaymentStatus.FAILURE:
//         print('Transaction Failed');
//         break;
//       default:
//         print('Received an Unknown transaction status');
//     }
//   }
//
//   Widget displayTransactionData(title, body) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text("$title: ", style: header),
//           Flexible(
//               child: Text(
//                 body,
//                 style: value,
//               )),
//         ],
//       ),
//     );
//   }
//
// }
