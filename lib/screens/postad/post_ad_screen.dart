import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:justcost/data/city/city_repository.dart';
import 'package:justcost/data/city/model/country.dart';
import 'package:justcost/i10n/app_localizations.dart';
import 'package:justcost/screens/login/login_screen.dart';
import 'package:justcost/screens/postad/ad.dart';
import 'package:justcost/screens/postad/add_ad_product_screen.dart';
import 'package:justcost/screens/postad/addition_type.dart';
import 'package:justcost/screens/postad/location_pick_screen.dart';
import 'package:justcost/screens/postad/post_ad_bloc.dart';
import 'package:justcost/widget/guest_user_widget.dart';
import 'package:justcost/widget/network_error_widget.dart';
import 'package:justcost/widget/product_dissmisable_widget.dart';
import 'package:justcost/widget/rounded_edges_alert_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../dependencies_provider.dart';

class PostAdScreen extends StatefulWidget {
  @override
  _PostAdScreenState createState() => _PostAdScreenState();
}

class _PostAdScreenState extends State<PostAdScreen> {
  int _currentStep = 0;
  AdBloc _bloc;
  GlobalKey<FormState> _detailsFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _contactFormKey = GlobalKey<FormState>();
  AdditionType additionType = AdditionType.single;
  FocusNode _adDetailsFocusNode = FocusNode();
  TextEditingController _adTitleController;
  TextEditingController _adDetailsController;
  TextEditingController _adPhoneNumberController;
  TextEditingController _adEmailController;
  TextEditingController _adFacebookController;
  TextEditingController _adInstagramController;
  TextEditingController _adTwitterController;
  TextEditingController _adSnapchatController;
  LatLng location;
  FocusNode _adPhoneNumberFocusNode = FocusNode();
  FocusNode _adEmailFocusNode = FocusNode();
  List<Country> _countries = [];
  List<City> _cities = [];
  List<AdProduct> productList = [];
  Country _selectedCountry;
  City _selectedCity;
  String _countryCode;
  Pattern _pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex;
  StepState _firstStepState = StepState.editing;
  StepState _secondStepState = StepState.indexed;
  StepState _thirdStepState = StepState.indexed;
  StepState _fourthStepState = StepState.indexed;

  @override
  void initState() {
    super.initState();
    loadData();
    _bloc =
        AdBloc(DependenciesProvider.provide(), DependenciesProvider.provide());
    _bloc.dispatch(CheckUserType());
    _bloc.dispatch(CheckIfDraftExists());
    regex = new RegExp(_pattern);
    _adTitleController = TextEditingController();
    _adDetailsController = TextEditingController();
    _adPhoneNumberController = TextEditingController();

    _adEmailController = TextEditingController();
    _adInstagramController = TextEditingController();
    _adFacebookController = TextEditingController();
    _adSnapchatController = TextEditingController();
    _adTwitterController = TextEditingController();

  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
    _adTitleController.dispose();
    _adDetailsController.dispose();
    _adPhoneNumberController.dispose();
    _adEmailController.dispose();
    _adInstagramController.dispose();
    _adFacebookController.dispose();
    _adSnapchatController.dispose();
    _adTwitterController.dispose();
  }

  void loadData() async {
    CityRepository repository = DependenciesProvider.provide();
    var countriesData = await repository.getCountries();
    this._countries = countriesData.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).postAd),
      ),
      body: SafeArea(
          child: BlocListener(
        bloc: _bloc,
        child: BlocBuilder(
          bloc: _bloc,
          builder: (BuildContext context, AdState state) {
            if (state is SuccessState)
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 80,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      AppLocalizations.of(context).adSubmitSuccessTitle,
                      style: Theme.of(context).textTheme.title,
                    ),
                    Text(AppLocalizations.of(context).adSubmitSuccessMessage),
                    const SizedBox(
                      height: 8,
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child:
                          Text(MaterialLocalizations.of(context).okButtonLabel),
                    )
                  ],
                ),
              );
            if (state is NetworkErrorState ||
                state is ErrorState ||
                state is PostAdFailed) {
              return Center(
                child: NetworkErrorWidget(
                  onRetry: () {
                    _bloc.dispatch(PostAdEvent(
                        AdDetails(
                            title: _adTitleController.text,
                            description: _adDetailsController.text),
                        AdContact(
                            phoneNumber: _adPhoneNumberController.text,
                            location: location,
                            city: _selectedCity,
                            country: _selectedCountry,
                            email: _adEmailController.text,
                            facebookAccount: _adFacebookController.text,
                            instagramAccount: _adInstagramController.text),
                        productList,
                        additionType == AdditionType.multiple));
                  },
                ),
              );
            }
            if (state is GoatUserState)
              return Center(
                child: GuestUserWidget(),
              );
            if (state is PostProductsFailed) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(AppLocalizations.of(context).adFailedMessage),
                    SizedBox(
                      height: 8,
                    ),
                    RaisedButton(
                      onPressed: () {
                        _bloc.dispatch(RetryPostProduct(
                            productList, state.adId, state.isWholeSale));
                      },
                      child: Text(AppLocalizations.of(context).retryButton),
                    )
                  ],
                ),
              );
            }
            if (state is LoadingState)
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Text(
                        '${state.loading == Loading.ad ? AppLocalizations.of(context).postAdLoading : AppLocalizations.of(context).postProductsLoading}')
                  ],
                ),
              );

            return buildFormStepper(context);
          },
        ),
        listener: (BuildContext context, AdState state) {
          if (state is SessionExpiredState) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) =>
                    LoginScreen(NavigationReason.session_expired)));
          }
          if (state is DraftLoaded) {}
        },
      )),
    );
  }

  bool _canPop() {
    return _adTitleController.text.isEmpty &&
        _adDetailsController.text.isEmpty &&
        _adPhoneNumberController.text.isEmpty &&
        _adEmailController.text.isEmpty &&
        _adFacebookController.text.isEmpty &&
        _adInstagramController.text.isEmpty;
  }

  buildFormStepper(BuildContext context) {
    var hintStyle =
        Theme.of(context).textTheme.body1.copyWith(color: Colors.grey);
    return WillPopScope(
      onWillPop: () async {
        if (_canPop()) {
          return Future.value(true);
        } else {
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
                      /*FlatButton(
                        onPressed: () {
                          _bloc.dispatch(SavePostAsDraft(
                              AdDetails(
                                  title: _adTitleController.text,
                                  description: _adDetailsController.text),
                              AdContact(
                                  phoneNumber: _adPhoneNumberController.text,
                                  location: location,
                                  city: _selectedCity,
                                  country: _selectedCountry,
                                  email: _adEmailController.text,
                                  facebookPage: _adFacebookController.text,
                                  instagramPage: _adInstagramController.text),
                              productList,
                              additionType == AdditionType.multiple));
                        },
                        child: Text(AppLocalizations.of(context).saveAsDraft),
                        textColor: Colors.blue,
                      ),*/
                      FlatButton(
                        textColor: Colors.red,
                        child: Text(MaterialLocalizations.of(context)
                            .cancelButtonLabel),
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                      ),
                    ],
                  ));
          return Future.value(dismiss);
        }
      },
      child: Stepper(
        controlsBuilder: (BuildContext context,
            {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
          return Row(
            children: <Widget>[
              FlatButton(
                onPressed: onStepContinue,
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                textTheme: ButtonTextTheme.normal,
                child:
                    Text(MaterialLocalizations.of(context).continueButtonLabel),
              ),
              Container(
                margin: const EdgeInsetsDirectional.only(start: 8.0),
                child: FlatButton(
                  onPressed: onStepCancel,
                  textColor: Colors.black54,
                  textTheme: ButtonTextTheme.normal,
                  child:
                      Text(MaterialLocalizations.of(context).backButtonTooltip),
                ),
              ),
            ],
          );
        },
        currentStep: _currentStep,
        steps: [
          Step(
            state: _firstStepState,
            title: Text(AppLocalizations.of(context).selectAdType),
            content: RadioLikeButton(
              onNormalSelected: () {
                if (additionType == AdditionType.single) return;
                productList.clear();
                additionType = AdditionType.single;
              },
              onWholesaleSelected: () {
                if (additionType == AdditionType.multiple) return;
                productList.clear();
                additionType = AdditionType.multiple;
              },
            ),
            isActive: _currentStep == 0,
          ),
          Step(
              state: _secondStepState,
              isActive: _currentStep == 1,
              title: Text(AppLocalizations.of(context).adDetailsTitle),
              content: Form(
                key: _detailsFormKey,
                child: Column(
                  children: <Widget>[
                    Card(
                      child: TextFormField(
                        controller: _adTitleController,
                        textInputAction: TextInputAction.next,
                        validator: (title) {
                          return title.isEmpty
                              ? AppLocalizations.of(context).titleEmptyError
                              : null;
                        },
                        onEditingComplete: () {
                          FocusScope.of(context)
                              .requestFocus(_adDetailsFocusNode);
                        },
                        maxLines: 1,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(
                              left: 16, right: 16, top: 10, bottom: 10),
                          hintText: AppLocalizations.of(context).adTitleHint,
                          labelText: AppLocalizations.of(context).adTitleLabel,
                        ),
                      ),
                    ),
                    Card(
                      child: TextFormField(
                        controller: _adDetailsController,
                        focusNode: _adDetailsFocusNode,
                        keyboardType: TextInputType.text,
                        maxLines: 3,
                        validator: (text) {
                          if (text.isEmpty)
                            return AppLocalizations.of(context)
                                .detailsEmptyError;
                          return null;
                        },
                        maxLengthEnforced: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(
                              left: 16, right: 16, top: 10, bottom: 10),
                          hintText:
                              AppLocalizations.of(context).adDescriptionHint,
                          labelText:
                              AppLocalizations.of(context).adDescriptionLabel,
                          alignLabelWithHint: true,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          Step(
              state: _thirdStepState,
              isActive: _currentStep == 2,
              title: Text(AppLocalizations.of(context).adContactNLocation),
              content: Form(
                  key: _contactFormKey,
                  child: Column(
                    children: <Widget>[
                      Card(
                        child: DropdownButtonFormField<Country>(
                          value: _selectedCountry,
                          onChanged: (country) {
                            setState(() {
                              _selectedCity = null;
                              _countryCode = null;
                              _selectedCountry = country;
                              _cities = country.cities;
                              _countryCode = country.code;
                              _adPhoneNumberController.text = _countryCode;
                            });
                          },
                          validator: (country) {
                            if (country == null)
                              return AppLocalizations.of(context)
                                  .countryEmptyError;
                            else
                              return null;
                          },
                          decoration: InputDecoration.collapsed(
                                  hintText:
                                      AppLocalizations.of(context).country)
                              .copyWith(
                                  contentPadding: const EdgeInsets.only(
                                      left: 16,
                                      right: 16,
                                      top: 10,
                                      bottom: 10)),
                          items: _countries
                              .map((country) => DropdownMenuItem<Country>(
                                    child: Text(country.name),
                                    value: country,
                                    key: ObjectKey(country.id),
                                  ))
                              .toList(),
                        ),
                      ),
                      Card(
                        child: DropdownButtonFormField<City>(
                          onChanged: (city) {
                            setState(() {
                              this._selectedCity = city;
                            });
                          },
                          validator: (city) {
                            if (city == null)
                              return AppLocalizations.of(context)
                                  .cityEmptyError;
                            else
                              return null;
                          },
                          decoration: InputDecoration.collapsed(
                                  hintText: AppLocalizations.of(context).city)
                              .copyWith(
                                  contentPadding: const EdgeInsets.only(
                                      left: 16,
                                      right: 16,
                                      top: 10,
                                      bottom: 10)),
                          value: _selectedCity,
                          items: _cities
                              .map((city) => DropdownMenuItem<City>(
                                    child: Text(city.name),
                                    value: city,
                                    key: ObjectKey(city.id),
                                  ))
                              .toList(),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          dense: true,
                          onTap: _onLocationPickerClicked,
                          trailing: IconButton(
                              icon: Icon(Icons.place),
                              onPressed: _onLocationPickerClicked),
                          title: Text(
                            AppLocalizations.of(context).location,
                            style: Theme.of(context).textTheme.body1,
                          ),
                          subtitle: Text(
                              location != null
                                  ? AppLocalizations.of(context)
                                      .locationSelected
                                  : AppLocalizations.of(context)
                                      .locationEmptyError,
                              style: TextStyle(
                                  color: location != null
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Card(
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () {
                            FocusScope.of(context)
                                .requestFocus(_adEmailFocusNode);
                          },
                          validator: (phoneNumber) {
                            return phoneNumber.isEmpty
                                ? AppLocalizations.of(context)
                                    .phoneNumberEmptyError
                                : null;
                          },
                          maxLines: 1,
                          textDirection: TextDirection.ltr,
                          focusNode: _adPhoneNumberFocusNode,
                          controller: _adPhoneNumberController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 10, bottom: 10),
                              labelText:
                                  AppLocalizations.of(context).phoneNumberField,
                              hintText:
                                  AppLocalizations.of(context).phoneNumberHint,
                              hintStyle: hintStyle),
                        ),
                      ),
                      Card(
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () {},
                          validator: (mail) {
                            if (mail.isEmpty)
                              return AppLocalizations.of(context)
                                  .emailFieldEmptyError;
                            else if (!regex.hasMatch(mail))
                              return AppLocalizations.of(context)
                                  .emailFieldInvalidError;
                            else
                              return null;
                          },
                          controller: _adEmailController,
                          maxLines: 1,
                          focusNode: _adEmailFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 10, bottom: 10),
                              labelText:
                                  AppLocalizations.of(context).emailFieldLabel,
                              hintText:
                                  AppLocalizations.of(context).emailFieldHint,
                              hintStyle: hintStyle),
                        ),
                      ),
                     /* Card(
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () {},
                          controller: _adFacebookController,
                          maxLines: 1,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 10, bottom: 10),
                              prefixIcon: Icon(FontAwesomeIcons.facebookF),
                              labelText:
                                  AppLocalizations.of(context).facebookAccount,
                              hintStyle: hintStyle),
                        ),
                      ),
                      Card(
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () {},
                          maxLines: 1,
                          controller: _adInstagramController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(FontAwesomeIcons.instagram),
                              contentPadding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 10, bottom: 10),
                              labelText:
                                  AppLocalizations.of(context).instagramAccount,
                              hintStyle: hintStyle),
                        ),
                      ),
                      Card(
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () {},
                          maxLines: 1,
                          controller: _adTwitterController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(FontAwesomeIcons.twitter),
                              contentPadding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 10, bottom: 10),
                              labelText:
                                  AppLocalizations.of(context).twitterAccount,
                              hintStyle: hintStyle),
                        ),
                      ),
                      Card(
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () {},
                          maxLines: 1,
                          controller: _adSnapchatController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(FontAwesomeIcons.snapchat),
                              contentPadding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 10, bottom: 10),
                              labelText:
                                  AppLocalizations.of(context).snapChatAccount,
                              hintStyle: hintStyle),
                        ),
                      ),*/
                    ],
                  ))),
          Step(
            subtitle: Text(
                '${additionType == AdditionType.multiple ? AppLocalizations.of(context).wholesaleAdType : AppLocalizations.of(context).normalAdType}'),
            state: _fourthStepState,
            title: Text(AppLocalizations.of(context).adProducts),
            content: Column(
              children: <Widget>[
                additionType == AdditionType.single && productList.length == 1
                    ? Container()
                    : RaisedButton(
                        onPressed: () async {
                          var product = await Navigator.of(context)
                              .push(MaterialPageRoute<AdProduct>(
                                  builder: (context) => AddAdProductScreen(
                                        additionType: additionType,
                                      )));
                          if (product != null)
                            setState(() {
                              productList.add(product);
                            });
                        },
                        child: Text(AppLocalizations.of(context).addProduct),
                      ),
                ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemBuilder: (BuildContext context, int index) {
                    return new ProductDismissibleWidget(
                      adProduct: productList[index],
                      onDelete: () {
                        productList.removeAt(index);
                        setState(() {});
                      },
                      onEdit: () async {
                        var adProduct = await Navigator.push(
                            context,
                            MaterialPageRoute<AdProduct>(
                                builder: (context) => AddAdProductScreen(
                                      additionType: additionType,
                                      adProduct: productList[index],
                                    )));
                        if (adProduct != null)
                          setState(() {
                            productList.removeAt(index);
                            productList.insert(index, adProduct);
                          });
                      },
                    );
                  },
                  itemCount: productList.length,
                )
              ],
            ),
          )
        ],
        type: StepperType.vertical,
        onStepContinue: () {
          FocusScope.of(context).requestFocus(FocusNode());
          print(_currentStep);
          if (_currentStep == 0) {
            _firstStepState = StepState.complete;
            _secondStepState = StepState.editing;
            _goToNextStep();
          } else if (_currentStep == 1) {
            if (_detailsFormKey.currentState.validate()) {
              _secondStepState = StepState.complete;
              _firstStepState = StepState.complete;

              _thirdStepState = StepState.editing;
              _goToNextStep();
            } else {
              setState(() {
                _secondStepState = StepState.error;
              });
            }
          } else if (_currentStep == 2) {
            if (_contactFormKey.currentState.validate() && location != null) {
              _fourthStepState = StepState.editing;
              _thirdStepState = StepState.complete;
              _secondStepState = StepState.complete;
              _firstStepState = StepState.complete;

              _goToNextStep();
            } else {
              setState(() {
                _thirdStepState = StepState.error;
              });
            }
          } else if (_currentStep == 3) {
            if (productList.isNotEmpty &&
                _contactFormKey.currentState.validate() &&
                _detailsFormKey.currentState.validate()) {
              _fourthStepState = StepState.complete;
              _thirdStepState = StepState.complete;
              _secondStepState = StepState.complete;
              _firstStepState = StepState.complete;
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => RoundedAlertDialog(
                        content:
                            Text("${AppLocalizations.of(context).postAd}?"),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(AppLocalizations.of(context).adReview),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);

                              _bloc.dispatch(PostAdEvent(
                                  AdDetails(
                                      title: _adTitleController.text,
                                      description: _adDetailsController.text),
                                  AdContact(
                                      phoneNumber:
                                          _adPhoneNumberController.text,
                                      location: location,
                                      city: _selectedCity,
                                      country: _selectedCountry,
                                      email: _adEmailController.text,
                                      facebookAccount:
                                          _adFacebookController.text,
                                      twitterAccount: _adTwitterController.text,
                                      snapchatAccount:
                                          _adSnapchatController.text,
                                      instagramAccount:
                                          _adInstagramController.text),
                                  productList,
                                  additionType == AdditionType.multiple));
                            },
                            child:
                                Text(AppLocalizations.of(context).submitButton),
                          ),
                        ],
                      ));
            } else {
              if (!_detailsFormKey.currentState.validate())
                _secondStepState = StepState.error;
              if (!_contactFormKey.currentState.validate())
                _thirdStepState = StepState.error;
              if (productList.isEmpty) _fourthStepState = StepState.error;
            }
            setState(() {});
          }
        },
        onStepCancel: () {
          setState(() {
            if (_currentStep == 0) return;
            _currentStep -= 1;
            _changeStepStateAt(_currentStep);
          });
        },
        onStepTapped: (step) {
          setState(() {
            _currentStep = step;
            _changeStepStateAt(step);
          });
        },
      ),
    );
  }

  _changeStepStateAt(int step) {
    switch (step) {
      case 0:
        _firstStepState = StepState.editing;
        break;
      case 1:
        _secondStepState = StepState.editing;

        break;

      case 2:
        _thirdStepState = StepState.editing;

        break;
      case 3:
        _fourthStepState = StepState.editing;
        break;
    }
  }

  _goToNextStep() {
    setState(() {
      _currentStep += 1;
    });
  }

  Future _onLocationPickerClicked() async {
    var location = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LocationPickerScreen()));
    setState(() {
      this.location = location;
    });
  }
}

class RadioLikeButton extends StatefulWidget {
  final VoidCallback onWholesaleSelected;
  final VoidCallback onNormalSelected;
  final AdditionType additionType;

  const RadioLikeButton(
      {Key key,
      this.onWholesaleSelected,
      this.onNormalSelected,
      this.additionType})
      : super(key: key);

  @override
  _RadioLikeButtonState createState() => _RadioLikeButtonState();
}

class _RadioLikeButtonState extends State<RadioLikeButton> {
  AdditionType _additionType = AdditionType.single;

  @override
  void initState() {
    super.initState();
    if (widget.additionType != null) _additionType = widget.additionType;
  }

  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      children: <Widget>[
        RaisedButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const EdgeInsets.all(1),
          color: _additionType == AdditionType.single
              ? Theme.of(context).accentColor
              : Colors.grey,
          child: Text(AppLocalizations.of(context).normalAdType),
          onPressed: () {
            widget?.onNormalSelected();
            setState(() {
              _additionType = AdditionType.single;
            });
          },
        ),
        RaisedButton(
          padding: const EdgeInsets.all(1),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          color: _additionType == AdditionType.multiple
              ? Theme.of(context).accentColor
              : Colors.grey,
          child: Text(AppLocalizations.of(context).wholesaleAdType),
          onPressed: () {
            widget?.onWholesaleSelected();

            setState(() {
              _additionType = AdditionType.multiple;
            });
          },
        ),
      ],
      mainAxisSize: MainAxisSize.min,
      alignment: MainAxisAlignment.start,
    );
  }
}
