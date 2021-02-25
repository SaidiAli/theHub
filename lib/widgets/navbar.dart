import 'package:flutter/material.dart';
import '../constants/Theme.dart';

class Navbar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String categoryOne;
  final String categoryTwo;
  final bool searchBar;
  final bool backButton;
  final bool transparent;
  final bool rightOptions;
  final List<String> tags;
  final Function getCurrentPage;
  final bool isOnSearch;
  final TextEditingController searchController;
  final Function searchOnChanged;
  final bool searchAutofocus;
  final bool noShadow;
  final Color bgColor;

  Navbar(
      {this.title = "Home",
      this.categoryOne = "",
      this.categoryTwo = "",
      this.tags,
      this.transparent = false,
      this.rightOptions = true,
      this.getCurrentPage,
      this.searchController,
      this.isOnSearch = false,
      this.searchOnChanged,
      this.searchAutofocus = false,
      this.backButton = false,
      this.noShadow = false,
      this.bgColor = ArgonColors.white,
      this.searchBar = false});

  final double _prefferedHeight = 180.0;

  @override
  _NavbarState createState() => _NavbarState();

  @override
  Size get preferredSize => Size.fromHeight(_prefferedHeight);
}

class _NavbarState extends State<Navbar> {
  String activeTag;

  void initState() {
    if (widget.tags != null && widget.tags.length != 0) {
      activeTag = widget.tags[0];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool categories =
        widget.categoryOne.isNotEmpty && widget.categoryTwo.isNotEmpty;
    final bool tagsExist =
        widget.tags == null ? false : (widget.tags.length == 0 ? false : true);

    return Container(
        height: widget.searchBar
            ? (!categories
                ? (tagsExist ? 211.0 : 178.0)
                : (tagsExist ? 262.0 : 210.0))
            : (!categories
                ? (tagsExist ? 162.0 : 102.0)
                : (tagsExist ? 200.0 : 150.0)),
        decoration: BoxDecoration(
            color: !widget.transparent ? widget.bgColor : Colors.transparent,
            boxShadow: [
              BoxShadow(
                  color: !widget.transparent && !widget.noShadow
                      ? ArgonColors.initial
                      : Colors.transparent,
                  spreadRadius: -10,
                  blurRadius: 12,
                  offset: Offset(0, 5))
            ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            icon: Icon(
                                !widget.backButton
                                    ? Icons.menu
                                    : Icons.arrow_back_ios,
                                color: !widget.transparent
                                    ? (widget.bgColor == ArgonColors.white
                                        ? ArgonColors.initial
                                        : ArgonColors.white)
                                    : ArgonColors.white,
                                size: 24.0),
                            onPressed: () {
                              if (!widget.backButton)
                                Scaffold.of(context).openDrawer();
                              else
                                Navigator.pop(context);
                            }),
                        Text(widget.title,
                            style: TextStyle(
                                color: !widget.transparent
                                    ? (widget.bgColor == ArgonColors.white
                                        ? ArgonColors.initial
                                        : ArgonColors.white)
                                    : ArgonColors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18.0)),
                      ],
                    ),
                    if (widget.rightOptions)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/pro');
                            },
                            child: IconButton(
                                icon: Icon(Icons.notifications_active,
                                    color: !widget.transparent
                                        ? (widget.bgColor == ArgonColors.white
                                            ? ArgonColors.initial
                                            : ArgonColors.white)
                                        : ArgonColors.white,
                                    size: 22.0),
                                onPressed: null),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/pro');
                            },
                            child: IconButton(
                                icon: Icon(Icons.shopping_basket,
                                    color: !widget.transparent
                                        ? (widget.bgColor == ArgonColors.white
                                            ? ArgonColors.initial
                                            : ArgonColors.white)
                                        : ArgonColors.white,
                                    size: 22.0),
                                onPressed: null),
                          ),
                        ],
                      )
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                if (categories)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/pro');
                        },
                        child: Row(
                          children: [
                            Icon(Icons.camera,
                                color: ArgonColors.initial, size: 22.0),
                            SizedBox(width: 10),
                            Text(widget.categoryOne,
                                style: TextStyle(
                                    color: ArgonColors.initial,
                                    fontSize: 16.0)),
                          ],
                        ),
                      ),
                      SizedBox(width: 30),
                      Container(
                        color: ArgonColors.initial,
                        height: 25,
                        width: 1,
                      ),
                      SizedBox(width: 30),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/pro');
                        },
                        child: Row(
                          children: [
                            Icon(Icons.shopping_cart,
                                color: ArgonColors.initial, size: 22.0),
                            SizedBox(width: 10),
                            Text(widget.categoryTwo,
                                style: TextStyle(
                                    color: ArgonColors.initial,
                                    fontSize: 16.0)),
                          ],
                        ),
                      )
                    ],
                  ),
              ],
            ),
          ),
        ));
  }
}
