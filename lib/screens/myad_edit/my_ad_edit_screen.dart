import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:justcost/data/ad/model/my_ads_response.dart';
import 'package:justcost/data/city/city_repository.dart';
import 'package:justcost/data/city/model/country.dart';
import 'package:justcost/data/product/model/product.dart';
import 'package:justcost/i10n/app_localizations.dart';
import 'package:justcost/screens/ad_details/ad_details_screen.dart';
import 'package:justcost/screens/login/login_screen.dart';
import 'package:justcost/screens/myad_edit/my_ads_edit_bloc.dart';
import 'package:justcost/screens/myads/my_ads_screen.dart';
import 'package:justcost/screens/postad/location_pick_screen.dart';
import 'package:justcost/widget/ad_tile.dart';
import 'package:justcost/widget/ad_widget.dart';
import 'package:justcost/widget/network_error_widget.dart';
import 'package:justcost/widget/no_data_widget.dart';

import '../../dependencies_provider.dart';

class MyAdEditScreen extends StatefulWidget {
  final Ad ad;

  MyAdEditScreen(this.ad,);

  @override
  _MyAdEditScreenState createState() => _MyAdEditScreenState();
}

class _MyAdEditScreenState extends State<MyAdEditScreen> {


  UpdateAdBloc _bloc;

  TextEditingController _adTitleController = new TextEditingController();
  TextEditingController _adDetailsController = new TextEditingController();
  TextEditingController _adPhoneNumberController = new TextEditingController();

  Country _selectedCountry;
  City _selectedCity;
  String _countryCode;
  List<Country> _countries = [];
  List<City> _cities = [];
  var latLng = [];

  void loadData() async {
    CityRepository repository = DependenciesProvider.provide();
    var countriesData = await repository.getCountries();
    this._countries = countriesData.data;
  }

  LatLng location;

  Future _onLocationPickerClicked(String lat , String lan) async {
    var location = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LocationPickerScreen(lat: lat,lan: lan,)));
    setState(() {
      this.location = location;
      print('Location Updated $location');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();

    _adTitleController.text = widget.ad.adTitle;
    _adDetailsController.text = widget.ad.adDescription;
    _adPhoneNumberController.text = widget.ad.mobile;

    _bloc =
        UpdateAdBloc(DependenciesProvider.provide(), DependenciesProvider.provide());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).editButton),
      actions: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 5),
            child: IconButton(icon: Icon(Icons.done_all,size: 25,color: Colors.white,), onPressed: (){
              _bloc.dispatch(UpdateAd(
                  adId: widget.ad.id,
                  adTitle: _adTitleController.text,
                  adDescription: _adDetailsController.text,
//                          adCityId: ,
                  adLongitude: location.longitude,
                  adLatitude: location.latitude,
                  adPhone:_adPhoneNumberController.text
              ));
            }))
      ],
      ),
      body:SafeArea(
          child: BlocListener(
            bloc: _bloc,
            child: BlocBuilder(
              bloc: _bloc,
              builder: (BuildContext context, UpdateAdState state) {
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
                          'تم تعديل الاعلان بنجاح',
//                          AppLocalizations.of(context).adSubmitSuccessTitle,
                          style: Theme.of(context).textTheme.title,
                        ),
//                        Text(AppLocalizations.of(context).adSubmitSuccessMessage),
                      Text('سوف يصلك اشعار اذا تم الموافقة علي تعديل الاعلان'),
                        const SizedBox(
                          height: 8,
                        ),
                        RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MyAdsScreen()));
                          },
                          child:
                          Text(MaterialLocalizations.of(context).okButtonLabel),
                        )
                      ],
                    ),
                  );
                if (state is NetworkErrorState ||
                    state is ErrorState ||
                    state is FieldState) {
                  return Center(
                    child: NetworkErrorWidget(
                      onRetry: () {
                        _bloc.dispatch(UpdateAd(
                          adId: widget.ad.id,
                          adTitle: _adTitleController.text,
                          adDescription: _adDetailsController.text,
//                          adCityId: ,
                          adLongitude: location.longitude,
                          adLatitude: location.latitude,
                          adPhone:_adPhoneNumberController.text
                        ));
                      },
                    ),
                  );
                }
                if (state is Loading)
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
                          'جاري تعديل الاعلان')
//                            '${state.loading == Loading.ad ? AppLocalizations.of(context).postAdLoading : AppLocalizations.of(context).postProductsLoading}')
                      ],
                    ),
                  );

                return ListView(children: <Widget>[
                  SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          SizedBox(height: 20,),

                          Card(
                            child: TextFormField(
                              controller: _adTitleController,
                              textInputAction: TextInputAction.next,
                              validator: (title) {
                                return title.isEmpty
                                    ? AppLocalizations.of(context).titleEmptyError
                                    : null;
                              },
                              maxLines: 1,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 10, bottom: 10),
                                labelText: AppLocalizations.of(context).adTitleLabel,
                              ),
                            ),
                          ),

                          SizedBox(height: 5,),

                          Card(
                            child: TextFormField(
                              controller: _adDetailsController,
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
                                contentPadding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                                labelText: AppLocalizations.of(context).adDescriptionLabel,
                                alignLabelWithHint: true,
                              ),
                            ),
                          ),

                          SizedBox(height: 5,),

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
                          SizedBox(height: 5,),

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

                          SizedBox(height: 5,),

                          Card(
                            child: ListTile(
                              dense: true,
                              onTap: (){
                                print('Location   ${widget.ad.lat}    ${widget.ad.lng}');
                                _onLocationPickerClicked(widget.ad.lat,widget.ad.lng);
                              },
                              trailing: IconButton(
                                  icon: Icon(Icons.place),
                                  onPressed: (){
                                    _onLocationPickerClicked(widget.ad.lat,widget.ad.lng);
                                  }),
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

                          SizedBox(height: 5,),

                          Card(
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (phoneNumber) {
                                return phoneNumber.isEmpty
                                    ? AppLocalizations.of(context)
                                    .phoneNumberEmptyError
                                    : null;
                              },
                              maxLines: 1,
                              textDirection: TextDirection.ltr,
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
                              ),
                            ),
                          ),

                        ],
                      ))
                ],);
              },
            ),
            listener: (BuildContext context, UpdateAdState state) {
              if (state is SessionExpiredState) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) =>
                        LoginScreen(NavigationReason.session_expired)));
              }
            },
          ))
    );
  }
}
