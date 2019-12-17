import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:justcost/data/ad/model/my_ads_response.dart';
import 'package:justcost/data/city/city_repository.dart';
import 'package:justcost/data/city/model/country.dart';
import 'package:justcost/data/product/model/product.dart';
import 'package:justcost/i10n/app_localizations.dart';
import 'package:justcost/screens/ad_details/ad_details_screen.dart';
import 'package:justcost/screens/postad/location_pick_screen.dart';
import 'package:justcost/widget/ad_tile.dart';
import 'package:justcost/widget/ad_widget.dart';
import 'package:justcost/widget/no_data_widget.dart';

import '../dependencies_provider.dart';

class MyAdEditScreen extends StatefulWidget {
  final Ad ad;

  MyAdEditScreen(this.ad,);

  @override
  _MyAdEditScreenState createState() => _MyAdEditScreenState();
}

class _MyAdEditScreenState extends State<MyAdEditScreen> {

  TextEditingController _adTitleController = new TextEditingController();
  TextEditingController _adDetailsController = new TextEditingController();
  TextEditingController _adPhoneNumberController = new TextEditingController();

  Country _selectedCountry;
  City _selectedCity;
  String _countryCode;
  List<Country> _countries = [];
  List<City> _cities = [];

  void loadData() async {
    CityRepository repository = DependenciesProvider.provide();
    var countriesData = await repository.getCountries();
    this._countries = countriesData.data;
  }

  LatLng location;

  Future _onLocationPickerClicked() async {
    var location = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LocationPickerScreen()));
    setState(() {
      this.location = location;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل الاعلان'),
//        Row(
//          children: <Widget>[
//            Text('تفاصيل الاعلان'),
////            Container(
////              height: 2,
////              width: 10,
////              color: Colors.white,
////            ),
////            Text(
////              '${widget.ad.adTitle}',
////            )
//          ],
//          mainAxisSize: MainAxisSize.min,
//          crossAxisAlignment: CrossAxisAlignment.start,
//          mainAxisAlignment: MainAxisAlignment.start,
//        ),
      actions: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 5),
            child: IconButton(icon: Icon(Icons.done_all,size: 25,color: Colors.white,), onPressed: null))
      ],
      ),
      body: ListView(children: <Widget>[
        SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 12.0, right: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'تفاصيل عامة',
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                      ],
                    ),
                  ),
                ),

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

                Container(
                  margin: EdgeInsets.only(left: 30,right: 30,top: 5,bottom: 5),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 10,),
                              Text('${AppLocalizations.of(context).adTitleLabel}',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 16)),),
                              SizedBox(height: 10,),
                              Text('${AppLocalizations.of(context).adDetailsTitle}',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 16))),
                              SizedBox(height: 10,),
                              Text('${AppLocalizations.of(context).adType}',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 16))),
                              SizedBox(height: 10,),
                              Text('${AppLocalizations.of(context).city}',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 16))),
                              SizedBox(height: 10,),
                              Text('${AppLocalizations.of(context).phoneNumberField}',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 16))),
//                              SizedBox(height: 10,),
//                              Container(height:40,child: Text('${AppLocalizations.of(context).emailFieldLabel}',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 16)))),
                              SizedBox(height: 10,),
                              Text('${AppLocalizations.of(context).status}',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 16))),
                              SizedBox(height: 10,),
                              Text('${AppLocalizations.of(context).adApproveStatus}',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 16))),
                              SizedBox(height: 10,),

                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 5,),
                              Text(':',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 20)),),
                              SizedBox(height: 5,),
                              Text(':',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 20))),
                              SizedBox(height: 5,),
                              Text(':',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 20))),
                              SizedBox(height: 5,),
                              Text(':',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 20))),
                              SizedBox(height: 5,),
                              Text(':',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 20))),
//                              SizedBox(height: 5,),
//                              Container(height:40,child: Center(child: Text(':',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 20))))),
                              SizedBox(height: 5,),
                              Text(':',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 20))),
                              SizedBox(height: 5,),
                              Text(':',style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 20))),
                              SizedBox(height: 5,),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 10,),
                              Text('${widget.ad.adTitle}',style: (TextStyle(fontWeight: FontWeight.normal,fontSize: 15)),),
                              SizedBox(height: 10,),
                              Text('${widget.ad.adDescription}',style: (TextStyle(fontWeight: FontWeight.normal,fontSize: 15))),
                              SizedBox(height: 10,),
                              Text(widget.ad.iswholesale ? AppLocalizations.of(context).wholesaleAdType : AppLocalizations.of(context).normalAdType,style: (TextStyle(fontWeight: FontWeight.normal,fontSize: 15))),
                              SizedBox(height: 10,),
                              Text(widget.ad.cityNameAr,style: (TextStyle(fontWeight: FontWeight.normal,fontSize: 15))),
                              SizedBox(height: 10,),
                              SizedBox(height: 10,),
                              Text(widget.ad.mobile,style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 16))),
//                              SizedBox(height: 10,),
//                              Container(height:40,child: Text(widget.ad.,style: (TextStyle(fontWeight: FontWeight.w600,fontSize: 16)))),
                              SizedBox(height: 10,),
                              Text(widget.ad.status == 1 ? AppLocalizations.of(context).active : AppLocalizations.of(context).inactive,style: (TextStyle(fontWeight: FontWeight.normal,fontSize: 15))),
                              SizedBox(height: 10,),
                              Text(widget.ad.status == 3 ? AppLocalizations.of(context).adApprovedStatus: widget.ad.status == 2 ? AppLocalizations.of(context).adRejectedStatus : widget.ad.status == 1 ? AppLocalizations.of(context).adPendingStatus : AppLocalizations.of(context).enable,style: (TextStyle(fontWeight: FontWeight.normal,fontSize: 15))),
                              SizedBox(height: 10,),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 12.0, right: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'منتجات الاعلان',
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                      ],
                    ),
                  ),
                ),

                widget.ad.products.length == 0 ? NoDataWidget():ListView.builder(
                  primary: false,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return AdWidget(
                      product: widget.ad.products[index],
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AdDetailsScreen(
                                  product: widget.ad.products[index],
                                )));
                      },
                    );
                  },
                  itemCount: widget.ad.products.length,
                  shrinkWrap: true,
                ),

              ],
            ))
      ],),
    );
  }
}
