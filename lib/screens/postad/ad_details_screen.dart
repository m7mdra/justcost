import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/screens/postad/ad.dart';
import 'package:justcost/screens/postad/ad_contact_screen.dart';
import 'package:justcost/screens/postad/post_ad_bloc.dart';
import 'package:justcost/widget/guest_user_widget.dart';
import 'package:justcost/widget/rounded_edges_alert_dialog.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/i10n/app_localizations.dart';

class AdDetailsScreen extends StatefulWidget {
  final AdDetails adDetails;

  const AdDetailsScreen({Key key, this.adDetails}) : super(key: key);

  @override
  _AdDetailsScreenState createState() => _AdDetailsScreenState();
}

class _AdDetailsScreenState extends State<AdDetailsScreen> {
  TextEditingController _adTitleController;
  TextEditingController _adDetailsController;
  AdBloc _adBloc;
  FocusNode _adDetailsFocusNode = FocusNode();
  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _adBloc =
        AdBloc(DependenciesProvider.provide(), DependenciesProvider.provide());
    _adBloc.dispatch(CheckUserType());
    _adTitleController = TextEditingController();
    _adDetailsController = TextEditingController();
    if (isEditMode()) {
      var adDetails = widget.adDetails;
      _adDetailsController.text = adDetails.description;
      _adTitleController.text = adDetails.title;
    }
  }

  bool isEditMode() => widget.adDetails != null;

  bool isAtleastOneFieldNotEmpty() =>
      _adDetailsController.text.isNotEmpty ||
      _adTitleController.text.isNotEmpty;

  @override
  void dispose() {
    super.dispose();
    _adTitleController.dispose();
    _adDetailsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var hintStyle =
        Theme.of(context).textTheme.body1.copyWith(color: Colors.grey);
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).adDetailsTitle),
        ),
        body: BlocBuilder(
          bloc: _adBloc,
          builder: (BuildContext context, AdState state) {
            if (state is GoatUserState) {
              return Center(child: GuestUserWidget());
            }
            if (state is NormalUserState)
              return buildNormalState(context, hintStyle);
            return Container();
          },
        ));
  }

  buildNormalState(BuildContext context, TextStyle hintStyle) {
    return WillPopScope(
      onWillPop: () async {
        if (isAtleastOneFieldNotEmpty()) {
          bool dismiss = await showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (context) => RoundedAlertDialog(
                    title: Text(AppLocalizations.of(context).discardData),
                    content: Text(AppLocalizations.of(context).areYouSure),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(
                            MaterialLocalizations.of(context).okButtonLabel),
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                      ),
                      FlatButton(
                        child: Text(MaterialLocalizations.of(context)
                            .cancelButtonLabel),
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
              Card(
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  validator: (title) {
                    return title.isEmpty
                        ? AppLocalizations.of(context).titleEmptyError
                        : null;
                  },
                  maxLines: 1,
                  controller: _adTitleController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(
                          left: 16, right: 16, top: 10, bottom: 10),
                      hintText: AppLocalizations.of(context).adTitleHint,
                      labelText: AppLocalizations.of(context).adTitleLabel,
                      errorBorder: InputBorder.none,
                      hintStyle: hintStyle),
                ),
              ),
              Card(
                child: TextFormField(
                  focusNode: _adDetailsFocusNode,
                  controller: _adDetailsController,
                  keyboardType: TextInputType.text,
                  maxLines: 5,
                  validator: (text) {
                    if (text.isEmpty)
                      return AppLocalizations.of(context).detailsEmptyError;
                    return null;
                  },
                  maxLengthEnforced: true,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(
                          left: 16, right: 16, top: 10, bottom: 10),
                      hintText: AppLocalizations.of(context).adDescriptionHint,
                      labelText: AppLocalizations.of(context).adDescriptionLabel,
                      alignLabelWithHint: true,
                      hintStyle: hintStyle),
                ),
              ),
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
                          var description = _adDetailsController.value.text;
                          var adDetails =
                              AdDetails(title: title, description: description);
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
                      child: Text(AppLocalizations.of(context).nextButton),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Divider divider() {
    return const Divider(
      height: 1,
      indent: 1,
    );
  }
}
