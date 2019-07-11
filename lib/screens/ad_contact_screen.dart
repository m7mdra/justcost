import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:justcost/data/city/city_repository.dart';
import 'package:justcost/data/city/model/country.dart';
import 'package:justcost/screens/ad.dart';
import 'package:justcost/screens/postad/location_pick_screen.dart';

import '../dependencies_provider.dart';
import 'ad_details_screen.dart';
import 'ad_media_screen.dart';

class AdContactScreen extends StatefulWidget {
  final AdDetails adDetails;
  final AdContact adContact;

  const AdContactScreen({Key key, this.adDetails, this.adContact})
      : super(key: key);

  @override
  _AdContactScreenState createState() => _AdContactScreenState();
}

class _AdContactScreenState extends State<AdContactScreen> {
  TextEditingController _adPhoneNumberController;
  TextEditingController _adEmailController;
  TextEditingController _adFacebookController;
  TextEditingController _adInstagramController;
  LatLng location;
  FocusNode _adPhoneNumberFocusNode = FocusNode();
  FocusNode _adEmailFocusNode = FocusNode();
  List<Country> _countries = [];
  List<City> _cities = [];
  Country _selectedCountry;
  City _selectedCity;
  String _countryCode;
  GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Pattern _pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex;

  bool isEditMode() => widget.adContact != null;

  @override
  void initState() {
    super.initState();
    loadData();
    regex = new RegExp(_pattern);
    _adPhoneNumberController = TextEditingController();
    _adEmailController = TextEditingController();
    _adInstagramController = TextEditingController();
    _adFacebookController = TextEditingController();
  }

  void loadData() async {
    CityRepository repository = DependenciesProvider.provide();
    var countriesData = await repository.getCountries();
    this._countries = countriesData.data;
    if (isEditMode()) {
      var adContact = widget.adContact;
      _countries.forEach((country) {
        if (country.id == adContact.country.id) {
          _selectedCountry = country;
          _cities = _selectedCountry.cities;
          _cities.forEach((city) {
            if (city.id == adContact.city.id) _selectedCity = city;
          });
        }
      });

      _countryCode = adContact.country.code;
      _adPhoneNumberController.text = "${adContact.phoneNumber}";
      _adEmailController.text = adContact.email;
      _adInstagramController.text = adContact.instagramPage;
      _adFacebookController.text = adContact.facebookPage;
      location = adContact.location;
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _adPhoneNumberController.dispose();
    _adEmailController.dispose();
    _adInstagramController.dispose();
    _adFacebookController.dispose();

    _adPhoneNumberFocusNode.dispose();
    _adEmailFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var hintStyle =
        Theme.of(context).textTheme.body1.copyWith(color: Colors.grey);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Ad Location & Conatct'),
      ),
      body: Form(
        key: _formKey,
        child: WillPopScope(
          onWillPop: () async {
/*            bool dismiss = await showDialog<bool>(
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
                    ));*/
            return Future.value(true);
          },
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                DropdownButtonFormField<Country>(
                  value: _selectedCountry,
                  onChanged: (country) {
                    setState(() {
                      _selectedCity = null;
                      _countryCode = null;
                      _selectedCountry = country;
                      _cities = country.cities;
                      _countryCode = country.code;
                    });
                  },
                  decoration: InputDecoration.collapsed(hintText: 'Country')
                      .copyWith(
                          contentPadding: const EdgeInsets.only(
                              left: 16, right: 16, top: 10, bottom: 10)),
                  items: _countries
                      .map((country) => DropdownMenuItem<Country>(
                            child: Text(country.name),
                            value: country,
                            key: ObjectKey(country.id),
                          ))
                      .toList(),
                ),
                divider(),
                DropdownButtonFormField<City>(
                  onChanged: (city) {
                    setState(() {
                      this._selectedCity = city;
                    });
                  },
                  decoration: InputDecoration.collapsed(hintText: 'City')
                      .copyWith(
                          contentPadding: const EdgeInsets.only(
                              left: 16, right: 16, top: 10, bottom: 10)),
                  value: _selectedCity,
                  items: _cities
                      .map((city) => DropdownMenuItem<City>(
                            child: Text(city.name),
                            value: city,
                            key: ObjectKey(city.id),
                          ))
                      .toList(),
                ),
                divider(),
                ListTile(
                  dense: true,
                  trailing: IconButton(
                      icon: Icon(Icons.place),
                      onPressed: _onLocationPickerClicked),
                  title: Text(
                    'Location',
                    style: Theme.of(context).textTheme.body1,
                  ),
                  subtitle: Text(location != null ? "Location Selected." : '',
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold)),
                ),
                divider(),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(_adEmailFocusNode);
                  },
                  validator: (phoneNumber) {
                    return phoneNumber.isEmpty
                        ? "Phone Number Can not be Empty"
                        : null;
                  },
                  maxLines: 1,
                  focusNode: _adPhoneNumberFocusNode,
                  controller: _adPhoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(
                          left: 16, right: 16, top: 10, bottom: 10),
                      labelText: 'Phone Number',
                      prefixText: '+$_countryCode',
                      hintText: 'Contact Phone Number',
                      hintStyle: hintStyle),
                ),
                divider(),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {},
                  validator: (mail) {
                    if (mail.isEmpty)
                      return "Email Field can not be empty";
                    else if (!regex.hasMatch(mail))
                      return "Invalid email address";
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
                      labelText: 'E-mail Address',
                      hintText: 'Contact Email Address',
                      hintStyle: hintStyle),
                ),
                divider(),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {},
                  controller: _adFacebookController,
                  maxLines: 1,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(
                          left: 16, right: 16, top: 10, bottom: 10),
                      labelText: 'Facebook Username',
                      prefixText: 'https://facebook.com/',
                      hintStyle: hintStyle),
                ),
                divider(),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {},
                  maxLines: 1,
                  controller: _adInstagramController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(
                          left: 16, right: 16, top: 10, bottom: 10),
                      labelText: 'Instagram Username',
                      prefixText: 'https://www.instagram.com/',
                      hintStyle: hintStyle),
                ),
                divider(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          if (location == null) {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text('Select the ad location.')));
                            return;
                          } else if (_selectedCountry == null) {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text('Select Country first')));
                            return;
                          } else if (_selectedCity == null) {
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(content: Text('Select City first.')));
                            return;
                          } else {
                            var phoneNumber =
                                _adPhoneNumberController.value.text;
                            var email = _adEmailController.value.text;
                            var facebookPage = _adFacebookController.value.text;
                            var instagramPage =
                                _adInstagramController.value.text;
                            var adContact = AdContact(
                                phoneNumber: phoneNumber,
                                location: location,
                                city: _selectedCity,
                                country: _selectedCountry,
                                instagramPage: instagramPage,
                                facebookPage: facebookPage,
                                email: email);
                            if (isEditMode())
                              Navigator.pop(context, adContact);
                            else
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute<Ad>(
                                      builder: (context) => AdMediaScreen(
                                            adDetails: widget.adDetails,
                                            adContact: adContact,
                                          )));
                          }
                        }
                      },
                      child: Text('Next'),
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

  Future _onLocationPickerClicked() async {
    var location = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LocationPickerScreen()));
    setState(() {
      this.location = location;
    });
  }

  Divider divider() {
    return const Divider(
      height: 1,
      indent: 1,
    );
  }
}

class AdContact {
  Country country;
  City city;
  LatLng location;
  String phoneNumber;
  String email;
  String facebookPage;
  String instagramPage;

  AdContact(
      {this.phoneNumber,
      this.location,
      this.city,
      this.country,
      this.email,
      this.facebookPage,
      this.instagramPage});

  @override
  String toString() {
    return 'AdContact{country: $country, city: $city, location: $location, phoneNumber: $phoneNumber, email: $email, facebookPage: $facebookPage, instagramPage: $instagramPage}';
  }
}
