import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:mbm_store/common/widgets/appbar.dart';
import 'package:mbm_store/constants/utils.dart';
import 'package:mbm_store/pages/approval/pi_payment.dart';
import 'package:mbm_store/pages/approval/leave.dart';
import 'package:mbm_store/pages/approval/order_costing.dart';
import 'package:mbm_store/services/approval_service.dart';

class ApprovalPage extends StatefulWidget {
  final String? approvalName;
  static const String routeName = '/approvals';

  const ApprovalPage({Key? key, required this.approvalName}) : super(key: key);

  @override
  State<ApprovalPage> createState() => _ApprovalPageState();
}

class _ApprovalPageState extends State<ApprovalPage> {
  List<Map<String, dynamic>> approvalDataList = [];
  bool loading = false;

  @override
  void initState() {
    _loadApprovalData(widget.approvalName);
    super.initState();
  }

  Future<void> _loadApprovalData(String? approvalName) async {
    setState(() {
      loading = true;
    });

    final data = await ApprovalService.fetchApprovalData(approvalName);
    print(data);
    setState(() {
      approvalDataList = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String? formattedLabel = widget.approvalName?.replaceAll('_', ' ');
    formattedLabel = formattedLabel?.replaceAllMapped(
      RegExp(r"(^| )\w"),
          (match) => match.group(0)!.toUpperCase(),
    );

    return Scaffold(
      appBar: CustomAppBar(pageTitle: '${formattedLabel ?? ""} List'),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : approvalDataList.isNotEmpty
          ? ListView.builder(
        itemCount: approvalDataList.length,
        itemBuilder: (context, index) {
          final Map<String, dynamic> approvalData = approvalDataList[index];
            //For Order Costing
          final String orderId = approvalData['id']?.toString() ?? '';
          final String approvalName = approvalData['approval_name']?.toString() ?? '';
          final String permission = approvalData['permission']?.toString() ?? '';
          final String orderCode = approvalData['order_code']?.toString() ?? '';
          final String orderQty = approvalData['order_qty']?.toString() ?? '';
          final String bShortName = approvalData['b_shortname']?.toString() ?? '';
          final String stlNo = approvalData['stl_no']?.toString() ?? '';
          // For PI TT Payment
          final String piNo = approvalData['pi_no']?.toString() ?? '';
          final String totalPiQty = approvalData['total_pi_qty']?.toString() ?? '';
          final String totalPiValue = approvalData['total_pi_value']?.toString() ?? '';
          final String buyer = approvalData['b_shortname']?.toString() ?? '';
          final String ttType = approvalData['tt_foc_type']?.toString() ?? '';
          final String employeeName = approvalData['as_name']?.toString() ?? '';
          final String designation = approvalData['designation']?.toString() ?? '';
          final String department = approvalData['department']?.toString() ?? '';
          final String startDate = approvalData['start_date']?.toString() ?? '';
          final String endDate = approvalData['end_date']?.toString() ?? '';
          final String type = approvalData['type']?.toString() ?? '';
          return ApprovalCard(
            index: index,
            orderId: orderId,
            approvalName: approvalName,
            employeeName: employeeName,
            designation: designation,
            department: department,
            startDate: startDate,
            endDate: endDate,
            type: type,
            permission: permission,
            orderCode: orderCode,
            orderQty: orderQty,
            bShortName: bShortName,
            stlNo: stlNo,
            piNo: piNo,
            totalPiQty: totalPiQty,
            totalPiValue: totalPiValue,
            buyer: buyer,
            ttType: ttType,
            onPressed: () {
              late Widget targetPage;
              if (widget.approvalName == 'order_costing') {
                targetPage = ApprovalDetailsPageOrderCosting(approvalId: orderId);
              } else if (widget.approvalName == 'pi_tt_payment') {
                targetPage = ApprovalDetailsPagePI(approvalId: orderId);
              } else if (widget.approvalName == 'employee_leave') {
                targetPage = ApprovalDetailsLeave(approvalId: orderId);
              }
              if(targetPage != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => targetPage,
                  ),
                );
              }
            },
            onAction: (actionIndex) {
              setState(() {
                approvalDataList.removeAt(actionIndex);
              });
            },
          );
        },
      )
          : const Center(child: Text('No data available!')),
    );
  }
}

class ApprovalCard extends StatelessWidget {
  final int index;
  final String orderId;
  final String orderCode;
  final String orderQty;
  final String bShortName;
  final String employeeName;
  final String stlNo;
  final String piNo;
  final String totalPiQty;
  final String totalPiValue;
  final String buyer;
  final String ttType;
  final String approvalName;
  final String designation;
  final String department;
  final String startDate;
  final String endDate;
  final String type;
  final String permission;
  final VoidCallback onPressed;
  final Function(int) onAction;

  const ApprovalCard({
    Key? key,
    required this.index,
    required this.orderId,
    required this.orderCode,
    required this.orderQty,
    required this.bShortName,
    required this.employeeName,
    required this.stlNo,
    required this.onPressed,
    required this.onAction,
    required this.piNo,
    required this.totalPiQty,
    required this.totalPiValue,
    required this.buyer,
    required this.ttType,
    required this.approvalName,
    required this.permission,
    required this.designation,
    required this.department,
    required this.startDate,
    required this.endDate,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Card(
        elevation: 0,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.5,
              color: const Color.fromARGB(255, 29, 201, 192),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                            () {
                          switch (approvalName) {
                            case 'order_costing':
                              return 'Order No: $orderCode';
                            case 'employee_leave':
                              if (employeeName.length <= 10) {
                                return 'Name: $employeeName';
                              } else {
                                String truncatedName = employeeName.substring(0, 10);
                                return 'Name: $truncatedName...';
                              }
                            default:
                              return 'PI No: $piNo';
                          }
                        }(),
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Text(
                            () {
                          switch (approvalName) {
                            case 'order_costing':
                              return 'Style: $stlNo';
                            case 'employee_leave':
                              return 'Date: ${formatDate(startDate)}-${formatDate(endDate)}';
                            default:
                              return 'PI Qty: $totalPiQty';
                          }
                        }(),
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                            () {
                          switch (approvalName) {
                            case 'order_costing':
                              return 'Qty: $orderQty';
                            case 'employee_leave':
                              return 'Type: $type';
                            default:
                              return 'PI Value: $totalPiValue';
                          }
                        }(),
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Text(
                            () {
                          switch (approvalName) {
                            case 'order_costing':
                              return 'Buyer: $buyer';
                            case 'employee_leave':
                              return 'Des: $designation($department)';
                            default:
                              return 'Buyer: $buyer';
                          }
                        }(),
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3, // 30% of available space
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      ),
                      onPressed: onPressed,
                      child: const Text(
                        "View",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    flex: 3, // 30% of available space
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      ),
                      onPressed: () async {
                        try {
                          final response = await ApprovalService.updateStatus(1, approvalName, orderId, permission, context);
                          if (response != null) {
                            showSnackBar(context, response['msg']);
                            onAction(index);
                          } else {
                            showSnackBar(context, 'Failed!');
                          }
                        } catch (error) {
                          showSnackBar(context, 'Error: $error');
                        }
                      },
                      child: const Text(
                        "Approve",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    flex: 3, // 30% of available space
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      ),
                      onPressed: () async {
                        try {
                          final response = await ApprovalService.updateStatus(2, approvalName, orderId, permission, context);
                          if (response != null) {
                            showSnackBar(context, response['msg']);
                            onAction(index);
                          } else {
                            showSnackBar(context, 'Failed!');
                          }
                        } catch (error) {
                          showSnackBar(context, 'Error: $error');
                        }
                      },
                      child: const Text(
                        "Reject",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}