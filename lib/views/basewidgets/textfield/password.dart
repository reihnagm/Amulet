import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/utils/dimensions.dart';
import 'package:flutter/material.dart';


class CustomPasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final FocusNode focusNode;
  final FocusNode? nextNode;
  final int maxLength;
  final TextInputAction? textInputAction;
  final Color counterTextColor;
  final bool isBorder;
  final bool isBorderRadius;
  final bool isIcon;

  const CustomPasswordTextField({
    Key? key, 
    required this.controller,
    required this.focusNode,
    this.hintText = "",
    this.nextNode,
    this.maxLength = 8,
    this.textInputAction,
    this.counterTextColor = ColorResources.grey,
    this.isBorder = true,
    this.isBorderRadius = false,
    this.isIcon = true
  }) : super(key: key);

  @override
  _CustomPasswordFieldState createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordTextField> {
  bool obscureText = true;

  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        TextFormField(
          controller: widget.controller,
          obscureText: obscureText,
          focusNode: widget.focusNode,
          style: TextStyle(
            fontSize: Dimensions.fontSizeSmall,
          ),
          maxLength: widget.maxLength,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: (v) {
            setState(() {
              widget.textInputAction == TextInputAction.done
              ? FocusScope.of(context).consumeKeyboardToken()
              : FocusScope.of(context).requestFocus(widget.nextNode);
            });
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                obscureText 
                ? Icons.visibility_off 
                : Icons.visibility,color: ColorResources.grey,
                size: 18.0,
              ),
              onPressed: toggle,
            ),
            hintText: widget.hintText,
            fillColor: ColorResources.white,
            filled: true,
            isDense: true,
            prefixIcon: widget.isIcon 
            ? const Icon(
                Icons.lock,
                color: ColorResources.secondaryV3Background,
              ) 
            : null,
            counterStyle: TextStyle(
              fontSize: Dimensions.fontSizeExtraSmall,
              color: widget.counterTextColor
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
            hintStyle: TextStyle(
              color: ColorResources.grey,
              fontSize: Dimensions.fontSizeSmall
            ),
            border: OutlineInputBorder(
              borderRadius: widget.isBorderRadius ? BorderRadius.circular(20.0) : BorderRadius.circular(0.0),
              borderSide: BorderSide(
                color: widget.isBorder ? ColorResources.gainsBoro : ColorResources.transparent
              )
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: widget.isBorderRadius ? BorderRadius.circular(20.0) : BorderRadius.circular(0.0),
              borderSide: BorderSide(
                color: widget.isBorder ? ColorResources.gainsBoro : ColorResources.transparent
              )
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: widget.isBorderRadius ? BorderRadius.circular(20.0) : BorderRadius.circular(0.0),
              borderSide: BorderSide(
                color: widget.isBorder ? ColorResources.gainsBoro : ColorResources.transparent
              )
            ),
          ),
        ),
      ],
    );
  }
}
