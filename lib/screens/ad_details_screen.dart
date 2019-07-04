import 'package:flutter/material.dart';

import 'ad_contact_screen.dart';

class AdDetailsScreen extends StatefulWidget {
  @override
  _AdDetailsScreenState createState() => _AdDetailsScreenState();
}

class _AdDetailsScreenState extends State<AdDetailsScreen> {
  TextEditingController _adTitleController;
  TextEditingController _adKeywordController;
  TextEditingController _adDetailsController;

  FocusNode _adKeywordFocusNode = FocusNode();
  FocusNode _adDetailsFocusNode = FocusNode();
  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _adTitleController = TextEditingController();
    _adKeywordController = TextEditingController();
    _adDetailsController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _adTitleController.dispose();
    _adKeywordController.dispose();
    _adDetailsController.dispose();

    _adKeywordFocusNode.dispose();
    _adDetailsFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var hintStyle =
        Theme.of(context).textTheme.body1.copyWith(color: Colors.grey);
    return Scaffold(
        appBar: AppBar(
          title: Text('Ad Details'),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(_adKeywordFocusNode);
                  },
                  validator: (title) {
                    return title.isEmpty ? "Title field Can not be Empty" : null;
                  },
                  maxLines: 1,
                  controller: _adTitleController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(
                          left: 16, right: 16, top: 10, bottom: 10),
                      hintText: 'Add Title for your ad',
                      labelText: 'Ad Title',
                      errorBorder: InputBorder.none,
                      hintStyle: hintStyle),
                ),
                divider(),
                TextFormField(
                  focusNode: _adKeywordFocusNode,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(_adDetailsFocusNode);
                  },
                  validator: (keyword) {
                    return keyword.isEmpty ? "Keyword field Can not be Empty" : null;
                  },
                  maxLines: 1,
                  controller: _adKeywordController,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                          left: 16, right: 16, top: 10, bottom: 10),
                      border: InputBorder.none,
                      helperText: 'Keyword to make your ad easier to search',
                      labelText: 'Keyword',
                      hintStyle: hintStyle),
                ),
                divider(),
                TextFormField(
                  focusNode: _adDetailsFocusNode,
                  controller: _adDetailsController,
                  keyboardType: TextInputType.text,
                  maxLines: 5,
                  maxLength: 250,
                  validator: (text) {
                    if (text.isEmpty)
                      return "Details field can not be empty";
                    else if (text.length < 100)
                      return "Details must be more than 100 character";
                  },
                  maxLengthEnforced: true,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(
                          left: 16, right: 16, top: 10, bottom: 10),
                      hintText: 'Descripition of the Ad',
                      labelText: 'Ad Details',
                      alignLabelWithHint: true,
                      hintStyle: hintStyle),
                ),
                divider(),
                SizedBox(
                  height: 4,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: () {
                        //TODO: add validation
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AdContactScreen()));

                      },
                      child: Text('Next'),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Divider divider() {
    return const Divider(
      height: 1,
      indent: 1,
    );
  }
}
