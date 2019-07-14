import 'package:flutter/material.dart';
import 'package:justcost/screens/ad.dart';
import 'package:justcost/screens/ad_contact_screen.dart';
import 'package:justcost/widget/rounded_edges_alert_dialog.dart';

class AdDetailsScreen extends StatefulWidget {
  final AdDetails adDetails;

  const AdDetailsScreen({Key key, this.adDetails}) : super(key: key);

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
    if (isEditMode()) {
      var adDetails = widget.adDetails;
      _adDetailsController.text = adDetails.description;
      _adKeywordController.text = adDetails.keyword;
      _adTitleController.text = adDetails.title;
    }
  }

  bool isEditMode() => widget.adDetails != null;

  bool isAtleastOneFieldNotEmpty() =>
      _adDetailsController.text.isNotEmpty ||
      _adKeywordController.text.isNotEmpty ||
      _adTitleController.text.isNotEmpty;

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
        body: WillPopScope(
          onWillPop: () async {
            if (isAtleastOneFieldNotEmpty()) {
              bool dismiss = await showDialog<bool>(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => RoundedAlertDialog(
                        title: Text('Discard data?'),
                        content: Text('Are you sure?'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Yes'),
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                          ),
                          FlatButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                          ),
                        ],
                      ));
              return Future.value(dismiss);
            } else
              return Future.value(true);
          },
          child: SingleChildScrollView(
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
                      return title.isEmpty
                          ? "Title field Can not be Empty"
                          : null;
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
                      return keyword.isEmpty
                          ? "Keyword field Can not be Empty"
                          : null;
                    },
                    maxLines: 1,
                    controller: _adKeywordController,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            left: 16, right: 16, top: 10, bottom: 10),
                        border: InputBorder.none,
                        helperText: 'Keyword to make your Ad easier to search',
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
                      if (text.isEmpty) return "Details field can not be empty";
                      return null;
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
                      child: Hero(
                        tag: "addad",
                        child: RaisedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              var title = _adTitleController.value.text;
                              var keyword = _adKeywordController.value.text;
                              var description = _adDetailsController.value.text;
                              var adDetails = AdDetails(
                                  title: title,
                                  keyword: keyword,
                                  description: description);
                              if (isEditMode())
                                Navigator.pop(context, adDetails);
                              else
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute<Ad>(
                                        builder: (context) => AdContactScreen(
                                              adDetails: adDetails,
                                            )));
                            }
                          },
                          child: Text('Next'),
                        ),
                      ),
                    ),
                  )
                ],
              ),
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


