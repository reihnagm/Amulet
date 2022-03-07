import 'dart:async';

import 'package:amulet/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:amulet/views/screens/ppob/cashout/confirmation.dart';
import 'package:amulet/views/screens/ppob/cashout/success.dart';
import 'package:amulet/views/screens/ppob/checkout/register.dart';
import 'package:amulet/views/screens/ppob/topup/success.dart';
import 'package:amulet/data/models/ppob/cashout/bank.dart';
import 'package:amulet/data/models/ppob/cashout/denom.dart';
import 'package:amulet/data/models/ppob/cashout/emoney.dart';
import 'package:amulet/data/models/ppob/cashout/inquiry.dart';
import 'package:amulet/data/models/ppob/registration/pay.dart';
import 'package:amulet/data/models/ppob/wallet/balance.dart';
import 'package:amulet/localization/language_constraints.dart';
import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/utils/constant.dart';
import 'package:amulet/utils/dimensions.dart';
import 'package:amulet/utils/dio.dart';
import 'package:amulet/utils/exceptions.dart';
import 'package:amulet/utils/helper.dart';
import 'package:amulet/views/basewidgets/separator/separator.dart';
import 'package:amulet/views/screens/ppob/confirm_payment.dart';
import 'package:amulet/views/screens/ppob/payment_success.dart';
import 'package:amulet/data/models/ppob/list_product_denom.dart';
import 'package:amulet/data/models/ppob/pln/inquiry_pasca.dart';
import 'package:amulet/data/models/ppob/pln/inquiry_pra.dart';
import 'package:amulet/data/models/ppob/pln/list_price_pra.dart';
import 'package:amulet/data/models/ppob/va.dart';
import 'package:amulet/data/models/ppob/wallet/history.dart';
import 'package:amulet/data/models/ppob/wallet/inquiry_topup.dart';

// PLN
enum InquiryPLNPrabayarStatus  { loading, loaded, empty, error }
enum ListPricePLNPrabayarStatus { idle, loading, loaded, empty, error }
enum InquiryPLNPascabayarStatus { loading, loaded, empty, error }

// PULSA
enum ListVoucherPulsaByPrefixStatus { idle, loading, loaded, empty, error }

// EMONEY
enum ListTopUpEmoneyStatus { loading, loaded, empty, error }

// VA 
enum VaStatus { loading, loaded, empty, error }

// WALLET 
enum BalanceStatus { loading, loaded, empty, error }
enum HistoryBalanceStatus { loading, loaded, empty, error }

// DISBURSEMENT
enum InquiryDisbursementStatus { idle, loading, loaded, empty, error }
enum DenomDisbursementStatus { idle, loading, loaded, empty, error }
enum BankDisbursementStatus { loading, loaded, empty, error }
enum EmoneyDisbursementStatus { loading, loaded, empty, error }
enum SubmitDisbursementStatus { idle, loading, loaded, empty, error }


class PPOBProvider with ChangeNotifier {
  final AuthProvider authProvider;
  final SharedPreferences sharedPreferences;

  PPOBProvider({
    required this.authProvider,
    required this.sharedPreferences
  });

  // PLN
  bool btnNextBuyPLNPrabayar = false;

  // Konfirmasi Pembayaran
  bool loadingBuyBtn = false;

  late double? balance;

  /*-- Prabayar --*/ 
  late InquiryPLNPrabayarData? inquiryPLNPrabayarData;

  /*-- Pascabayar -- */
  late InquiryPLNPascaBayarData? inquiryPLNPascaBayarData; 

  /*-- TopUp E-Wallet --*/
  late InquiryTopUpData? inquiryTopUpData;

  List<ListPricePraBayarData> _listPricePLNPrabayarData = [];
  List<ListPricePraBayarData> get listPricePLNPrabayarData => _listPricePLNPrabayarData;

  List<ListProductDenomData> _listTopUpEmoney = [];
  List<ListProductDenomData> get  listTopUpEmoney => _listTopUpEmoney;

  List<ListProductDenomData> _listVoucherPulsaByPrefixData = [];
  List<ListProductDenomData> get listVoucherPulsaByPrefixData => _listVoucherPulsaByPrefixData;

  List<VAData> _listVa = [];
  List<VAData> get listVa => _listVa;

  List<HistoryBalanceData> _historyBalanceData = [];
  List<HistoryBalanceData> get historyBalanceData => _historyBalanceData;

  ListPricePLNPrabayarStatus _listPricePLNPrabayarStatus = ListPricePLNPrabayarStatus.idle;
  ListPricePLNPrabayarStatus get listPricePLNPrabayarStatus => _listPricePLNPrabayarStatus;

  InquiryPLNPrabayarStatus _inquiryPLNPrabayarStatus = InquiryPLNPrabayarStatus.loading; 
  InquiryPLNPrabayarStatus get inquiryPLNPrabayarStatus => _inquiryPLNPrabayarStatus;

  InquiryPLNPascabayarStatus _inquiryPLNPascaBayarStatus = InquiryPLNPascabayarStatus.empty;
  InquiryPLNPascabayarStatus get inquiryPLNPascabayarStatus => _inquiryPLNPascaBayarStatus;

  ListVoucherPulsaByPrefixStatus _listVoucherPulsaByPrefixStatus = ListVoucherPulsaByPrefixStatus.idle;
  ListVoucherPulsaByPrefixStatus get listVoucherPulsaByPrefixStatus => _listVoucherPulsaByPrefixStatus;

  /* -- List Price PLN Prabayar --*/
  void setStateListPricePLNPrabayarStatus(ListPricePLNPrabayarStatus listPricePLNPrabayarStatus) {
    _listPricePLNPrabayarStatus = listPricePLNPrabayarStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  /* -- Prabayar -- */ 
  void setStateInquiryPLNPrabayarStatus(InquiryPLNPrabayarStatus inquiryPLNPrabayarStatus) {
    _inquiryPLNPrabayarStatus = inquiryPLNPrabayarStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  /* -- Pascabayar -- */
  void setStateInquiryPLNPascabayarStatus(InquiryPLNPascabayarStatus inquiryPLNPascaBayarStatus) {
    _inquiryPLNPascaBayarStatus = inquiryPLNPascaBayarStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateListVoucherPulsaByPrefixStatus(ListVoucherPulsaByPrefixStatus listVoucherPulsaByPrefixStatus) {
    _listVoucherPulsaByPrefixStatus = listVoucherPulsaByPrefixStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  // E-MONEY
  ListTopUpEmoneyStatus _listTopUpEmoneyStatus = ListTopUpEmoneyStatus.empty;
  ListTopUpEmoneyStatus get listTopUpEmoneyStatus => _listTopUpEmoneyStatus;

  void setStateListTopUpEmoneyStatus(ListTopUpEmoneyStatus listTopUpEmoneyStatus) {
    _listTopUpEmoneyStatus = listTopUpEmoneyStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }
   
  // VA
  VaStatus _vaStatus = VaStatus.loading;
  VaStatus get vaStatus => _vaStatus;

  void setStateVAStatus(VaStatus vaStatus) {
    _vaStatus = vaStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  // Wallet 
  BalanceStatus _balanceStatus = BalanceStatus.loading;
  BalanceStatus get balanceStatus => _balanceStatus;

  HistoryBalanceStatus _historyBalanceStatus = HistoryBalanceStatus.loading;
  HistoryBalanceStatus get historyBalanceStatus => _historyBalanceStatus;

  void setStateHistoryBalanceStatus(HistoryBalanceStatus historyBalanceStatus) {
    _historyBalanceStatus = historyBalanceStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateBalanceStatus(BalanceStatus walletStatus) {
    _balanceStatus = walletStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  // Disbursement 
  InquiryDisbursementStatus _inquirydisbursementStatus = InquiryDisbursementStatus.idle;
  InquiryDisbursementStatus get disbursementStatus => _inquirydisbursementStatus;

  List<DenomDisbursementBody> _denomDisbursement = [];
  List<DenomDisbursementBody> get denomDisbursement => _denomDisbursement;

  List<BankDisbursementBody> _bankDisbursement = [];
  List<BankDisbursementBody> get bankDisbursement => _bankDisbursement;

  DenomDisbursementStatus _denomDisbursementStatus = DenomDisbursementStatus.loading;
  DenomDisbursementStatus get denomDisbursementStatus => _denomDisbursementStatus;

  BankDisbursementStatus _bankDisbursementStatus = BankDisbursementStatus.loading;
  BankDisbursementStatus get bankDisbursementStatus => _bankDisbursementStatus; 

  List<EmoneyDisbursementBody> _emoneyDisbursement = [];
  List<EmoneyDisbursementBody> get emoneyDisbursement => _emoneyDisbursement;

  EmoneyDisbursementStatus _emoneyDisbursementStatus = EmoneyDisbursementStatus.loading;
  EmoneyDisbursementStatus get emoneyDisbursementStatus => _emoneyDisbursementStatus;

  SubmitDisbursementStatus _submitDisbursementStatus = SubmitDisbursementStatus.idle;
  SubmitDisbursementStatus get submitDisbursementStatus => _submitDisbursementStatus;

  void setStateDisbursementStatus(InquiryDisbursementStatus inquirydisbursementStatus) {
    _inquirydisbursementStatus = inquirydisbursementStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateDenomDisbursementStatus(DenomDisbursementStatus denomDisbursementStatus) {
    _denomDisbursementStatus = denomDisbursementStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateBankDisbursementStatus(BankDisbursementStatus bankDisbursementStatus) {
    _bankDisbursementStatus = bankDisbursementStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateEmoneyDisbursementStatus(EmoneyDisbursementStatus emoneyDisbursementStatus) {
    _emoneyDisbursementStatus = emoneyDisbursementStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateSubmitDisbursementStatus(SubmitDisbursementStatus submitDisbursementStatus) {
    _submitDisbursementStatus = submitDisbursementStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future setAccountPaymentMethod(String account) async {
    sharedPreferences.setString("global_payment_method_account", account);
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future changePaymentMethod(String name, String code) async {
    sharedPreferences.setString("global_payment_method_name", name);
    sharedPreferences.setString("global_payment_method_code", code);
    Future.delayed(Duration.zero,() => notifyListeners());
  }

  Future removePaymentMethod() async {
    sharedPreferences.remove("global_payment_method_name");
    sharedPreferences.remove("global_payment_method_code");
    sharedPreferences.remove("global_payment_method_account");
    Future.delayed(Duration.zero,() => notifyListeners());
  }

  String get getGlobalPaymentAccount => sharedPreferences.getString("global_payment_method_account") ?? "";
  String get getGlobalPaymentMethodName => sharedPreferences.getString("global_payment_method_name") ?? "";
  String get getGlobalPaymentMethodCode => sharedPreferences.getString("global_payment_method_code") ?? "";

  Future payRegister(BuildContext context, 
    String productId, 
    String paymentCode, 
    String paymentChannel, 
    String transactionId
  ) async {
    try {
      loadingBuyBtn = true;
      Future.delayed(Duration.zero, () => notifyListeners());
      Dio dio = Dio();
      Response res =  await dio.post("${AppConstants.baseUrlPpob}/registration/pay", data: {
        "productId": productId,
        "paymentChannel" : paymentChannel,
        "paymentMethod": "BANK_TRANSFER",
        "transactionId" : transactionId
      }, options: Options(
        headers: {
          "Authorization": "Bearer ${authProvider.getUserToken()}",
          "X-Context-ID": AppConstants.xContextId
        }
      ));
      Map<String, dynamic> data = res.data;
      PayRegisterModel payRegisterModel = PayRegisterModel.fromJson(data);
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => CheckoutRegistrasiScreen(
          adminFee: double.parse(payRegisterModel.body!.data!.paymentAdminFee.toString()),
          guide: payRegisterModel.body!.data!.paymentGuide!,
          paymentCode: paymentCode,
          nameBank: payRegisterModel.body!.data!.paymentChannel,
          noVa: payRegisterModel.body!.data!.paymentCode,
          productPrice: double.parse(payRegisterModel.body!.productPrice.toString()),
          transactionId: payRegisterModel.body!.transactionId!,
        )),
      );
      loadingBuyBtn = false;
      Future.delayed(Duration.zero, () => notifyListeners());
    } on DioError catch(e) {
      debugPrint(e.response!.data.toString());
      debugPrint(e.response!.statusCode.toString());
      if(e.response?.statusCode == 400) {
        loadingBuyBtn = false;
        Future.delayed(Duration.zero, () => notifyListeners());
        Fluttertoast.showToast(
          msg: "${e.response?.statusCode} : ${e.response?.data["message"]}",
          backgroundColor: ColorResources.error
        );
      }
      loadingBuyBtn = false;
      Future.delayed(Duration.zero, () => notifyListeners());
    } catch(e) {
      loadingBuyBtn = false;
      Future.delayed(Duration.zero, () => notifyListeners());
      debugPrint(e.toString());
    }
  }

  Future payPLNPrabayar(BuildContext context, String productId, String accountNumber, String transactionId) async {
    loadingBuyBtn = true;
    Future.delayed(Duration.zero, () => notifyListeners());
    try {
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.baseUrlPpob}/pln/prabayar/pay", data: {
        "productId" : productId,
        "accountNumber" : accountNumber,
        "paymentMethod": "WALLET",
        "transactionId": transactionId
      });
      loadingBuyBtn = false;
      Future.delayed(Duration.zero, () => notifyListeners());
      Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentSuccessScreen()));
    } on DioError catch(e) {
      if(e.response?.statusCode == 400) {
        loadingBuyBtn = false;
        Future.delayed(Duration.zero, () => notifyListeners());
        Fluttertoast.showToast(
          msg: "${e.response?.statusCode} : ${e.response?.data["message"]}",
          backgroundColor: ColorResources.error
        );
      }
      loadingBuyBtn = false;
      Future.delayed(Duration.zero, () => notifyListeners());
    } catch(e) {
      loadingBuyBtn = false;
      notifyListeners();
      debugPrint(e.toString());
    }
  }

  Future payPLNPascabayar(BuildContext context, String accountNumber, String transactionId) async {
    try {
      loadingBuyBtn = true;
      Future.delayed(Duration.zero, () => notifyListeners());
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.baseUrlPpob}/pln/pascabayar/pay", data: {
        "productId": "49c55554-8c62-4f80-8758-d8f0cea1b63b",
        "accountNumber": accountNumber,
        "paymentMethod": "WALLET",
        "transactionId": transactionId
      });
      loadingBuyBtn = false;
      Future.delayed(Duration.zero, () => notifyListeners());
      Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentSuccessScreen()));
    } on DioError catch(e) {
      if(e.response?.statusCode == 400) {
        loadingBuyBtn = false;
        Future.delayed(Duration.zero, () => notifyListeners());
        Fluttertoast.showToast(
          msg: "${e.response?.statusCode} : ${e.response?.data["message"]}",
          backgroundColor: ColorResources.error
        );
      }
      loadingBuyBtn = false;
      Future.delayed(Duration.zero, () => notifyListeners());
    } catch(e) {
      loadingBuyBtn = false;
      Future.delayed(Duration.zero, () => notifyListeners());
    }
  }

  Future<void> inquiryTopUp(BuildContext context, String productId, String accountNumber) async {
    try {
      loadingBuyBtn = true;
      Future.delayed(Duration.zero, () => notifyListeners());
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.baseUrlPpob}/wallet/inquiry", data: {
        "productId": productId,
        "accountNumber" : accountNumber
      });
      InquiryTopUpModel inquiryTopUpModel = InquiryTopUpModel.fromJson(res.data);
      inquiryTopUpData = inquiryTopUpModel.body!;
      loadingBuyBtn = false;
      Future.delayed(Duration.zero, () => notifyListeners());
    } on DioError catch(e) {
      if(e.response?.statusCode == 400) {
        loadingBuyBtn = false;
        Future.delayed(Duration.zero, () => notifyListeners());
        Fluttertoast.showToast(
          msg: "${e.response?.statusCode} : ${e.response?.data["message"]}",
          backgroundColor: ColorResources.error
        );
      }
      loadingBuyBtn = false;
      Future.delayed(Duration.zero, () => notifyListeners());
    } catch(e) {
      loadingBuyBtn = false;
      notifyListeners();
      debugPrint(e.toString());
    }
  }

  Future<void> payTopUp(BuildContext context, String productId, String paymentChannel, String transactionId) async {
    try {
      loadingBuyBtn = true;
      Future.delayed(Duration.zero, () => notifyListeners());
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.baseUrlPpob}/wallet/pay", data : {
        "productId": productId,
        "paymentMethod" : "BANK_TRANSFER",
        "paymentChannel": paymentChannel,
        "transactionId": transactionId
      });
      loadingBuyBtn = false;
      Future.delayed(Duration.zero, () => notifyListeners());
      Navigator.push(context, MaterialPageRoute(builder: (context) => const TopUpSuccessScreen()));
    } on DioError catch(e) {
      if(e.response?.statusCode == 400) {
        loadingBuyBtn = false;
        Future.delayed(Duration.zero, () => notifyListeners());
        Fluttertoast.showToast(
          msg: "${e.response?.statusCode} : ${e.response?.data["message"]}",
          backgroundColor: ColorResources.error
        );
      }
      loadingBuyBtn = false;
      Future.delayed(Duration.zero, () => notifyListeners());
    } catch(e) {
      loadingBuyBtn = false;
      Future.delayed(Duration.zero, () => notifyListeners());
      debugPrint(e.toString());
    }
  }

  Future<void> purchasePulsa(BuildContext context, String productId, String accountNumber) async {
    try {
      loadingBuyBtn = true;
      Future.delayed(Duration.zero, () => notifyListeners());
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.baseUrlPpob}/pulsa/purchase", data: {
        "productId": productId,
        "accountNumber": accountNumber,
        "paymentMethod": "WALLET"
      });
      loadingBuyBtn = false;
      Future.delayed(Duration.zero, () => notifyListeners());
      Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentSuccessScreen()));
    } on DioError catch(e) {
      if(e.response?.statusCode == 400) {
        loadingBuyBtn = false;
        Future.delayed(Duration.zero, () => notifyListeners());
        Fluttertoast.showToast(
          msg: "${e.response?.statusCode} : ${e.response?.data["message"]}",
          backgroundColor: ColorResources.error
        );
      } 
      loadingBuyBtn = false;
      Future.delayed(Duration.zero, () => notifyListeners());
    } catch(e) {
      loadingBuyBtn = false;
      Future.delayed(Duration.zero, () => notifyListeners());    
      debugPrint(e.toString());
    }
  }

  Future<void> purchaseEvent(BuildContext context, String productId, String accountNumber, String paymentChannel, String transactionId) async {
    try {
      loadingBuyBtn = true;
      Future.delayed(Duration.zero, () => notifyListeners());
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.baseUrlPpob}/community/pay", data: {
        "productId": productId,
        "accountNumber": accountNumber,
        "paymentMethod": "BANK_TRANSFER",
        "paymentChannel": paymentChannel,
        "transactionId": transactionId
      });
      loadingBuyBtn = false;
      Future.delayed(Duration.zero, () => notifyListeners());
      Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentSuccessScreen()));
    } on DioError catch(e) {
      debugPrint(e.response?.statusCode.toString());
      debugPrint(e.response?.data);
      if(e.response?.statusCode == 400) {
        loadingBuyBtn = false;
        Future.delayed(Duration.zero, () => notifyListeners());
        Fluttertoast.showToast(
          msg: "${e.response?.statusCode} : ${e.response?.data["message"]}",
          backgroundColor: ColorResources.error
        );
      } 
      loadingBuyBtn = false;
      Future.delayed(Duration.zero, () => notifyListeners());
    } catch(e) {
      loadingBuyBtn = false;
      Future.delayed(Duration.zero, () => notifyListeners());    
      debugPrint(e.toString());
    }
  }

  Future<void> purchaseEmoney(BuildContext context, String productId, String accountNumber) async {
    try {
      loadingBuyBtn = true;
      Future.delayed(Duration.zero, () => notifyListeners());
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.baseUrlPpob}/emoney/purchase", data: {
        "productId": productId,
        "accountNumber": accountNumber,
        "paymentMethod": "WALLET"
      });
      loadingBuyBtn = false;
      Future.delayed(Duration.zero, () => notifyListeners());
      Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentSuccessScreen()));
    } on DioError catch(e) {
      debugPrint(e.response?.statusCode.toString());
      debugPrint(e.response?.data);
      if(e.response?.statusCode == 400) {
        loadingBuyBtn = false;
        Future.delayed(Duration.zero, () => notifyListeners());
        Fluttertoast.showToast(
          msg: "${e.response?.statusCode} : ${e.response?.data["message"]}",
          backgroundColor: ColorResources.error
        );
      }
      loadingBuyBtn = false;
      Future.delayed(Duration.zero, () => notifyListeners());
    } catch(e) {
      loadingBuyBtn = false;
      Future.delayed(Duration.zero, () => notifyListeners());
      debugPrint(e.toString());
    }
  }

  Future postInquiryPLNPrabayarStatus(BuildContext context, String productId, String accountNumber, String paymentMethod) async {
    try {
      btnNextBuyPLNPrabayar = true;
      Future.delayed(Duration.zero, () => notifyListeners());

      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.baseUrlPpob}/pln/prabayar/inquiry", data: {
        "productId" : productId,
        "accountNumber" : accountNumber,
        "paymentMethod": paymentMethod
      });

      InquiryPLNPrabayarModel inquiryPLNPrabayarModel = InquiryPLNPrabayarModel.fromJson(res.data);
      inquiryPLNPrabayarData = inquiryPLNPrabayarModel.data!;

      btnNextBuyPLNPrabayar = false;
      Future.delayed(Duration.zero, () => notifyListeners());
      setStateInquiryPLNPrabayarStatus(InquiryPLNPrabayarStatus.loaded);

      showMaterialModalBottomSheet(        
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        context: context,
        builder: (context) => SingleChildScrollView(
          child: SizedBox(
            height: 300.0,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getTranslated("CUSTOMER_INFORMATION", context),
                        softWrap: true,
                        style: TextStyle(
                          fontSize: Dimensions.fontSizeSmall,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(getTranslated("METER_NUMBER", context),
                            style: TextStyle(
                              fontSize: Dimensions.fontSizeSmall
                            ),
                          ),
                          Text(accountNumber,
                            style: TextStyle(
                              fontSize: Dimensions.fontSizeExtraSmall
                            )
                          )
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(getTranslated("CUSTOMER_NAME", context),
                            style: TextStyle(
                              fontSize: Dimensions.fontSizeSmall,
                            ),
                          ),
                          Text(inquiryPLNPrabayarData!.data!.accountName!,
                            style: TextStyle(
                              fontSize: Dimensions.fontSizeExtraSmall
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  width: double.infinity,
                  color: Colors.blueGrey[50],
                  height: 8.0,
                ),
                const SizedBox(height: 12.0),
                 Container(
                  margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getTranslated("DETAIL_PAYMENT", context),
                        softWrap: true,
                        style: TextStyle(
                          fontSize: Dimensions.fontSizeSmall,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Token Listrik",
                            style: TextStyle(
                              fontSize: Dimensions.fontSizeExtraSmall
                            ),
                          ),
                          Text(Helper.formatCurrency(inquiryPLNPrabayarData!.productPrice),
                            style: TextStyle(
                              fontSize: Dimensions.fontSizeExtraSmall
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      MySeparatorDash(
                        color: Colors.blueGrey[50]!,
                        height: 3.0,
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(getTranslated("TOTAL_PAYMENT", context),
                            style: TextStyle(
                              fontSize: Dimensions.fontSizeExtraSmall,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(Helper.formatCurrency(inquiryPLNPrabayarData!.productPrice),
                            style: TextStyle(
                              fontSize: Dimensions.fontSizeExtraSmall,
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 140.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: ColorResources.white,
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide.none
                          ), 
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(getTranslated("EDIT", context),
                          style: TextStyle(
                            fontSize: Dimensions.fontSizeExtraSmall,
                            color: ColorResources.purpleDark
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 140.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: ColorResources.purpleDark,
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide.none
                          ),
                        ),
                        onPressed: () { 
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ConfirmPaymentScreen(
                              type: "pln-prabayar",
                              description: inquiryPLNPrabayarData!.productName,
                              nominal : inquiryPLNPrabayarData!.productPrice,
                              provider: "pln",
                              accountNumber: inquiryPLNPrabayarData!.accountNumber1,
                              productId: inquiryPLNPrabayarData!.productId,
                            )),
                          );
                        },
                        child: Text(getTranslated("CONFIRM", context),
                          style: TextStyle(
                            fontSize: Dimensions.fontSizeExtraSmall,
                            color: ColorResources.white
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
    } on DioError catch(_) {
      setStateInquiryPLNPrabayarStatus(InquiryPLNPrabayarStatus.error);
      showMaterialModalBottomSheet(
        context: context, 
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        builder: (BuildContext context) {
        return Container(
          height: 320.0,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0))
          ),
          child: Container(
            margin: const EdgeInsets.only(left: Dimensions.marginSizeSmall, right: Dimensions.marginSizeSmall),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LottieBuilder.asset("assets/lottie/error.json",
                  width: 100.0,
                  height: 100.0,
                ),
                Center(
                  child: Text("Ups! Maaf, nomor pelanggan salah / Sedang ada gangguan",
                    style: TextStyle(
                      fontSize: Dimensions.fontSizeSmall
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      });
      btnNextBuyPLNPrabayar = false;
      Future.delayed(Duration.zero, () => notifyListeners());
    } catch(e) {
      debugPrint(e.toString());
      btnNextBuyPLNPrabayar = false;
      Future.delayed(Duration.zero, () => notifyListeners());
    }
  }

  Future<void> postInquiryPLNPascaBayar(BuildContext context, String accountNumber, TextEditingController controller, dynamic listener) async {
    try {
      setStateInquiryPLNPascabayarStatus(InquiryPLNPascabayarStatus.loading);
      
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.baseUrlPpob}/pln/pascabayar/inquiry", data: {
        "productId": "49c55554-8c62-4f80-8758-d8f0cea1b63b",
        "accountNumber": accountNumber
      });

      InquiryPLNPascabayarModel inquiryPLNPascaBayarModel = InquiryPLNPascabayarModel.fromJson(res.data);
      inquiryPLNPascaBayarData = inquiryPLNPascaBayarModel.body!;

      setStateInquiryPLNPascabayarStatus(InquiryPLNPascabayarStatus.loaded);

      controller.removeListener(listener);
      showMaterialModalBottomSheet(        
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), 
            topRight: Radius.circular(20.0)
          ),
        ),
        context: context,
        builder: (context) => SingleChildScrollView(
          child: SizedBox(
            height: 315.0,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getTranslated("CUSTOMER_INFORMATION", context),
                        style: TextStyle(
                          fontSize: Dimensions.fontSizeSmall,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(getTranslated("METER_NUMBER", context),
                            style: TextStyle(
                              fontSize: Dimensions.fontSizeExtraSmall
                            ),
                          ),
                          Text(accountNumber,
                            style: TextStyle(
                              fontSize: Dimensions.fontSizeExtraSmall
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(getTranslated("CUSTOMER_NAME", context),
                            style: TextStyle(
                              fontSize: Dimensions.fontSizeExtraSmall
                            ),
                          ),
                          Text(inquiryPLNPascaBayarData!.data!.accountName!,
                            style: TextStyle(
                              fontSize: Dimensions.fontSizeExtraSmall
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  width: double.infinity,
                  color: Colors.blueGrey[50],
                  height: 8.0,
                ),
                const SizedBox(height: 12.0),
                 Container(
                  margin: const EdgeInsets.only(left: Dimensions.marginSizeSmall, right: Dimensions.marginSizeSmall),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getTranslated("DETAIL_PAYMENT", context),
                        style: TextStyle(
                          fontSize: Dimensions.fontSizeSmall,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Tagihan Listrik",
                            style: TextStyle(
                              fontSize: Dimensions.fontSizeExtraSmall
                            ),
                          ),
                          Text(Helper.formatCurrency(double.parse(inquiryPLNPascaBayarData!.data!.amount!.toString())),
                            style: TextStyle(
                              fontSize: Dimensions.fontSizeExtraSmall
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      MySeparatorDash(
                        color: Colors.blueGrey[50]!,
                        height: 3.0,
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(getTranslated("TOTAL_PAYMENT", context),
                            style: TextStyle(
                              fontSize: Dimensions.fontSizeExtraSmall,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(Helper.formatCurrency(double.parse(inquiryPLNPascaBayarData!.data!.amount.toString())),
                            style: TextStyle(
                              fontSize: Dimensions.fontSizeExtraSmall,
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 140.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: ColorResources.white,
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide.none
                          ),
                        ),
                        onPressed: () { 
                          controller.addListener(listener);
                          Navigator.of(context).pop();
                        },
                        child: Text(getTranslated("EDIT", context),
                          style: TextStyle(
                            fontSize: Dimensions.fontSizeSmall,
                            color: ColorResources.purpleDark
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 140.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          primary: ColorResources.purpleDark,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide.none
                          ),
                        ),
                        onPressed: () { 
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ConfirmPaymentScreen(
                              type: "pln-pascabayar",
                              description: inquiryPLNPascaBayarData!.productName!,
                              nominal : inquiryPLNPascaBayarData!.data!.amount!,
                              provider: "pln",
                              accountNumber: inquiryPLNPascaBayarData!.accountNumber1,
                              productId: inquiryPLNPascaBayarData!.productId,
                            )),
                          );
                        },
                        child: Text(getTranslated("CONFIRM", context),
                          style: TextStyle(
                            fontSize: Dimensions.fontSizeSmall,
                            color: ColorResources.white
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
    } on DioError catch(_) {
      setStateInquiryPLNPrabayarStatus(InquiryPLNPrabayarStatus.error);
      showMaterialModalBottomSheet(
        context: context, 
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        builder: (context) {
        return Container(
          height: 320.0,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0))
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LottieBuilder.asset("assets/lottie/error.json",
                width: 100.0,
                height: 100.0,
              ),
              Text("Ups! Maaf, nomor pelanggan salah / Sedang ada gangguan",
                style: TextStyle(
                  fontSize: Dimensions.fontSizeSmall
                ),
              )
            ],
          ),
        );
      });
    } catch(e) {
      debugPrint(e.toString());
    }
  } 


  Future<void> getListPricePLNPrabayar(context) async {
    try {
      setStateListPricePLNPrabayarStatus(ListPricePLNPrabayarStatus.loading);
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlPpob}/product/list?group=public_utility&category=PLN&type=prabayar");
      ListPricePraBayarModel listPricePraBayarModel = ListPricePraBayarModel.fromJson(res.data);
      _listPricePLNPrabayarData = [];
      List<ListPricePraBayarData> lpPpbd = listPricePraBayarModel.body!;
      _listPricePLNPrabayarData.addAll(lpPpbd);
      setStateListPricePLNPrabayarStatus(ListPricePLNPrabayarStatus.loaded);
      if(_listPricePLNPrabayarData.isEmpty) {
        setStateListPricePLNPrabayarStatus(ListPricePLNPrabayarStatus.empty);
      }
    } on DioError catch(_) { 
      setStateListPricePLNPrabayarStatus(ListPricePLNPrabayarStatus.error);
    } catch(e) {
      debugPrint(e.toString());
    }
  } 

  Future<void> getListEmoney(BuildContext context, String category) async {
    try {
      setStateListTopUpEmoneyStatus(ListTopUpEmoneyStatus.loading);
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlPpob}/product/list?group=emoney&category=$category&type=credit");
      _listTopUpEmoney = [];
      ListProductDenomModel lpdm = ListProductDenomModel.fromJson(res.data);
      _listTopUpEmoney.addAll(lpdm.body!);
      setStateListTopUpEmoneyStatus(ListTopUpEmoneyStatus.loaded);
      if(_listTopUpEmoney.isEmpty) {
        setStateListTopUpEmoneyStatus(ListTopUpEmoneyStatus.empty);
      }
    } on DioError catch(_) {
      setStateListTopUpEmoneyStatus(ListTopUpEmoneyStatus.error);
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getVoucherPulsaByPrefix(BuildContext context, int prefix) async {
    try {
      setStateListVoucherPulsaByPrefixStatus(ListVoucherPulsaByPrefixStatus.loading);
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlPpob}/product/list?group=voucher&category=$prefix&type=pulsa");
      ListProductDenomModel listVoucherPulsaByPrefixModel = ListProductDenomModel.fromJson(res.data);
      _listVoucherPulsaByPrefixData = [];
      List<ListProductDenomData> listVoucherPulsaByPrefixData = listVoucherPulsaByPrefixModel.body!;
      _listVoucherPulsaByPrefixData.addAll(listVoucherPulsaByPrefixData);
      setStateListVoucherPulsaByPrefixStatus(ListVoucherPulsaByPrefixStatus.loaded);
      if(_listVoucherPulsaByPrefixData.isEmpty) {
        setStateListVoucherPulsaByPrefixStatus(ListVoucherPulsaByPrefixStatus.empty);
      } 
    } on DioError catch(_) {
      setStateListVoucherPulsaByPrefixStatus(ListVoucherPulsaByPrefixStatus.error);
    } catch(e) {
      debugPrint(e.toString());
    }
  } 

  Future<void> getVA(context) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get(AppConstants.baseUrlVa);
      VAModel pilihPembayaranModel = VAModel.fromJson(res.data);
      _listVa = [];
      List<VAData> vaData = pilihPembayaranModel.body!;
      _listVa.addAll(vaData);
      setStateVAStatus(VaStatus.loaded);
      if(_listVa.isEmpty) {
        setStateVAStatus(VaStatus.empty);
      }
    } on DioError catch(_) {  
      setStateVAStatus(VaStatus.error);
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getBalance(BuildContext context) async {
    try {
      setStateBalanceStatus(BalanceStatus.loading);
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlPpob}/wallet/balance");
      BalanceModel balanceModel = BalanceModel.fromJson(res.data);
      balance = balanceModel.body?.balance;
      setStateBalanceStatus(BalanceStatus.loaded);
    } on DioError catch(_) {
      setStateBalanceStatus(BalanceStatus.error);
    } catch(e) {
      setStateBalanceStatus(BalanceStatus.error);
      debugPrint(e.toString());
    }
  }

  Future<void> getHistoryBalance(BuildContext context, String startDate, String endDate) async {
    try {
      setStateHistoryBalanceStatus(HistoryBalanceStatus.loading);
      Dio dio = await DioManager.shared.getClient(context);
      FormData formData = FormData.fromMap({
        "start": startDate,
        "end": endDate,
        "sort": "created,desc"
      });
      Response res = await dio.post("${AppConstants.baseUrlPpob}/wallet/history", data: formData);
      _historyBalanceData = [];
      HistoryBalanceModel historyBalanceModel = HistoryBalanceModel.fromJson(res.data);
      List<HistoryBalanceData> historyBalanceData = historyBalanceModel.body!;
      _historyBalanceData.addAll(historyBalanceData);
      setStateHistoryBalanceStatus(HistoryBalanceStatus.loaded);
      if(_historyBalanceData.isEmpty) {
        setStateHistoryBalanceStatus(HistoryBalanceStatus.empty);
      }
    } on DioError catch(_) {
      setStateHistoryBalanceStatus(HistoryBalanceStatus.error);
    } catch(e) {
      setStateHistoryBalanceStatus(HistoryBalanceStatus.error);
      debugPrint(e.toString()); 
    }
  }

  Future<void> getDenomDisbursement(BuildContext context)  async {
    setStateDenomDisbursementStatus(DenomDisbursementStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get(AppConstants.baseUrlDisbursementDenom);
      DenomDisbursementModel denomDisbursementModel = DenomDisbursementModel.fromJson(res.data);
      _denomDisbursement = [];
      List<DenomDisbursementBody> denomDisbursement = denomDisbursementModel.body!;
      _denomDisbursement.addAll(denomDisbursement);
      setStateDenomDisbursementStatus(DenomDisbursementStatus.loaded);
      if(denomDisbursement.isEmpty) {
        setStateDenomDisbursementStatus(DenomDisbursementStatus.empty);
      } 
    } on DioError catch(e) {
      setStateDenomDisbursementStatus(DenomDisbursementStatus.error);
      debugPrint(e.response?.statusCode.toString());
      debugPrint(e.response?.data);
    } catch(e) {
      setStateDenomDisbursementStatus(DenomDisbursementStatus.error);
      debugPrint(e.toString());
    }
  }

  Future<void> getBankDisbursement(BuildContext context) async {
    setStateBankDisbursementStatus(BankDisbursementStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get(AppConstants.baseUrlDisbursementBank);
      BankDisbursementModel bankDisbursementModel = BankDisbursementModel.fromJson(res.data);
      _bankDisbursement = [];
      List<BankDisbursementBody> listBankDisbursement = bankDisbursementModel.body!;
      _bankDisbursement.addAll(listBankDisbursement);
      setStateBankDisbursementStatus(BankDisbursementStatus.loaded);
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getEmoneyDisbursement(BuildContext context) async {
    setStateEmoneyDisbursementStatus(EmoneyDisbursementStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get(AppConstants.baseUrlDisbursementEmoney);
      EmoneyDisbursementModel emoneyDisbursementModel = EmoneyDisbursementModel.fromJson(res.data);
      _emoneyDisbursement = [];
      List<EmoneyDisbursementBody> listEmoneyDisbursement = emoneyDisbursementModel.body!;
      _emoneyDisbursement.addAll(listEmoneyDisbursement);
      setStateEmoneyDisbursementStatus(EmoneyDisbursementStatus.loaded);
      Future.delayed(Duration.zero, () => notifyListeners());
    } on DioError catch(e) {
      debugPrint(e.response!.statusCode.toString());
      debugPrint(e.response?.data);
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  Future<void> inquiryDisbursement(BuildContext context, int amount, int price) async {
    setStateDisbursementStatus(InquiryDisbursementStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.baseUrlDisbursement}/disbursement/inquiry", data: {
        "amount": amount
      });
      InquiryDisbursementModel inquiryDisbursementModel = InquiryDisbursementModel.fromJson(res.data);
      InquiryDisbursementBody idb = inquiryDisbursementModel.body!;
      Navigator.push(context, MaterialPageRoute(builder: (context) => CashOutInformationScreen(
        adminFee: idb.totalAdminFee, 
        totalDeduction: price,
        token: idb.token,
      )));
      setStateDisbursementStatus(InquiryDisbursementStatus.loaded);
    } on DioError catch(e) {
      debugPrint(e.response?.statusCode.toString());
      debugPrint(e.response?.data);
      setStateDisbursementStatus(InquiryDisbursementStatus.error);
      if(e.response?.statusCode == 400) {
        Fluttertoast.showToast(
          msg: "Insufficient wallet funds. Your Balance : ${Helper.formatCurrency(double.parse(balance.toString()))}",
          backgroundColor: ColorResources.error,
          toastLength: Toast.LENGTH_LONG,
          textColor: ColorResources.white
        );
      }
      if(e.response?.data["code"] == 411) {
        Fluttertoast.showToast(
          msg: "Insufficient wallet funds. Your Balance : ${Helper.formatCurrency(double.parse(balance.toString()))}",
          backgroundColor: ColorResources.error,
          toastLength: Toast.LENGTH_LONG,
          textColor: ColorResources.white
        );
      } else {
        Fluttertoast.showToast(
          msg: getTranslated("THERE_WAS_PROBLEM", context),
          backgroundColor: ColorResources.error,
          toastLength: Toast.LENGTH_LONG,
          textColor: ColorResources.white
        );
      }
    } catch(e) {
      setStateDisbursementStatus(InquiryDisbursementStatus.error);
      debugPrint(e.toString());
    }
  }

  Future<void> submitDisbursement(BuildContext context, String token) async {
    setStateSubmitDisbursementStatus(SubmitDisbursementStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.baseUrlDisbursement}/disbursement/submit", data: {
        "destAccount": getGlobalPaymentAccount,
        "destBank": getGlobalPaymentMethodCode
      }, options: Options(
        headers: {
          "x-request-token": token
        }
      ));
      setStateSubmitDisbursementStatus(SubmitDisbursementStatus.loaded);
      Navigator.push(context, MaterialPageRoute(builder: (ctx) => const CashOutSuccessScreen()));
    } on DioError catch(e) {
      debugPrint(e.response?.statusCode.toString());
      debugPrint(e.response?.data);
      setStateSubmitDisbursementStatus(SubmitDisbursementStatus.error);
      if(e.response?.statusCode == 400) {
        setStateSubmitDisbursementStatus(SubmitDisbursementStatus.error);
      }
      if(e.response?.data["code"] == 411) {
        throw CustomException(e.response?.data["message"]);
      } else {
        throw CustomException(e.response?.data["message"]);
      }
    } catch(e) {
      setStateSubmitDisbursementStatus(SubmitDisbursementStatus.error);
      debugPrint(e.toString());
    } 
  }
    
}
