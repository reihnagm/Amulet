import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:intl/intl.dart';

import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/localization/language_constraints.dart';
import 'package:amulet/views/basewidgets/appbar/custom_appbar.dart';
import 'package:amulet/views/screens/ppob/topup/history/detail.dart';

class TopUpHistoryScreen extends StatelessWidget {
  const TopUpHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String startDate = DateFormat('yyyy-MM-dd').format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 7)).toString();
    String endDate = DateFormat('yyyy-MM-dd').format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)).toString();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            CustomAppBar(title: getTranslated("HISTORY_BALANCE", context), isBackButtonExist: true),

            Container(
              margin: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 16.0, right: 16.0),
              child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [

                        StatefulBuilder(
                          builder: (BuildContext context, Function setState) {
                            return Container(
                              margin: const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  width: 1.5,
                                  color: ColorResources.grey
                                )
                              ),
                              child: DateTimePicker(
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(8.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 0.5),
                                  ),
                                  hintText: 'Pilih Tanggal'
                                ),
                                initialValue: startDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                onChanged: (val) {
                                  setState(() => startDate = val);
                                },
                              ),
                            );
                          }, 
                        ),

                        const SizedBox(height: 10.0),

                        StatefulBuilder(
                          builder: (BuildContext context, Function setState) {
                            return Container(
                              margin: const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  width: 1.5,
                                  color: ColorResources.grey
                                )
                              ),
                              child: DateTimePicker(
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(8.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 0.5),
                                  ),
                                  hintText: 'Pilih Tanggal'
                                ),
                                initialValue: endDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                onChanged: (val) {
                                  setState(() => endDate = val);
                                },
                              ),
                            );
                          }
                        ),

                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 16.0, right: 16.0),
                          child: ElevatedButton(
                            onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) => HistoryTopUpTransaksiListScreen(startDate: startDate, endDate: endDate))), 
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(ColorResources.primaryOrange),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                )
                              )
                            ),
                            child: Text("Submit",
                              style: TextStyle(
                                color: ColorResources.white
                              ),
                            )
                          ),
                        )

                      ],
                    ),
                  ),
                ),
              ),

          ],
        ),
      ),
    );
  }
}