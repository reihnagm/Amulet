import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:panic_button/utils/box_shadow.dart';

import 'package:panic_button/utils/color_resources.dart';
import 'package:panic_button/utils/dimensions.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({ Key? key }) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> mapsController = Completer();

  List<Map<String, dynamic>> categories = [
    {
      "id": 1,
      "name": "Kecelakaan",
      "image": "assets/images/accident.png"
    },
    {
      "id": 2,
      "name": "Pencurian",
      "image": "assets/images/rape.png"
    },
    {
      "id": 3,
      "name": "Kebakaran",
      "image": "assets/images/fire.png"
    },
    {
      "id": 4,
      "name": "Bencana Alam",
      "image": "assets/images/disaster.png"
    },
    {
      "id": 5,
      "name": "Perampokan",
      "image": "assets/images/thief.png"
    },
    {
      "id": 6,
      "name": "Kerusuhan",
      "image": "assets/images/noise.png"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: globalKey,
      drawer: const Drawer(),
      backgroundColor:ColorResources.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              fit: StackFit.expand,
              children: [

                RefreshIndicator(
                  backgroundColor: ColorResources.white,
                  color: ColorResources.redPrimary,
                  onRefresh: () {
                    return Future.sync(() {});
                  },
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    slivers: [
                      
                      SliverAppBar(
                        toolbarHeight: 80.0,
                        backgroundColor: ColorResources.transparent,
                        title: Image.asset('assets/images/logo.png',
                          width: 70.0,
                          height: 70.0,
                          fit: BoxFit.scaleDown,
                        ),
                        centerTitle: true,
                        iconTheme: const IconThemeData(
                          color: ColorResources.black
                        ),
                        leading: Container(
                          margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault),
                          child: InkWell(
                            onTap: () {
                              globalKey.currentState!.openDrawer();
                            },
                            child: const Icon(
                              Icons.menu,
                              color: ColorResources.black,
                            ),
                          )
                        ),
                        actions: [
                          Container(
                            margin: const EdgeInsets.only(right: Dimensions.marginSizeDefault),
                            child: const Icon(
                              Icons.notifications,
                              size: 25.0,
                              color: ColorResources.black,
                            ),
                          )
                        ],
                        bottom: PreferredSize(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault),
                                alignment: Alignment.centerLeft,
                                child: const Text("Hello",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Dimensions.fontSizeOverLarge
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Container(
                                margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault),
                                alignment: Alignment.centerLeft,
                                child: const Text("Edwin",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: Dimensions.fontSizeExtraLarge
                                  ),
                                ),
                              )
                            ],
                          ),
                          preferredSize: const Size.fromHeight(60.0) 
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: Container(
                          margin: const EdgeInsets.only(
                            top: 40.0, 
                            left: Dimensions.marginSizeDefault, 
                            right: Dimensions.marginSizeDefault
                          ),
                          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: ColorResources.white,
                            boxShadow: boxShadow
                          ),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 3 / 2,
                              crossAxisSpacing: 30,
                              mainAxisSpacing: 30,
                            ),
                            itemCount: categories.length,
                            itemBuilder: (BuildContext context, int i) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: ColorResources.backgroundCategory,
                                  boxShadow: boxShadow,
                                  borderRadius: BorderRadius.circular(20.0)
                                ),
                                child: Material(
                                  color: ColorResources.transparent,
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20.0),
                                    onTap: () {
                                      
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                           
                                          Container(
                                            alignment: Alignment.center,
                                            child: Image.asset(categories[i]["image"],
                                              width: 50.0,
                                              height: 50.0,
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                                                    
                                          Container(
                                            margin: const EdgeInsets.only(top: Dimensions.marginSizeDefault),
                                            alignment: Alignment.center,
                                            child: Text(categories[i]["name"].toString(),
                                              style: const TextStyle(
                                                fontSize: Dimensions.fontSizeDefault,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          )
                                                                    
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                             
                            }
                          ),
                        ),
                      )



                    ],
                  ),
                ),
              
              ],
            );
          },
        ),
      ),
    );
  }
}