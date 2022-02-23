import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amulet/localization/language_constraints.dart';
import 'package:amulet/utils/constant.dart';
import 'package:provider/provider.dart';

import 'package:amulet/utils/dimensions.dart';
import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/providers/localization.dart';

class LanguageDialog extends StatelessWidget {
  const LanguageDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    int index = Provider.of<LocalizationProvider>(context, listen: false).languageIndex;

    List<String> valueList = [];
    for (var language in AppConstants.languages) {
      valueList.add(language.languageName!);
    }
    
    return Dialog(
      backgroundColor: ColorResources.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Text(getTranslated('CHOOSE_LANGUAGE', context),
            style: const TextStyle(
              fontSize: Dimensions.fontSizeSmall
            )
          ),
        ),

        SizedBox(
          height: 150.0, 
          child: CupertinoPicker(
            itemExtent: 40.0,
            useMagnifier: true,
            magnification: 1.2,
            scrollController: FixedExtentScrollController(initialItem: index),
            onSelectedItemChanged: (int i) {
              index = i;
            },
            children: valueList.map((value) {
              return Center(
                child: Text(value, 
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color,
                    fontSize: Dimensions.fontSizeSmall
                  )
                )
              );
            }).toList(),
          )
        ),
        const Divider(
          height: Dimensions.paddingSizeExtraSmall, 
          color: ColorResources.hintColor
        ),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(getTranslated('CANCEL', context), 
                  style: const TextStyle(
                    color: ColorResources.black,
                    fontSize: Dimensions.fontSizeSmall
                  )
                ),
              )
            ),
            Container(
              height: 50.0,
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
              child: const VerticalDivider(
                color: ColorResources.grey,
                width: Dimensions.paddingSizeExtraSmall, 
              ),
            ),
            Expanded(
              child: TextButton(
              onPressed: () {
                Provider.of<LocalizationProvider>(context, listen: false).setLanguage(Locale(
                  AppConstants.languages[index].languageCode!,
                  AppConstants.languages[index].countryCode,
                ));
                Navigator.pop(context);
              },
              child: Text(getTranslated('OK', context), 
                style: const TextStyle(
                  color: ColorResources.black,
                  fontSize: Dimensions.fontSizeSmall
                )
              ),
            )
          ),
        ]),
      ]),
    );
  }
}